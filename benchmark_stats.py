"""GATE-1: Reproducible benchmark statistics and system provenance.

Provides:
- median, p95, MAD (Median Absolute Deviation)
- geometric mean across benchmark categories
- cold (CLI startup) vs hot (VM-only) measurement methodology
- system provenance collection (OS, CPU, rustc, governor, etc.)
"""

import json
import os
import platform
import statistics
import subprocess
import sys
from pathlib import Path
from typing import Optional


# ── Statistics ──────────────────────────────────────────────────────

def median(values: list[float]) -> float:
    """Median of a list of values."""
    if not values:
        return 0.0
    return statistics.median(values)


def p95(values: list[float]) -> float:
    """95th percentile — linear interpolation between closest ranks."""
    if not values:
        return 0.0
    sorted_vals = sorted(values)
    n = len(sorted_vals)
    # p95 index (0-based): use linear interpolation
    k = 0.95 * (n - 1)
    lo = int(k)
    hi = min(lo + 1, n - 1)
    frac = k - lo
    return sorted_vals[lo] * (1 - frac) + sorted_vals[hi] * frac


def mad(values: list[float]) -> float:
    """Median Absolute Deviation — robust measure of dispersion."""
    if not values:
        return 0.0
    med = median(values)
    abs_devs = [abs(v - med) for v in values]
    return median(abs_devs)


def geometric_mean(values: list[float]) -> float:
    """Geometric mean — appropriate for ratio/benchmark aggregation."""
    if not values:
        return 0.0
    log_sum = sum(statistics.log(v) for v in values if v > 0)
    return statistics.exp(log_sum / len(values))


def compute_stats(runs_ms: list[float]) -> dict:
    """Compute full statistics from a list of measured run times (ms)."""
    if not runs_ms:
        return {"count": 0, "median": None, "p95": None, "mad": None, "mean": None}
    sorted_runs = sorted(runs_ms)
    return {
        "count": len(runs_ms),
        "min": sorted_runs[0],
        "max": sorted_runs[-1],
        "mean": sum(runs_ms) / len(runs_ms),
        "median": median(runs_ms),
        "p95": p95(runs_ms),
        "mad": mad(runs_ms),
        "values": [round(v, 1) for v in runs_ms],
    }


def split_warmup_measured(runs: list[float], warmup_count: int) -> tuple[list[float], list[float]]:
    """Split runs into warm-up and measured sets."""
    if len(runs) <= warmup_count:
        return runs, []
    return runs[:warmup_count], runs[warmup_count:]


# ── System provenance ───────────────────────────────────────────────

def collect_system_info(binary_path: Optional[Path] = None) -> dict:
    """Collect reproducible system provenance for benchmark runs."""
    info = {
        "os": platform.platform(),
        "os_release": _os_release(),
        "cpu": platform.processor() or _cpu_model(),
        "cpu_cores": os.cpu_count(),
        "python": sys.version.split()[0],
        "rustc": _rustc_version(),
    }

    # CPU governor (Linux only)
    gov = _cpu_governor()
    if gov:
        info["cpu_governor"] = gov

    # Binary info
    if binary_path and binary_path.exists():
        import hashlib
        info["binary_path"] = str(binary_path)
        info["binary_sha256"] = hashlib.sha256(binary_path.read_bytes()).hexdigest()[:16]
        info["binary_profile"] = binary_path.parent.name

    return info


def _os_release() -> str:
    """Read OS release info from /etc/os-release (Linux) or equivalent."""
    try:
        with open("/etc/os-release") as f:
            for line in f:
                if line.startswith("PRETTY_NAME="):
                    return line.split("=", 1)[1].strip().strip('"')
    except Exception:
        pass
    try:
        out = subprocess.run(["sw_vers", "-productVersion"], capture_output=True, text=True, timeout=3)
        if out.returncode == 0:
            return f"macOS {out.stdout.strip()}"
    except Exception:
        pass
    return platform.version()


def _cpu_model() -> str:
    """Read CPU model name."""
    try:
        with open("/proc/cpuinfo") as f:
            for line in f:
                if line.startswith("model name"):
                    return line.split(":", 1)[1].strip()
    except Exception:
        pass
    try:
        out = subprocess.run(["sysctl", "-n", "machdep.cpu.brand_string"], capture_output=True, text=True, timeout=3)
        if out.returncode == 0:
            return out.stdout.strip()
    except Exception:
        pass
    return platform.machine()


def _rustc_version() -> str:
    """Get rustc version string."""
    try:
        out = subprocess.run(["rustc", "--version"], capture_output=True, text=True, timeout=5)
        if out.returncode == 0:
            return out.stdout.strip()
    except Exception:
        pass
    return "unknown"


def _cpu_governor() -> Optional[str]:
    """Read current CPU scaling governor (Linux)."""
    try:
        path = "/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
        with open(path) as f:
            return f.read().strip()
    except Exception:
        pass
    return None


# ── Category grouping ────────────────────────────────────────────────

BENCHMARK_CATEGORIES = {
    "arithmetic": ["arrsum", "cumulative_sum", "sum_of_squares", "geometric_series",
                   "vector_dot", "monte_carlo_pi"],
    "bigint": ["fib_iterative", "fib_memo", "power", "fact", "modular_exp"],
    "string": ["strcat", "strrev", "k_nucleotide", "revcomp", "palindrome",
               "substring_search"],
    "allocation": ["binary_trees", "duffs_device"],
    "call_heavy": ["fib", "factorial_recursive", "ack", "hanoi", "tak", "spectral_norm"],
    "numeric": ["n_body", "polynomial_eval", "matrix", "newton_sqrt",
                "mean_variance", "mandelbrot"],
    "sort_search": ["bubble", "quick", "merge", "heap_sort", "insertion_sort",
                    "bsearch", "sieve", "prime_count", "collatz"],
    "graph_dp": ["bfs", "dfs", "knapsack", "lcs", "n_queens", "fannkuch_redux"],
}

CATEGORY_TR = {
    "arithmetic": "Aritmetik",
    "bigint": "BigInt",
    "string": "String İşlemleri",
    "allocation": "Allocation/GC",
    "call_heavy": "Fonksiyon Çağrısı",
    "numeric": "Sayısal Hesaplama",
    "sort_search": "Sıralama/Arama",
    "graph_dp": "Graf/DP",
}


def category_for(bench_name: str) -> str:
    for cat, names in BENCHMARK_CATEGORIES.items():
        if bench_name in names:
            return cat
    return "other"


# ── Result aggregation ──────────────────────────────────────────────

def aggregate_by_category(results: list[dict], lang: str) -> dict:
    """Compute per-category geometric mean for a language."""
    cat_values: dict[str, list[float]] = {}
    for entry in results:
        bench = entry["benchmark"]
        cat = category_for(bench)
        for lr in entry.get("languages", []):
            if lr["language"] == lang and lr.get("avg_ms"):
                cat_values.setdefault(cat, []).append(lr["avg_ms"])
    return {cat: geometric_mean(vals) for cat, vals in cat_values.items()}


def format_baseline_report(
    results: list[dict],
    system_info: dict,
    langs: list[str],
    warmup: int,
    measured: int,
) -> str:
    """Generate a markdown baseline report."""
    lines = []
    lines.append("# HudHudScript Performance Baseline")
    lines.append("")
    lines.append(f"**Date**: {system_info.get('date', 'N/A')}")
    lines.append(f"**HudHud version**: {system_info.get('hudhud_version', 'N/A')}")
    lines.append(f"**Binary profile**: {system_info.get('binary_profile', 'N/A')}")
    lines.append(f"**Rustc**: {system_info.get('rustc', 'N/A')}")
    lines.append(f"**OS**: {system_info.get('os', 'N/A')} ({system_info.get('os_release', 'N/A')})")
    lines.append(f"**CPU**: {system_info.get('cpu', 'N/A')} ({system_info.get('cpu_cores', 'N/A')} cores)")
    if system_info.get("cpu_governor"):
        lines.append(f"**CPU Governor**: {system_info['cpu_governor']}")
    lines.append(f"**Python**: {system_info.get('python', 'N/A')}")
    lines.append(f"**Methodology**: {warmup} warm-up + {measured} measured runs per benchmark")
    lines.append("")
    lines.append("## Per-Benchmark Results")
    lines.append("")

    for entry in results:
        bench = entry["benchmark"]
        lines.append(f"### {bench}")
        lines.append("")
        lines.append("| Language | Mean (ms) | Median (ms) | p95 (ms) | MAD (ms) |")
        lines.append("|----------|-----------|-------------|----------|----------|")
        for lr in entry.get("languages", []):
            if lr.get("stats"):
                s = lr["stats"]
                lines.append(f"| {lr['language']} | {s['mean']:.0f} | {s['median']:.0f} | {s['p95']:.0f} | {s['mad']:.0f} |")
        lines.append("")

    lines.append("## Category Geometric Means")
    lines.append("")
    for lang in langs:
        lines.append(f"### {lang}")
        cats = aggregate_by_category(results, lang)
        lines.append("")
        lines.append("| Category | GeoMean (ms) |")
        lines.append("|----------|-------------|")
        for cat in sorted(cats.keys()):
            cat_name = CATEGORY_TR.get(cat, cat)
            lines.append(f"| {cat_name} | {cats[cat]:.0f} |")
        lines.append("")

    return "\n".join(lines)
