#!/usr/bin/env python3
"""
HudHudScript Engine & Backend Benchmark Runner
==============================================
Kıyaslanan Engine & Backend Varyantları:
  1. vm            : Bytecode VM (--engine vm)
  2. jit-cranelift : JIT Native via Cranelift (--engine jit --backend cranelift)
  3. jit-gccjit    : JIT Native via GCCJIT (--engine jit --backend gccjit)
  4. jit-llvm      : JIT Native via LLVM 14  (--engine jit --backend llvm, --features llvm gerektirir)
  5. aot-default   : AOT Native Executable (hudhud build — varsayılan opt=2, backend=auto)
  6. aot-opt0/1/2/3: AOT + --opt N (not: opt2 ≡ aot-default, motorun varsayılanı 2)
  7. aot-cranelift : AOT via Cranelift backend (hudhud build --backend cranelift)
  8. aot-llvm      : AOT via LLVM backend (hudhud build --backend llvm)
  9. aot-gccjit    : AOT via GCCJIT backend (hudhud build --backend gccjit)

Kullanım:
    python3 run_benchmarks_engine.py
    python3 run_benchmarks_engine.py --runs 3
    python3 run_benchmarks_engine.py --only duffs_device,avl_insert,dijkstra
    python3 run_benchmarks_engine.py --engines vm,jit-cranelift,jit-llvm,aot-opt3
    python3 run_benchmarks_engine.py --json data/my_results.json
"""

import argparse
import json
import math
import os
import re
import subprocess
import sys
import tempfile
import time
from datetime import datetime, timezone
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
HHS_REPO = SCRIPT_DIR.parent / "hudhud-script"
DATA_DIR = SCRIPT_DIR / "data"
SOURCE_DIR = SCRIPT_DIR / "benchmarks" / "src" / "hudhud"
BINARY = HHS_REPO / "target" / "release" / "hudhud"

# ── ANSI Colors ────────────────────────────────────────────────────────
BOLD = "\033[1m"
CYAN = "\033[0;36m"
GREEN = "\033[0;32m"
YELLOW = "\033[1;33m"
RED = "\033[0;31m"
MAGENTA = "\033[0;35m"
GRAY = "\033[0;90m"
NC = "\033[0m"

# ── Correctness Helpers ───────────────────────────────────────────────
try:
    from check_correctness import GOLDEN, _extract_result, _values_match
    HAS_CORRECTNESS = True
except ImportError:
    HAS_CORRECTNESS = False
    GOLDEN = {}


def _check_golden(stdout: str, bench_key: str):
    """Sonuç değerini GOLDEN ile karşılaştır. (ok, hata) döndürür.

    GOLDEN'da olmayan benchmarklar doğrulanamaz → sessizce atlanır.
    """
    if not HAS_CORRECTNESS:
        return True, None
    golden = GOLDEN.get(bench_key)
    if golden is None:
        return True, None
    val = _extract_result(stdout or "", bench_key)
    if val is None:
        return False, "[GOLDEN] Result satırı çıkarılamadı"
    if not _values_match(val, golden, bench_key, "hudhud"):
        return False, f"[GOLDEN mismatch] beklenen={golden} gelen={str(val)[:80]}"
    return True, None


def _apply_golden(result: dict, bench_key: str) -> dict:
    """Koşu sonucuna GOLDEN denetimini uygula — uyuşmazlık ok=False yapar."""
    ok, err = _check_golden(result.get("stdout") or "", bench_key)
    if not ok:
        result["ok"] = False
        result["error"] = err
    return result

# ── Benchmark Metadata Import ──────────────────────────────────────────
try:
    from run_benchmarks import BENCHMARKS
except ImportError:
    BENCHMARKS = {}


def find_binary() -> Path:
    if BINARY.exists() and os.access(BINARY, os.X_OK):
        return BINARY
    print(f"{RED}✗  hudhud release binary bulunamadı: {BINARY}{NC}")
    print(f"   Lütfen önce derleyin: cargo build --release --features jit,aot,gccjit")
    sys.exit(1)


def check_backend_support(binary: Path, backend: str) -> bool:
    """hudhud ikilisinin bir JIT backend'ini destekleyip desteklemediğini kontrol eder."""
    try:
        proc = subprocess.run(
            [str(binary), "run", "/dev/null", "--engine", "jit", "--backend", backend],
            capture_output=True,
            text=True,
            timeout=5,
        )
        combined = proc.stdout + proc.stderr
        if f"{backend} backend requires --features" in combined or f"not implemented in {backend}" in combined:
            return False
        return proc.returncode == 0
    except Exception:
        return False


def ensure_features(binary: Path, needed_backends: set) -> Path:
    """
    Binary varlığını ve istenen backend'lerin (gccjit/llvm) feature desteğini
    kontrol eder. Eksikse '--features jit,aot,<backends>' ile otomatik derler.
    """
    reasons = []
    if not (binary.exists() and os.access(binary, os.X_OK)):
        reasons.append("binary bulunamadı")
    else:
        for b in sorted(needed_backends):
            if not check_backend_support(binary, b):
                reasons.append(f"{b} feature desteği eksik")

    if reasons:
        features = ["jit", "aot"] + sorted(needed_backends)
        native_flags = "-C target-cpu=native -C link-args=-rdynamic"
        print(f"{YELLOW}⚡ hudhud derleme kontrolü: {', '.join(reasons)}.{NC}")
        print(f"{CYAN}   'cargo build --release -p hudhudscript-cli -p hudhudscript-native-abi --features {','.join(features)}' başlatılıyor...{NC}")
        print(f"{CYAN}   RUSTFLAGS: {native_flags}{NC}")
        cmd = [
            "cargo",
            "build",
            "--release",
            "-p",
            "hudhudscript-cli",
            "-p",
            "hudhudscript-native-abi",
            "--features",
            ",".join(features),
        ]
        env = os.environ.copy()
        # Mevcut RUSTFLAGS'i ezmeden native derleme bayraklarını ekle
        env["RUSTFLAGS"] = (env.get("RUSTFLAGS", "") + " " + native_flags).strip()
        t0 = time.perf_counter()
        proc = subprocess.run(cmd, cwd=str(HHS_REPO), env=env, capture_output=True, text=True)
        if proc.returncode != 0:
            print(f"{RED}✗  Derleme başarısız oldu:\n{proc.stderr[-500:] if proc.stderr else proc.stdout[-500:]}{NC}")
            if not binary.exists():
                sys.exit(1)
        else:
            elapsed = round(time.perf_counter() - t0, 1)
            print(f"{GREEN}✓  hudhud ikilisi {','.join(features)} desteği ile güncellendi ({elapsed}s).{NC}\n")

    return binary


def get_binary_version(binary: Path) -> str:
    try:
        out = subprocess.run([str(binary), "--version"], capture_output=True, text=True, timeout=5)
        m = re.search(r"(\d+\.\d+\.\d+)", (out.stdout + out.stderr))
        return m.group(1) if m else "unknown"
    except Exception:
        return "unknown"


# ── Engine Definitions ────────────────────────────────────────────────
# ALL_ENGINES: --engines ile seçilebilenlerin tamamı
# DEFAULT_ENGINES: argüman verilmezde koşulanlar
ALL_ENGINES = [
    "vm",
    "jit-cranelift", "jit-gccjit", "jit-llvm",
    "aot-default", "aot-opt0", "aot-opt1", "aot-opt2", "aot-opt3",
    "aot-cranelift", "aot-llvm", "aot-gccjit",
]
DEFAULT_ENGINES = [
    "vm",
    "jit-cranelift", "jit-gccjit", "jit-llvm",
    "aot-default", "aot-opt3", "aot-llvm",
]

ENGINE_LABELS = {
    "vm": "VM (Bytecode)",
    "jit-cranelift": "JIT (Cranelift)",
    "jit-gccjit": "JIT (GCCJIT)",
    "jit-llvm": "JIT (LLVM)",
    "aot-default": "AOT (Default=opt2)",
    "aot-opt0": "AOT (Opt 0)",
    "aot-opt1": "AOT (Opt 1)",
    "aot-opt2": "AOT (Opt 2)",
    "aot-opt3": "AOT (Opt 3)",
    "aot-cranelift": "AOT (Cranelift)",
    "aot-llvm": "AOT (LLVM)",
    "aot-gccjit": "AOT (GCCJIT)",
}

SHORT_LABELS = {
    "vm": "VM",
    "jit-cranelift": "JIT-CL",
    "jit-gccjit": "JIT-GCC",
    "jit-llvm": "JIT-LLVM",
    "aot-default": "AOT-DEF",
    "aot-opt0": "AOT-O0",
    "aot-opt1": "AOT-O1",
    "aot-opt2": "AOT-O2",
    "aot-opt3": "AOT-O3",
    "aot-cranelift": "AOT-CL",
    "aot-llvm": "AOT-LLVM",
    "aot-gccjit": "AOT-GCC",
}


def _timed_run(cmd: list, timeout: int, env=None) -> dict:
    """Komutu çalıştır, duvar saatini ms olarak ölç."""
    t0 = time.perf_counter()
    proc = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout,
                          cwd=str(HHS_REPO), env=env)
    elapsed_ms = round((time.perf_counter() - t0) * 1000)
    ok = proc.returncode == 0
    return {
        "ok": ok,
        "ms": elapsed_ms,
        "compile_ms": 0,
        "stdout": proc.stdout,
        "stderr": proc.stderr,
        "error": proc.stderr[:300] if not ok else None,
    }


def run_engine_once(engine: str, source_path: Path, timeout: int = 60, verbose: bool = False) -> dict:
    """Tek bir engine modunda benchmark'ı çalıştırır, süreyi ölçer ve sonucu
    GOLDEN ile doğrular (yanlış sonuç üreten backend 'ok' sayılmaz)."""
    binary_str = str(BINARY)
    bench_key = source_path.stem

    if engine == "vm":
        cmd = [binary_str, "run", str(source_path), "--engine", "vm"]
        return _apply_golden(_timed_run(cmd, timeout), bench_key)

    if engine.startswith("jit-"):
        backend = engine.split("-", 1)[1]
        cmd = [binary_str, "run", str(source_path), "--engine", "jit", "--backend", backend]
        r = _timed_run(cmd, timeout)
        combined = r["stderr"] + r["stdout"]
        if not r["ok"] and (
            f"{backend} backend requires --features" in combined
            or f"not implemented in {backend}" in combined
        ):
            r["unsupported"] = True
            r["ms"] = None
            r["error"] = f"requires --features {backend}"
            return r
        return _apply_golden(r, bench_key)

    if engine.startswith("aot-"):
        # AOT: 1. Build Executable -> 2. Run Executable
        # aot-default : --backend auto (cranelift), opt varsayılanı 2
        # aot-optN    : --opt N
        # aot-llvm/gccjit : --backend <ad>
        variant = engine.split("-", 1)[1]
        with tempfile.NamedTemporaryFile(suffix="", delete=False, dir="/tmp") as f:
            tmp_bin = f.name
        try:
            build_cmd = [binary_str, "build", str(source_path), "-o", tmp_bin]
            if variant.startswith("opt"):
                build_cmd.extend(["--opt", variant[3:]])
            elif variant in ("llvm", "gccjit", "cranelift"):
                build_cmd.extend(["--backend", variant])

            env = os.environ.copy()
            runtime_lib = HHS_REPO / "target" / "release" / "libhudhudscript_native_abi.a"
            if runtime_lib.exists():
                env["HUDHUD_RUNTIME_LIB"] = str(runtime_lib)

            t_compile_0 = time.perf_counter()
            c_proc = subprocess.run(build_cmd, capture_output=True, text=True, timeout=timeout, cwd=str(HHS_REPO), env=env)
            compile_ms = round((time.perf_counter() - t_compile_0) * 1000)

            if c_proc.returncode != 0:
                combined = c_proc.stdout + c_proc.stderr
                if "requires --features" in combined:
                    return {
                        "ok": False,
                        "unsupported": True,
                        "ms": None,
                        "compile_ms": compile_ms,
                        "stdout": c_proc.stdout,
                        "stderr": c_proc.stderr,
                        "error": f"AOT backend requires --features ({combined[:200]})",
                    }
                return {
                    "ok": False,
                    "ms": None,
                    "compile_ms": compile_ms,
                    "stdout": c_proc.stdout,
                    "stderr": c_proc.stderr,
                    "error": f"AOT build failed: {c_proc.stderr[:300]}",
                }

            t_run_0 = time.perf_counter()
            r_proc = subprocess.run([tmp_bin], capture_output=True, text=True, timeout=timeout)
            run_ms = round((time.perf_counter() - t_run_0) * 1000)
            ok = r_proc.returncode == 0

            return _apply_golden({
                "ok": ok,
                "ms": run_ms,
                "compile_ms": compile_ms,
                "stdout": r_proc.stdout,
                "stderr": r_proc.stderr,
                "error": r_proc.stderr[:300] if not ok else None,
            }, bench_key)
        finally:
            if os.path.exists(tmp_bin):
                try:
                    os.unlink(tmp_bin)
                except OSError:
                    pass

    return {"ok": False, "ms": None, "error": f"Unknown engine: {engine}"}


def calculate_stats(runs_data: list, statistic: str = "median") -> dict:
    valid_ms = [r["ms"] for r in runs_data if r.get("ok") and r.get("ms") is not None]
    if not valid_ms:
        unsupported = any(r.get("unsupported") for r in runs_data)
        # Fail sebebi kaybolmasın: ilk başarısız koşunun hatası özet olarak taşınır
        err = next(
            (r.get("error") or (r.get("stderr") or "").strip()[:200] or None
             for r in runs_data if not r.get("ok")),
            None,
        )
        return {
            "ok": False,
            "selected_ms": None,
            "unsupported": unsupported,
            "error": err,
            "runs": runs_data,
        }

    sv = sorted(valid_ms)
    n = len(sv)
    if statistic == "median":
        if n % 2 == 1:
            sel = float(sv[n // 2])
        else:
            sel = (sv[n // 2 - 1] + sv[n // 2]) / 2.0
    elif statistic == "min":
        sel = float(sv[0])
    else:
        sel = sum(valid_ms) / len(valid_ms)

    return {
        "ok": True,
        "selected_ms": sel,
        "min_ms": min(valid_ms),
        "max_ms": max(valid_ms),
        "runs": runs_data,
        "unsupported": False,
    }


def strip_ansi(s: str) -> str:
    return re.sub(r"\033\[[0-9;]*m", "", s)


def ansi_ljust(s: str, width: int) -> str:
    vis_len = len(strip_ansi(s))
    return s + " " * max(0, width - vis_len)


def ansi_rjust(s: str, width: int) -> str:
    vis_len = len(strip_ansi(s))
    return " " * max(0, width - vis_len) + s


def format_delta(base_ms: float | None, target_ms: float | None) -> str:
    """Yüzdesel hızlanma / yavaşlama formatlar."""
    if base_ms is None or target_ms is None or base_ms <= 0:
        return f"{GRAY}     N/A{NC}"
    delta = ((target_ms - base_ms) / base_ms) * 100.0
    val_str = f"{delta:>+7.1f}%"
    if delta < -5.0:
        return f"{GREEN}{val_str}{NC}"
    elif delta > 5.0:
        return f"{RED}{val_str}{NC}"
    else:
        return f"{YELLOW}{val_str}{NC}"


def geometric_mean(values: list[float]) -> float:
    positive = [v for v in values if v > 0]
    if not positive:
        return 0.0
    return math.exp(sum(math.log(v) for v in positive) / len(positive))


# ── Main Runner ───────────────────────────────────────────────────────
def main():
    parser = argparse.ArgumentParser(
        description="HudHudScript Engine & Backend Benchmark Runner",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("--runs", type=int, default=1, help="Benchmark başına tekrar sayısı (default: 1)")
    parser.add_argument("--warmups", type=int, default=0, help="Ölçülmeyen ısınma koşusu sayısı (default: 0)")
    parser.add_argument("--only", type=str, default=None, help="Yalnızca belirtilen benchmarkları çalıştır (virgülle ayrılmış)")
    parser.add_argument(
        "--engines",
        type=str,
        default=",".join(DEFAULT_ENGINES),
        help=f"Çalıştırılacak engine listesi (default: {','.join(DEFAULT_ENGINES)}; "
             f"tümü: {','.join(ALL_ENGINES)})",
    )
    parser.add_argument("--json", type=str, default="data/benchmark_engine_results.json", help="Sonuç JSON dosyası")
    parser.add_argument("--timeout", type=int, default=60, help="Koşu başına timeout saniye (default: 60)")
    parser.add_argument("--statistic", choices=["median", "min", "avg"], default="median", help="Seçilen istatistik (default: median)")
    parser.add_argument("-v", "--verbose", action="store_true", help="Ayrıntılı hata ve derleme çıktılarını göster")
    parser.add_argument("--no-rebuild", action="store_true", help="Otomatik binary / gccjit derleme kontrolünü atla")

    args = parser.parse_args()

    selected_engines = []
    for e in args.engines.split(","):
        e = e.strip()
        if not e:
            continue
        if e not in ALL_ENGINES:
            print(f"{RED}Bilinmeyen engine: '{e}'. Mevcut motorlar: {', '.join(ALL_ENGINES)}{NC}")
            sys.exit(1)
        if e not in selected_engines:
            selected_engines.append(e)
    if not selected_engines:
        print(f"{RED}Geçerli bir engine seçilmedi. Mevcut motorlar: {', '.join(ALL_ENGINES)}{NC}")
        sys.exit(1)

    # Seçilen motorların gerektirdiği ek backend feature'ları (gccjit/llvm)
    needed_backends = set()
    if not args.no_rebuild:
        for e in selected_engines:
            for b in ("gccjit", "llvm"):
                if b in e:
                    needed_backends.add(b)
    ensure_features(BINARY, needed_backends)
    version = get_binary_version(BINARY)

    # Benchmark listesini belirle
    bench_items = []
    if BENCHMARKS:
        for stem, meta in BENCHMARKS.items():
            p = SOURCE_DIR / f"{stem}.hud"
            if p.exists():
                title = meta.get("title", stem.replace("_", " ").title())
                bench_items.append((stem, title, p))

    if not bench_items:
        all_hud_files = sorted(list(SOURCE_DIR.glob("*.hud")))
        if not all_hud_files:
            print(f"{RED}Kaynak dizininde .hud dosyası bulunamadı: {SOURCE_DIR}{NC}")
            sys.exit(1)
        for p in all_hud_files:
            stem = p.stem
            meta = BENCHMARKS.get(stem, {}) if BENCHMARKS else {}
            title = meta.get("title", stem.replace("_", " ").title())
            bench_items.append((stem, title, p))

    if args.only:
        filter_keys = [k.strip().lower() for k in args.only.split(",")]

        def matches(b_key: str, b_title: str, fk: str) -> bool:
            k_norm = b_key.lower().replace("_", "").replace("-", "")
            t_norm = b_title.lower().replace(" ", "").replace("_", "").replace("-", "")
            fk_norm = fk.lower().replace(" ", "").replace("_", "").replace("-", "")
            return (
                fk_norm == k_norm
                or fk_norm == t_norm
                or fk_norm in k_norm
                or k_norm in fk_norm
                or fk_norm in t_norm
            )

        bench_items = [
            b for b in bench_items
            if any(matches(b[0], b[1], fk) for fk in filter_keys)
        ]

    print(f"{BOLD}{CYAN}══════════════════════════════════════════════════════════════════════════{NC}")
    print(f"{BOLD}  HudHudScript Engine & Backend Karşılaştırmalı Benchmark Koşusu{NC}")
    print(f"  Binary       : {BINARY} (v{version})")
    print(f"  Benchmark    : {len(bench_items)} adet")
    print(f"  Motorlar     : {', '.join(ENGINE_LABELS[e] for e in selected_engines)}")
    print(f"  Tekrar       : {args.runs} koşu ({args.statistic})")
    print(f"{BOLD}{CYAN}══════════════════════════════════════════════════════════════════════════{NC}\n")

    results_data = []
    start_total = time.perf_counter()

    for idx, (bench_key, bench_title, source_path) in enumerate(bench_items, 1):
        print(f"{BOLD}[{idx:>2d}/{len(bench_items)}] {bench_title:<28s}{NC} ", end="", flush=True)

        bench_row = {
            "key": bench_key,
            "title": bench_title,
            "path": str(source_path),
            "engines": {},
        }

        row_print_items = []

        for engine in selected_engines:
            # Warmup runs
            for _ in range(args.warmups):
                run_engine_once(engine, source_path, timeout=args.timeout, verbose=args.verbose)

            # Measured runs
            runs = []
            for _ in range(args.runs):
                r = run_engine_once(engine, source_path, timeout=args.timeout, verbose=args.verbose)
                runs.append(r)

            stats = calculate_stats(runs, statistic=args.statistic)
            bench_row["engines"][engine] = stats

            sel_ms = stats.get("selected_ms")
            if stats.get("unsupported"):
                row_print_items.append(f"{GRAY}{engine}: N/A{NC}")
            elif stats["ok"] and sel_ms is not None:
                row_print_items.append(f"{CYAN}{engine}:{NC} {GREEN}{round(sel_ms):>4d}ms{NC}")
            else:
                row_print_items.append(f"{RED}{engine}: ✗{NC}")

        print(" │ ".join(row_print_items))
        results_data.append(bench_row)

    total_duration = round(time.perf_counter() - start_total, 1)

    # ── Özet Tablosu (dinamik kolonlar) ────────────────────────────────
    cw, bw = 9, 24
    has_jit = any(e.startswith("jit-") for e in selected_engines)
    has_aot = any(e.startswith("aot-") for e in selected_engines)
    extra_labels = (["JIT vs VM"] if has_jit else []) + (["AOT vs VM"] if has_aot else []) + ["Winner"]
    total_cols = len(selected_engines) + len(extra_labels)
    inner_w = (bw + 2) + total_cols * (cw + 3)

    def _border(lo: str, mi: str, ro: str) -> str:
        s = lo + "─" * (bw + 2)
        for _ in range(total_cols):
            s += mi + "─" * (cw + 2)
        return s + ro

    def _row(title: str, cells: list) -> str:
        parts = [f" {ansi_ljust(title[:bw], bw)} "]
        for c in cells:
            parts.append(f" {ansi_rjust(c, cw)} ")
        return "│" + "│".join(parts) + "│"

    def _fmt_ms(v):
        return f"{round(v):>6d}ms" if v is not None else f"{GRAY}     N/A{NC}"

    print()
    print(f"{BOLD}{CYAN}{_border('┌', '┬', '┐')}{NC}")
    title_str = f"ÖZET — {len(bench_items)} Benchmark × {len(selected_engines)} Engine (v{version})"
    print(f"{BOLD}{CYAN}│{NC} {BOLD}{title_str}{' ' * max(0, inner_w - len(title_str) - 2)}{CYAN}│{NC}")
    print(f"{BOLD}{CYAN}{_border('├', '┼', '┤')}{NC}")
    print(f"{BOLD}{_row('Benchmark', [SHORT_LABELS[e] for e in selected_engines] + extra_labels)}{NC}")
    print(f"{BOLD}{CYAN}{_border('├', '┼', '┤')}{NC}")

    totals = {e: [] for e in selected_engines}
    wins = {e: 0 for e in selected_engines}

    for b in results_data:
        eng_data = b["engines"]

        for e in selected_engines:
            v = eng_data.get(e, {}).get("selected_ms")
            if v is not None:
                totals[e].append(v)

        # Fastest winner
        valid_candidates = [
            (e, eng_data[e]["selected_ms"])
            for e in selected_engines
            if eng_data.get(e, {}).get("ok") and eng_data.get(e, {}).get("selected_ms") is not None
        ]
        if valid_candidates:
            winner, _ = min(valid_candidates, key=lambda x: x[1])
            wins[winner] += 1
            winner_str = winner.replace("aot-", "AOT-").replace("jit-", "JIT-")
        else:
            winner_str = "-"

        vm_ms = eng_data.get("vm", {}).get("selected_ms")
        jit_best = min(
            (eng_data[e]["selected_ms"] for e in selected_engines
             if e.startswith("jit-") and eng_data.get(e, {}).get("selected_ms") is not None),
            default=None,
        )
        aot_best = min(
            (eng_data[e]["selected_ms"] for e in selected_engines
             if e.startswith("aot-") and eng_data.get(e, {}).get("selected_ms") is not None),
            default=None,
        )

        cells = []
        for e in selected_engines:
            st = eng_data.get(e, {})
            if st.get("unsupported"):
                cells.append(f"{GRAY}     N/A{NC}")
            elif st.get("ok") and st.get("selected_ms") is not None:
                cells.append(_fmt_ms(st["selected_ms"]))
            else:
                cells.append(f"{RED}      ✗{NC}")
        if has_jit:
            cells.append(format_delta(vm_ms, jit_best))
        if has_aot:
            cells.append(format_delta(vm_ms, aot_best))
        cells.append(winner_str)

        print(_row(b["title"], cells))

    print(f"{BOLD}{CYAN}{_border('├', '┼', '┤')}{NC}")

    # Toplam ve Ortalama satırları
    def fmt_sum(lst):
        return f"{round(sum(lst)):>6d}ms" if lst else f"{GRAY}     N/A{NC}"

    def fmt_avg(lst):
        return f"{round(sum(lst) / len(lst)):>6d}ms" if lst else f"{GRAY}     N/A{NC}"

    def fmt_gmean(lst):
        return f"{round(geometric_mean(lst)):>6d}ms" if lst else f"{GRAY}     N/A{NC}"

    vm_avg = sum(totals["vm"]) / len(totals["vm"]) if totals.get("vm") else None

    def best_family_avg(prefix):
        vals = [v for e in selected_engines if e.startswith(prefix) for v in totals[e]]
        return sum(vals) / len(vals) if vals else None

    jit_avg_delta = format_delta(vm_avg, best_family_avg("jit-")) if has_jit else ""
    aot_avg_delta = format_delta(vm_avg, best_family_avg("aot-")) if has_aot else ""

    def _summary_row(label, fmt):
        cells = [fmt(totals[e]) for e in selected_engines]
        if has_jit:
            cells.append(jit_avg_delta if label == "Aritmetik Ortalama" else "")
        if has_aot:
            cells.append(aot_avg_delta if label == "Aritmetik Ortalama" else "")
        cells.append("")
        print(f"{BOLD}{_row(label, cells)}{NC}")

    _summary_row("Toplam Süre", fmt_sum)
    _summary_row("Aritmetik Ortalama", fmt_avg)
    _summary_row("Geometrik Ortalama", fmt_gmean)
    print(f"{BOLD}{CYAN}{_border('└', '┴', '┘')}{NC}")

    # Kazanma sayıları özeti
    print(f"\n{BOLD}🏆  Birincilik Sayıları (Winner Breakdown):{NC}")
    for e in selected_engines:
        print(f"    • {ENGINE_LABELS[e]:<18s} : {BOLD}{wins[e]}{NC} benchmark")

    print(f"\n⏱  Toplam Benchmark Koşu Süresi: {BOLD}{total_duration}s{NC}")

    # JSON çıktısını kaydet
    out_json_path = SCRIPT_DIR / args.json
    out_json_path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "timestamp": datetime.now(timezone.utc).astimezone().isoformat(),
        "hudhud_version": version,
        "runs": args.runs,
        "statistic": args.statistic,
        "total_benchmarks": len(bench_items),
        "total_duration_sec": total_duration,
        "wins": wins,
        "benchmarks": results_data,
    }
    with open(out_json_path, "w", encoding="utf-8") as f:
        json.dump(payload, f, indent=2, ensure_ascii=False)
    print(f"{GREEN}✓  Sonuçlar kaydedildi: {out_json_path}{NC}")

    # ── Geçmiş arşivi: her koşu ayrı dosyada tutulur (web'de sürüm kıyaslaması için) ──
    history_dir = DATA_DIR / "engine_history"
    history_dir.mkdir(parents=True, exist_ok=True)
    ts_tag = datetime.now(timezone.utc).astimezone().strftime("%Y%m%d-%H%M%S")
    safe_ver = re.sub(r"[^0-9A-Za-z._-]", "_", version or "unknown")
    hist_path = history_dir / f"{ts_tag}_v{safe_ver}.json"
    with open(hist_path, "w", encoding="utf-8") as f:
        json.dump(payload, f, indent=2, ensure_ascii=False)
    print(f"{GREEN}✓  Geçmişe kaydedildi: {hist_path}{NC}\n")


if __name__ == "__main__":
    main()
