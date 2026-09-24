#!/usr/bin/env python3
"""
HudHudScript — Dil Özelliği Sample Runner (Profilingsiz)
=========================================================
Dilin tüm dil özelliklerini (SOP, OOP, loops, async vb.) sınayan
sample'ları doğrudan çalıştırır ve doğrular.
Profiling (flamegraph, callgrind, heaptrack) İÇERMEZ.

Kullanım:
    python3 run_samples.py
    python3 run_samples.py --engine vm
    python3 run_samples.py --engine jit
    python3 run_samples.py --only variables,arithmetic
    python3 run_samples.py --tier core
"""

import argparse
import json
import os
import subprocess
import sys
import tempfile
import time
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
HHS_REPO = SCRIPT_DIR.parent / "hudhud-script"
DATA_DIR = SCRIPT_DIR / "data"
RESULTS_FILE = DATA_DIR / "sample_results.json"

# ANSI Renkleri
BOLD = "\033[1m"
CYAN = "\033[0;36m"
GREEN = "\033[0;32m"
YELLOW = "\033[1;33m"
RED = "\033[0;31m"
GRAY = "\033[0;90m"
NC = "\033[0m"


def find_binary() -> Path:
    """hudhud binary'sini bulur (Linux'ta 'hudhud', Windows'ta 'hudhud.exe')."""
    base = HHS_REPO / "target" / "release" / "hudhud"
    if sys.platform == "win32" or os.name == "nt":
        exe = base.with_suffix(".exe")
        return exe if exe.exists() else base
    return base


def load_samples() -> dict:
    """hudhud-script-interactive altındaki SAMPLES sözlüğünü yükler."""
    interactive_dir = SCRIPT_DIR.parent / "hudhud-script-interactive"
    if interactive_dir.exists():
        if str(interactive_dir) not in sys.path:
            sys.path.insert(0, str(interactive_dir))
        try:
            from run_samples_profile import SAMPLES  # type: ignore
            return SAMPLES
        except ImportError:
            pass

    # Fallback: Temel çekirdek sample'lar
    return {
        "variables": {
            "title": "Variables & literals",
            "feature": "let/var, int/float/bool/string/null",
            "tier": "core",
            "mode": "run",
            "hudhud": (
                "let a = 10; var b = 3.5; let c = true;\n"
                "for (let i = 0; i < 10000; i = i + 1) { a = a + 1; b = b + 0.5; }\n"
                "print('a=' + a);\nprint('DONE');\n"
            ),
        },
        "arithmetic": {
            "title": "Arithmetic",
            "feature": "+ - * / % precedence",
            "tier": "core",
            "mode": "run",
            "hudhud": (
                "let s = 0;\n"
                "for (let i = 1; i < 10000; i = i + 1) { s = s + (i * 2 + 3 - i / 2) % 7; }\n"
                "print('s=' + s);\nprint('DONE');\n"
            ),
        },
    }


def find_samples_recursively(base_dir: Path, include_archive: bool = False) -> dict:
    """Belirtilen dizin altındaki tüm .hud ve .hudhud dosyalarını recursive olarak bulur."""
    samples = {}
    if not base_dir.exists():
        return samples

    for ext in ("*.hud", "*.hudhud"):
        for file_path in sorted(base_dir.rglob(ext)):
            rel = file_path.relative_to(base_dir)
            parts = rel.parts
            if not include_archive and "_archive" in parts:
                continue
            tier = parts[0] if len(parts) > 1 else "root"
            name = str(rel).replace("\\", "/")
            samples[name] = {
                "title": file_path.name,
                "feature": f"Dosya: {name}",
                "tier": tier,
                "mode": "run",
                "file_path": file_path,
            }
    return samples


def verify_sample(binary: Path, name: str, meta: dict, engine: str = None, backend: str = None, timeout: int = 60):
    """Tek bir sample'ı çalıştırır / doğrular."""
    mode = meta.get("mode", "run")
    subcmd = "run" if mode == "run" else "check"
    file_path = meta.get("file_path")
    created_temp = False

    if file_path:
        target_path = str(file_path)
    else:
        with tempfile.NamedTemporaryFile(suffix=".hud", delete=False, mode="w", encoding="utf-8") as f:
            f.write(meta.get("hudhud", ""))
            target_path = f.name
            created_temp = True

    env = os.environ.copy()
    env["RUST_MIN_STACK"] = "8388608"

    cmd = [str(binary), subcmd]
    if subcmd == "run" and engine:
        cmd += ["--engine", engine]
        if backend:
            cmd += ["--backend", backend]
    cmd.append(target_path)

    start = time.perf_counter()
    try:
        run_cwd = str(file_path.parent if file_path else HHS_REPO)
        proc = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=timeout,
            cwd=run_cwd,
            env=env,
        )
        ms = round((time.perf_counter() - start) * 1000)

        if file_path:
            ok = proc.returncode == 0
        else:
            if mode == "run":
                ok = proc.returncode == 0 and "DONE" in proc.stdout
            else:
                ok = proc.returncode == 0 and "Syntax OK" in (proc.stdout + proc.stderr)

        err_msg = proc.stderr.strip() if proc.returncode != 0 else ""
        return ok, ms, proc.stdout[:2000], err_msg[:1000]
    except subprocess.TimeoutExpired:
        return False, timeout * 1000, "", f"Zaman aşımı ({timeout}s)"
    except Exception as e:
        return False, 0, "", str(e)
    finally:
        if created_temp:
            try:
                os.unlink(target_path)
            except OSError:
                pass


def main():
    parser = argparse.ArgumentParser(
        description="HudHudScript Language Feature Sample Runner (Profiling Olmadan)"
    )
    parser.add_argument("-r", "--recursive", action="store_true",
                        help="Örnek dosyalarını diskten recursive olarak tara ve çalıştır (varsayılan: ../hudhud-script/examples)")
    parser.add_argument("--dir", default=None,
                        help="Recursive taranacak özel dizin yolu (belirtilirse otomatik recursive moduna geçer)")
    parser.add_argument("--include-archive", action="store_true",
                        help="_archive klasöründeki eski/arşivlenmiş dosyaları da dahil et")
    parser.add_argument("--engine", choices=["vm", "jit"], default=None,
                        help="Kullanılacak yürütme motoru (vm | jit). Boş bırakılırsa varsayılan motor kullanılır.")
    parser.add_argument("--backend", default=None,
                        help="JIT backend seçimi (örn: cranelift, gccjit, llvm)")
    parser.add_argument("--only", default="",
                        help="Virgülle ayrılmış arama filtreleri (örn: variables, hello, 01-basics)")
    parser.add_argument("--tier", default="",
                        help="Filtrelenecek seviye / alt dizin (örn: core, 01-basics, 02-sop)")
    parser.add_argument("--mode", choices=["run", "check"], default="",
                        help="Filtrelenecek mod (run | check)")
    parser.add_argument("--timeout", type=int, default=60,
                        help="Sample başına maksimum çalışma süresi (saniye, varsayılan: 60)")
    parser.add_argument("--no-save", action="store_true",
                        help="Sonuçları data/sample_results.json dosyasına yazma")

    args = parser.parse_args()

    binary = find_binary()
    if not binary.exists():
        print(f"{RED}✗ hudhud binary bulunamadı: {binary}{NC}")
        print(f"{GRAY}  Derlemek için: cargo build --release --manifest-path ../hudhud-script/Cargo.toml -p hudhudscript-cli --bin hudhud{NC}")
        sys.exit(1)

    is_recursive = args.recursive or (args.dir is not None)
    if is_recursive:
        target_dir = Path(args.dir).resolve() if args.dir else (HHS_REPO / "examples")
        if not target_dir.exists():
            print(f"{RED}✗ Belirtilen dizin bulunamadı: {target_dir}{NC}")
            sys.exit(1)
        samples = find_samples_recursively(target_dir, include_archive=args.include_archive)
        if not samples:
            print(f"{YELLOW}Belirtilen dizinde .hud / .hudhud dosyası bulunamadı: {target_dir}{NC}")
            sys.exit(1)
    else:
        target_dir = None
        samples = load_samples()

    names = list(samples.keys())

    if args.only:
        filter_terms = [n.strip().lower() for n in args.only.split(",") if n.strip()]
        names = [n for n in names if any(term in n.lower() for term in filter_terms)]
        if not names:
            print(f"{RED}Belirtilen filtreyle eşleşen sample bulunamadı: {args.only}{NC}")
            sys.exit(1)

    if args.tier:
        names = [n for n in names if samples[n].get("tier") == args.tier]

    if args.mode:
        names = [n for n in names if samples[n].get("mode") == args.mode]

    engine_desc = f" --engine {args.engine}" if args.engine else " (varsayılan)"
    if args.backend:
        engine_desc += f" --backend {args.backend}"

    source_desc = f"Disk (Recursive): {target_dir}" if is_recursive else "Dahili Özellik Suite'i (33 test)"

    print(f"\n{BOLD}{CYAN}═══════════════════════════════════════════════════════════════{NC}")
    print(f"{BOLD}HudHudScript Dil Özelliği Sample Runner (Profilingsiz){NC}")
    print(f"Kaynak: {source_desc}")
    print(f"Binary: {GREEN}{binary.name}{NC} ({binary})")
    print(f"Motor:  {CYAN}{engine_desc.strip()}{NC}")
    print(f"Toplam: {len(names)} sample çalıştırılacak")
    print(f"{BOLD}{CYAN}═══════════════════════════════════════════════════════════════{NC}\n")

    records = []
    passed_count = 0
    failed_count = 0
    total_time_ms = 0

    for name in names:
        meta = samples[name]
        tier = meta.get("tier", "core")
        mode = meta.get("mode", "run")

        ok, ms, out, err = verify_sample(
            binary=binary,
            name=name,
            meta=meta,
            engine=args.engine,
            backend=args.backend,
            timeout=args.timeout,
        )

        total_time_ms += ms
        if ok:
            passed_count += 1
            print(f"  {GREEN}✓{NC} {name:24} {ms:5d}ms  [{mode.upper():5} / {tier}]")
        else:
            failed_count += 1
            print(f"  {RED}✗ FAIL{NC} {name:24} {ms:5d}ms  [{mode.upper():5} / {tier}]")
            if err.strip():
                print(f"    {GRAY}{err.strip()[:180]}{NC}")

        records.append({
            "sample": name,
            "title": meta.get("title", ""),
            "feature": meta.get("feature", ""),
            "tier": tier,
            "mode": mode,
            "ok": ok,
            "ms": ms,
            "stdout": out,
            "stderr": err,
        })

    # Sonuçları kaydet
    if not args.no_save:
        DATA_DIR.mkdir(parents=True, exist_ok=True)
        RESULTS_FILE.write_text(json.dumps(records, indent=2, ensure_ascii=False))

    print(f"\n{BOLD}───────────────────────────────────────────────────────────────{NC}")
    if failed_count == 0:
        print(f"{GREEN}{BOLD}TÜM TESTLER GEÇTİ: {passed_count}/{len(names)} ({total_time_ms} ms){NC}")
    else:
        print(f"{YELLOW}{BOLD}SONUÇ: {passed_count} geçti, {RED}{failed_count} başarısız{NC} / {len(names)} toplam ({total_time_ms} ms)")

    if not args.no_save:
        print(f"{GRAY}Detaylı JSON: {RESULTS_FILE}{NC}")
    print(f"{BOLD}───────────────────────────────────────────────────────────────{NC}\n")

    sys.exit(0 if failed_count == 0 else 1)


if __name__ == "__main__":
    main()
