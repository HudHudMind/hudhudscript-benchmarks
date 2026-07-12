#!/usr/bin/env python3
"""GATE-1: Baseline benchmark runner with warm-up, median/p95/MAD.

Usage:
    python3 run_baseline.py [--warmup 3] [--measured 15] [--only fib,arrsum]

Collects system provenance, runs benchmarks with warm-up separation,
and produces PERF_BASELINE.md with full statistics.
"""

import argparse
import hashlib
import json
import os
import subprocess
import sys
import tempfile
import time
from datetime import datetime, timezone
from pathlib import Path

# Add parent to path for benchmark_stats
sys.path.insert(0, str(Path(__file__).resolve().parent))

from benchmark_stats import (
    compute_stats, collect_system_info, split_warmup_measured,
    format_baseline_report, BENCHMARK_CATEGORIES, category_for,
)

# ── Faz D timing harness: monotonic + interleaved ─────────────
TIMER = time.perf_counter

def _interleave_runs(warmup: int, measured: int) -> list[str]:
    """Return a sequence of 'W' (warmup) and 'M' (measured) runs that
    spreads warm-ups evenly so the first few cold runs do not bias the
    measured distribution."""
    total = warmup + measured
    order = ["M"] * total
    # Place warm-up runs at the start, middle, and near-end of the stream.
    if warmup > 0:
        positions = {0}
    if warmup > 1:
        positions.add(total // 2)
    if warmup > 2:
        positions.add(total - 2)
    for i in range(3, warmup):
        positions.add(min(total - 1, (i * total) // warmup))
    # Ensure we have exactly `warmup` distinct positions.
    positions = sorted(positions)
    while len(positions) < warmup:
        for p in range(total):
            if p not in positions:
                positions.append(p)
                break
        positions = sorted(positions)
    positions = sorted(positions[:warmup])
    for p in positions:
        order[p] = "W"
    return order

SCRIPT_DIR = Path(__file__).resolve().parent
HHS_REPO = SCRIPT_DIR.parent / "hudhud-script"
BENCH_DIR = SCRIPT_DIR / "benchmark"
OUTPUT_FILE = HHS_REPO / "docs" / "PERFORMANCE_BASELINE_CURRENT.md"

RUNNERS = {
    "hudhud": {
        "suffix": ".hud",
        "timeout": 600,
    },
    "python": {
        "suffix": ".py",
        "timeout": 600,
    },
    "lua": {
        "suffix": ".lua",
        "timeout": 600,
    },
    "nodejs": {
        "suffix": ".js",
        "timeout": 600,
    },
}

MINIMUM_SET = [
    "arrsum", "matrix", "strcat", "k_nucleotide", "duffs_device",
    "binary_trees", "strrev", "spectral_norm", "fib_iterative",
    "fib_memo", "power", "polynomial_eval", "revcomp", "n_body",
]


def find_binary() -> Path:
    for profile in ("release", "release-prof"):
        path = HHS_REPO / "target" / profile / "hudhud"
        if path.exists() and os.access(path, os.X_OK):
            return path
    return HHS_REPO / "target" / "release" / "hudhud"


def run_one(bench_name: str, lang: str, binary: Path) -> tuple[float, str, str]:
    """Run a single benchmark iteration. Returns (ms, stdout, stderr)."""
    suffix = RUNNERS[lang]["suffix"]
    src_path = BENCH_DIR / lang / f"{bench_name}{suffix}"
    if not src_path.exists():
        return 0.0, "", f"source not found: {src_path}"

    code = src_path.read_text(encoding="utf-8")
    env = os.environ.copy()
    env["RUST_MIN_STACK"] = "8388608"

    with tempfile.NamedTemporaryFile(
        mode="w", suffix=suffix, delete=False, encoding="utf-8", dir="/tmp"
    ) as f:
        f.write(code)
        tmp_path = f.name

    try:
        start = TIMER()
        if lang == "hudhud":
            cmd = [str(binary), "run", tmp_path]
        elif lang == "python":
            cmd = [sys.executable, tmp_path]
        elif lang == "lua":
            cmd = ["lua", tmp_path]
        elif lang == "nodejs":
            cmd = ["node", tmp_path]
        else:
            return 0.0, "", f"unknown language: {lang}"

        proc = subprocess.run(
            cmd, capture_output=True, text=True,
            timeout=RUNNERS[lang]["timeout"],
            cwd=str(HHS_REPO) if lang == "hudhud" else None,
            env=env,
        )
        elapsed = round((TIMER() - start) * 1000, 1)
        ok = proc.returncode == 0
        if not ok:
            return elapsed, proc.stdout[:500], proc.stderr[:500]
        return elapsed, proc.stdout[:500], ""
    except subprocess.TimeoutExpired:
        return float(RUNNERS[lang]["timeout"] * 1000), "", "timeout"
    except Exception as e:
        return 0.0, "", str(e)
    finally:
        try:
            os.unlink(tmp_path)
        except OSError:
            pass


def _run_trial(bench_name: str, lang: str, binary: Path) -> tuple[float, str]:
    """Single timed trial; returns (ms, error-or-empty)."""
    ms, _, stderr = run_one(bench_name, lang, binary)
    return ms, stderr


def main():
    parser = argparse.ArgumentParser(description="GATE-1 Baseline Runner")
    parser.add_argument("--warmup", type=int, default=3)
    parser.add_argument("--measured", type=int, default=15)
    parser.add_argument("--only", type=str, default=None)
    parser.add_argument("--languages", type=str, default="hudhud")
    parser.add_argument("--output", type=str, default=str(OUTPUT_FILE))
    parser.add_argument("--min-measured", type=int, default=5)
    args = parser.parse_args()

    if args.measured < args.min_measured:
        print(f"WARNING: measured={args.measured} below minimum {args.min_measured}; using minimum")
        args.measured = args.min_measured

    binary = find_binary()
    if not binary.exists():
        print(f"ERROR: hudhud binary not found at {binary}")
        print("Build first: cd hudhud-script && cargo build --release -p hudhudscript-cli")
        sys.exit(1)

    bench_keys = args.only.split(",") if args.only else MINIMUM_SET
    langs = args.languages.split(",")
    total_runs = args.warmup + args.measured

    # System info
    sys_info = collect_system_info(binary)
    sys_info["date"] = datetime.now(timezone.utc).isoformat()
    sys_info["hudhud_version"] = "see binary --version"

    try:
        out = subprocess.run([str(binary), "--version"], capture_output=True, text=True, timeout=5)
        if out.returncode == 0:
            sys_info["hudhud_version"] = out.stdout.strip() or out.stderr.strip()
    except Exception:
        pass

    print(f"HudHud: {sys_info['hudhud_version']}")
    print(f"Binary: {binary}")
    print(f"Benchmarks: {bench_keys}")
    print(f"Languages: {langs}")
    print(f"Warm-up: {args.warmup}, Measured: {args.measured}")
    print()

    all_results = []

    for bench_name in bench_keys:
        print(f"══ {bench_name} ══")
        lang_results = []

        for lang in langs:
            print(f"  {lang}: ", end="", flush=True)
            runs: list[float] = []
            errors: list[str] = []
            order = _interleave_runs(args.warmup, args.measured)

            for kind in order:
                if kind == "W":
                    ms, err = _run_trial(bench_name, lang, binary)
                    errors.append(err)
                    print("W", end="", flush=True)
                else:
                    ms, err = _run_trial(bench_name, lang, binary)
                    runs.append(ms)
                    errors.append(err)
                    print("." if not err else "x", end="", flush=True)
            print()

            measured_runs = runs
            stats = compute_stats(measured_runs) if measured_runs else {}

            print(f"    measured (order {order}): {[round(m, 1) for m in measured_runs]}")
            if stats:
                print(f"    median={stats['median']:.1f}ms p95={stats['p95']:.1f}ms MAD={stats['mad']:.1f}ms")

            all_ok = all(not s for s in errors)
            lang_results.append({
                "language": lang,
                "ok": all_ok,
                "all_runs": measured_runs,
                "warmup_runs": [],
                "measured_runs": measured_runs,
                "stats": stats,
            })

        all_results.append({
            "benchmark": bench_name,
            "languages": lang_results,
        })
        print()

    # Generate report
    report = format_baseline_report(all_results, sys_info, langs, args.warmup, args.measured)

    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(report, encoding="utf-8")

    print(f"\nBaseline saved to: {output_path}")

    # Also save raw JSON
    json_path = output_path.with_suffix(".json")
    json_path.write_text(json.dumps({
        "system_info": sys_info,
        "methodology": {"warmup": args.warmup, "measured": args.measured},
        "results": all_results,
    }, indent=2, default=str), encoding="utf-8")
    print(f"Raw data saved to: {json_path}")


if __name__ == "__main__":
    main()
