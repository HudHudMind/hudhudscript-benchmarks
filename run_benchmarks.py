#!/usr/bin/env python3
"""
HudHudScript Cross-Language Benchmark Runner
============================================

Tüm benchmark'ları sırayla tüm diller için çalıştırır ve sonuçları
data/benchmark_results.json dosyasına kaydeder.

Kullanım:
    python3 run_benchmarks.py                 # Tüm benchmark'ları çalıştır
    python3 run_benchmarks.py --runs 5        # 5'er kez çalıştır
    python3 run_benchmarks.py --only fib,fact # Sadece belirtilenleri çalıştır
    python3 run_benchmarks.py --languages python,lua  # Sadece belirtilen diller

Benchmark kategorileri:
    fib     - Fibonacci Recursive fib(30)
    fact    - Factorial Iterative 10_000
    sieve   - Sieve of Eratosthenes (primes up to 10_000)
    strcat  - String Concatenation (50_000 char)
    arrsum  - Array Summation (10_000 integers)
    collatz - Collatz Conjecture (1..10_000)
    bubble  - Bubble Sort (500 integers)
    strrev  - String Reverse (50_000 chars)
    gcd     - Euclidean GCD (10_000 iterations)
    hanoi   - Tower of Hanoi (n=20)
    ack     - Ackermann Function (m=3, n=6)
    quick   - Quick Sort (2000 integers)
    merge   - Merge Sort (2000 integers)
    bsearch - Binary Search (10_000 searches in 100_000)
    matrix  - Matrix Multiply (150×150)
"""

import argparse
import json
import os
import subprocess
import sys
import tempfile
import time
import hashlib
from datetime import datetime, timezone
from pathlib import Path

import benchmark_storage as bstorage

# Ensure ~/.cargo/bin is in PATH for cargo, flamegraph, etc.
_cargo_bin = Path.home() / ".cargo" / "bin"
if _cargo_bin.exists() and str(_cargo_bin) not in os.environ.get("PATH", ""):
    os.environ["PATH"] = str(_cargo_bin) + os.pathsep + os.environ.get("PATH", "")

# ── Paths ─────────────────────────────────────────────────────────

SCRIPT_DIR = Path(__file__).resolve().parent
HHS_REPO = SCRIPT_DIR.parent / "hudhud-script"
DATA_DIR = SCRIPT_DIR / "data"


def find_binary() -> Path:
    """Find the hudhud binary: release only (no silent fallback)."""
    path = HHS_REPO / "target" / "release" / "hudhud"
    if path.exists() and os.access(path, os.X_OK):
        return path
    # No fallback — if release is missing/broken, caller handles the error
    return path


def get_binary_profile(binary_path: Path) -> str:
    """Extract cargo profile name from binary path."""
    profile = binary_path.parent.name
    return profile if profile in ("release", "release-prof") else "release"


BINARY = find_binary()
RESULTS_FILE = DATA_DIR / "benchmark_results.json"

# ── ANSI colors ───────────────────────────────────────────────────

BOLD = "\033[1m"
CYAN = "\033[0;36m"
GREEN = "\033[0;32m"
YELLOW = "\033[1;33m"
RED = "\033[0;31m"
GRAY = "\033[0;90m"
MAGENTA = "\033[0;35m"
NC = "\033[0m"

# ── All benchmarks (sources loaded from files) ─────────────────

BENCHMARKS = {
    "ack": {
        "title": "Ackermann Function",
        "desc": "m=3, n=6",
    },
    "avl_insert": {"title":"AVL Insert","slug":"avl_insert","desc":"Arena-based AVL insert 100k keys + inorder checksum","file":"avl_insert","timeout":30},
    "arrsum": {
        "title": "Array Summation",
        "desc": "Sum 10_000 integers",
    },
    "bfs": {
        "title": "BFS Graph",
        "desc": "Breadth-first search on 100 nodes",
    },
    "bsearch": {
        "title": "Binary Search",
        "desc": "10_000 searches in 100_000 sorted array",
    },
    "bubble": {
        "title": "Bubble Sort",
        "desc": "500 integers",
    },
    "collatz": {
        "title": "Collatz Conjecture",
        "desc": "1..10_000",
    },
    "count_set_bits": {
        "title": "Count Set Bits",
        "desc": "Count bits in numbers 1 to 100_000",
    },
    "cumulative_sum": {
        "title": "Cumulative Sum",
        "desc": "Prefix sum of 100_000 integers",
    },
    "dfs": {
        "title": "DFS Graph",
        "desc": "Depth-first search on 100 nodes",
    },
    "fact": {
        "title": "Factorial Iterative",
        "desc": "factorial(10000)",
    },
    "factorial_recursive": {
        "title": "Factorial Recursive",
        "desc": "fact(150) -- Stack recursion test",
    },
    "fib": {
        "title": "Fibonacci Recursive",
        "desc": "fib(30)",
    },
    "fib_iterative": {
        "title": "Fibonacci Iterative",
        "desc": "fib(1000), 10_000 iterations",
        "note": "HudHud is expected to preserve exact BigInt semantics here; VM overflow is tracked separately.",
    },
    "fib_memo": {
        "title": "Fibonacci Memoization",
        "desc": "fib(500), 10_000 iterations",
        "note": "HudHud is expected to preserve exact BigInt semantics here; VM overflow is tracked separately.",
    },
    "gcd": {
        "title": "Euclidean GCD",
        "desc": "10_000 iterations",
    },
    "geometric_series": {
        "title": "Geometric Series",
        "desc": "Sum of r^i for i=0..999_999 (r=0.999)",
    },
    "hanoi": {
        "title": "Tower of Hanoi",
        "desc": "n=20",
    },
    "heap_sort": {
        "title": "Heap Sort",
        "desc": "1000 integers",
    },
    "insertion_sort": {
        "title": "Insertion Sort",
        "desc": "1000 integers",
    },
    "kmp_search": {"title":"KMP Search","slug":"kmp_search","desc":"KMP failure table + search, 20 patterns over 500k text","file":"kmp_search","timeout":30},
    "knapsack": {
        "title": "0/1 Knapsack",
        "desc": "50 items, capacity 100",
    },
    "lcs": {
        "title": "LCS",
        "desc": "Longest common subsequence, length 100 strings",
    },
    "matrix": {
        "title": "Matrix Multiply",
        "desc": "150×150 matrices",
    },
    "matrix_transpose": {
        "title": "Matrix Transpose",
        "desc": "Transpose a 300×300 matrix",
    },
    "mean_variance": {
        "title": "Mean and Variance",
        "desc": "Compute mean and variance of 1_000_000 numbers",
    },
    "merge": {
        "title": "Merge Sort",
        "desc": "1000 integers",
    },
    "modular_exp": {
        "title": "Modular Exponentiation",
        "desc": "(base^exp) mod m, 10_000 iterations",
    },
    "monte_carlo_pi": {
        "title": "Monte Carlo Pi",
        "desc": "Estimate Pi with 500_000 random points",
    },
    "number_parse": {"title":"Number Parse","slug":"number_parse","desc":"Hand-rolled integer parser over 200k numeric strings","file":"number_parse","timeout":30},
    "n_queens": {
        "title": "N-Queens",
        "desc": "n=8, count all solutions",
    },
    "newton_sqrt": {
        "title": "Newton-Raphson Sqrt",
        "desc": "Square root for 1..10_000 (20 iterations each)",
    },
    "palindrome": {
        "title": "Palindrome Check",
        "desc": "Check palindrome on 50_000 char string, 1000 times",
        "note": "String-based palindrome avoids HudHud array string-comparison VM bug.",
    },
    "polynomial_eval": {
        "title": "Polynomial Evaluation",
        "desc": "Horner's method, degree 1000, 100_000 times",
    },
    "power": {
        "title": "Power Operation",
        "desc": "Compute 2^1000, 10_000 iterations",
    },
    "prime_count": {
        "title": "Prime Count",
        "desc": "Count primes up to 100_000 (trial division)",
    },
    "quick": {
        "title": "Quick Sort",
        "desc": "1000 integers",
    },
    "sieve": {
        "title": "Sieve of Eratosthenes",
        "desc": "Primes up to 10_000",
    },
    "strcat": {
        "title": "String Concatenation",
        "desc": "50_000 char concat",
    },
    "strrev": {
        "title": "String Reverse",
        "desc": "50_000 chars",
    },
    "substring_search": {
        "title": "Substring Search",
        "desc": "Naive search in 10_000 char string",
    },
    "sum_of_squares": {
        "title": "Sum of Squares",
        "desc": "Sum i² for i=1..1_000_000",
    },
    "vector_dot": {
        "title": "Vector Dot Product",
        "desc": "Dot product of two 500_000 element vectors",
    },
    "binary_trees": {
        "title": "Binary Trees",
        "desc": "GC performance with 12 max depth",
    },
    "tak": {
        "title": "Tak Function",
        "desc": "tak(18, 12, 6) 10 times",
    },
    "mandelbrot": {
        "title": "Mandelbrot Set",
        "desc": "500x500 complex plane",
    },
    "json_serialize": {"title":"JSON Serialize","slug":"json_serialize","desc":"Hand-rolled JSON serializer over deterministic nested dict tree, 50 rounds","file":"json_serialize","timeout":30},
    "k_nucleotide": {
        "title": "K-Nucleotide",
        "desc": "100k string 1,2,3-mer freq",
    },
    "duffs_device": {
        "title": "Duff's Device",
        "desc": "Loop unrolling 100k 100 times",
    },
    "n_body": {
        "title": "N-Body",
        "desc": "N-Body simulation 10k steps",
    },
    "fannkuch_redux": {
        "title": "Fannkuch-Redux",
        "desc": "Fannkuch-redux (n=9)",
    },
    "spectral_norm": {
        "title": "Spectral Norm",
        "desc": "Spectral norm (n=150)",
    },
    "fasta": {
        "title": "Fasta",
        "desc": "Fasta sequence generation (n=50k)",
    },
    "radix_sort": {
        "title": "Radix Sort",
        "slug": "radix_sort",
        "desc": "LSD radix sort base-10, 200k integers (non-comparison class)",
        "file": "radix_sort",
        "timeout": 30,
    },
    "rk4_pendulum": {"title":"RK4 Pendulum","slug":"rk4_pendulum","desc":"RK4 pendulum integration, 1M steps (sin only)","file":"rk4_pendulum","timeout":60},
    "revcomp": {
        "title": "Reverse-Complement",
        "desc": "Reverse complement 500k DNA string",
    },
    "object_churn": {
        "title": "Object Churn",
        "desc": "500k object allocations with property access",
    },
    "method_dispatch": {
        "title": "Method Dispatch",
        "desc": "Polymorphic virtual dispatch, ~900k calls",
    },
    "closure_chain": {
        "title": "Closure Chain",
        "desc": "150k closures with upvalue mutation",
    },
    "higher_order": {
        "title": "Higher-Order Pipeline",
        "desc": "map/filter/reduce pipeline, 2000 rounds",
    },
    "sort_by_comparator": {
        "title": "Sort by Comparator",
        "desc": "Quicksort with comparator function, 20000 items",
    },
    "string_pipeline": {
        "title": "String Pipeline",
        "desc": "Split/substring/indexOf chain, 10k rounds",
    },
    "linked_list": {
        "title": "Linked List",
        "desc": "100k node list reverse + traverse",
    },
    "union_find": {
        "title": "Union-Find",
        "desc": "Disjoint set with union by size, 200k/400k ops",
    },
    "hash_probe": {
        "title": "Hash Probe",
        "desc": "Open-addressing hash table, 40k/80k/20k ops",
    },
    "exception_ladder": {
        "title": "Exception Ladder",
        "desc": "3-frame throw/catch unwind, 200k iterations",
    },
    "floyd_warshall": {
        "title": "Floyd-Warshall",
        "desc": "All-pairs shortest path, n=150",
    },
    "game_of_life": {
        "title": "Game of Life",
        "desc": "Conway's Game of Life, 96x96 torus, 100 gens",
    },
    "string_sort": {
        "title": "String Sort",
        "desc": "Merge sort on 20000 strings",
    },
    "simpson_integration": {
        "title": "Simpson Integration",
        "desc": "Numerical integration, N=2M slices",
    },
    "word_count": {
        "title": "Word Count",
        "desc": "Native dict frequency counting, 500k words",
    },
    "trie_dict": {
        "title": "Trie Dictionary",
        "desc": "Arena-based trie, 20k words insert+lookup",
    },
    "miller_rabin": {
        "title": "Miller-Rabin",
        "desc": "Deterministic primality test, 2000 numbers",
    },
    "task_scheduler": {
        "title": "Task Scheduler",
        "desc": "Richards-inspired round-robin scheduler, 300k ticks",
    },
    "mini_vm": {
        "title": "Mini VM",
        "desc": "If-else dispatch chain, 300k iterations",
    },
    "dijkstra": {
        "title": "Dijkstra",
        "desc": "Binary heap shortest path, n=20000·6 edges",
    },
    "lzw_compress": {
        "title": "LZW Compress",
        "desc": "LZW dictionary compression, 400k symbols",
    },
    "pidigits": {
        "title": "Pi Digits",
        "desc": "Machin formula (K10), 600 digits",
    },
    "fft": {
        "title": "FFT",
        "desc": "Cooley-Tukey FFT, N=4096 × 50 iterations",
    },
    "lu_decomposition": {
        "title": "LU Decomposition",
        "desc": "Doolittle LU, n=200",
    },
}

# ── Source loader ───────────────────────────────────────────────

SOURCE_DIR = SCRIPT_DIR / "benchmarks" / "src"
LANG_SUFFIXES = {
    "hudhud": ".hud",
    "python": ".py",
    "lua": ".lua",
    "ruby": ".rb",
    "nodejs": ".js",
    "php": ".php",
    "perl": ".pl",
    "raku": ".raku",
    "tcl": ".tcl",
}


def benchmark_source(bench_name: str, lang: str) -> str:
    """Load benchmark source code from file."""
    suffix = LANG_SUFFIXES.get(lang)
    if suffix is None:
        raise KeyError(f"Unknown language: {lang}")
    path = SOURCE_DIR / lang / f"{bench_name}{suffix}"
    if not path.exists():
        raise FileNotFoundError(
            f"Source not found: {path} (benchmark={bench_name}, lang={lang})"
        )
    return path.read_text(encoding="utf-8")


# ── Language metadata ─────────────────────────────────────────────

LANGUAGES = ["hudhud", "python", "lua", "ruby", "nodejs", "php", "perl", "raku", "tcl"]

RUNNERS = {
    "hudhud": {
        "cmd": lambda path: [str(BINARY), "run", path],
        "suffix": ".hud",
        "timeout": 600,
    },
    "python": {
        "cmd": lambda path: ["python3", path],
        "suffix": ".py",
        "timeout": 600,
    },
    "lua": {
        "cmd": lambda path: ["lua", path],
        "suffix": ".lua",
        "timeout": 600,
    },
    "ruby": {
        "cmd": lambda path: ["ruby", path],
        "suffix": ".rb",
        "timeout": 600,
    },
    "nodejs": {
        "cmd": lambda path: ["node", path],
        "suffix": ".js",
        "timeout": 600,
    },
    "php": {
        "cmd": lambda path: ["php", path],
        "suffix": ".php",
        "timeout": 600,
    },
    "perl": {
        "cmd": lambda path: ["perl", path],
        "suffix": ".pl",
        "timeout": 600,
    },
    "raku": {
        "cmd": lambda path: ["raku", path],
        "suffix": ".raku",
        "timeout": 600,
    },
    "tcl": {
        "cmd": lambda path: ["tclsh", path],
        "suffix": ".tcl",
        "timeout": 600,
    },
}

# ── Utility functions ─────────────────────────────────────────────


def detect_versions() -> dict:
    """Detect installed language versions."""
    versions = {}
    cmds = {
        "hudhud": [str(BINARY), "--version"],
        "python": ["python3", "--version"],
        "lua": ["lua", "-v"],
        "ruby": ["ruby", "--version"],
        "nodejs": ["node", "--version"],
        "php": ["php", "--version"],
        "perl": ["perl", "--version"],
        "raku": ["raku", "--version"],
        "tcl": ["tclsh", "<<<", "puts $tcl_version"],
    }
    for lang, cmd in cmds.items():
        try:
            out = subprocess.run(cmd, capture_output=True, text=True, timeout=5)
            versions[lang] = (
                (out.stdout + out.stderr).strip().split("\n")[0]
            )
        except Exception:
            versions[lang] = "not found"
    return versions


def get_cargo_version() -> str:
    """Read the workspace version from Cargo.toml."""
    import re
    cargo_toml = HHS_REPO / "Cargo.toml"
    try:
        text = cargo_toml.read_text()
        m = re.search(r'^version\s*=\s*"([^"]+)"', text, re.MULTILINE)
        return m.group(1) if m else "unknown"
    except Exception:
        return "unknown"


def get_binary_version(binary: Path) -> str:
    """Get version string from binary --version output."""
    import re
    try:
        out = subprocess.run(
            [str(binary), "--version"], capture_output=True, text=True, timeout=5
        )
        m = re.search(r'(\d+\.\d+\.\d+)', (out.stdout + out.stderr))
        return m.group(1) if m else "unknown"
    except Exception:
        return "unknown"


def ensure_binary() -> bool:
    """Build hudhud binary if missing or version-mismatched."""
    expected = get_cargo_version()

    if BINARY.exists() and os.access(BINARY, os.X_OK):
        actual = get_binary_version(BINARY)
        if actual == expected:
            return True
        print(f"{YELLOW}⚠  Binary versiyon uyuşmazlığı: binary={actual}, Cargo.toml={expected}{NC}")
        print(f"   Yeniden derleniyor...")
    else:
        print(f"{YELLOW}⚠  hudhud binary bulunamadı, derleniyor...{NC}")

    profile = get_binary_profile(BINARY)
    if profile == "release":
        cargo_args = ["cargo", "build", "--release", "-p", "hudhudscript-cli", "--bin", "hudhud"]
    else:
        cargo_args = ["cargo", "build", "--profile", profile, "-p", "hudhudscript-cli", "--bin", "hudhud"]

    print(f"   {' '.join(cargo_args)}")
    try:
        subprocess.run(
            cargo_args,
            cwd=str(HHS_REPO),
            check=True,
            timeout=600,
        )
        if BINARY.exists():
            actual = get_binary_version(BINARY)
            if actual != expected:
                print(f"{RED}✗  Build sonrası versiyon hâlâ yanlış: {actual} != {expected}{NC}")
                return False
            print(f"{GREEN}✓  Build başarılı — v{actual}{NC}")
            return True
    except subprocess.CalledProcessError:
        print(f"{RED}✗  Build başarısız{NC}")
    except subprocess.TimeoutExpired:
        print(f"{RED}✗  Build timeout (10dk){NC}")
    except FileNotFoundError:
        print(f"{RED}✗  cargo bulunamadı — Rust kurulu mu?{NC}")
    return False


# ── G0: Pure statistics helpers (testable without process runner) ──

def compute_median(values: list) -> float | None:
    """Compute median preserving .5 for even-length lists."""
    if not values:
        return None
    sv = sorted(values)
    n = len(sv)
    if n % 2 == 1:
        return float(sv[n // 2])
    return (sv[n // 2 - 1] + sv[n // 2]) / 2.0


def compute_mad(values: list, median_val: float) -> float | None:
    """Compute median absolute deviation from the given median."""
    if not values:
        return None
    devs = sorted(abs(v - median_val) for v in values)
    n = len(devs)
    if n % 2 == 1:
        return float(devs[n // 2])
    return (devs[n // 2 - 1] + devs[n // 2]) / 2.0


def compute_p95_nearest_rank(values: list) -> float | None:
    """p95 via nearest-rank method: ceil(0.95 * n) - 1."""
    import math
    if not values:
        return None
    sv = sorted(values)
    n = len(sv)
    idx = max(0, min(math.ceil(0.95 * n) - 1, n - 1))
    return float(sv[idx])


def _make_default_runner(code: str, runner: dict, env: dict, golden, bench_name: str, lang: str):
    """G0: default process runner factory — returns _run_once callable."""
    from check_correctness import SKIPPED_RESULTS, _extract_result, _values_match
    def _run_once() -> dict:
        """Execute the benchmark once, return run dict."""
        with tempfile.NamedTemporaryFile(
            mode="w", suffix=runner["suffix"], delete=False, encoding="utf-8", dir="/tmp"
        ) as f:
            f.write(code)
            tmp_path = f.name
        try:
            start = time.time()
            try:
                proc = subprocess.run(
                    runner["cmd"](tmp_path),
                    capture_output=True,
                    text=True,
                    timeout=runner["timeout"],
                    cwd=str(HHS_REPO) if lang == "hudhud" else None,
                    env=env,
                )
                elapsed = round((time.time() - start) * 1000)
                ok = proc.returncode == 0
                # G0: non-empty stderr → FAIL
                if ok and proc.stderr and proc.stderr.strip():
                    ok = False
                # Empty stdout → FAIL
                if ok and not (proc.stdout and proc.stdout.strip()):
                    ok = False
                    proc.stderr = (proc.stderr or "") + "[FAIL: empty stdout]"
                is_skipped = False
                if ok and (bench_name, lang) in SKIPPED_RESULTS:
                    ok = False
                    is_skipped = True
                if ok and proc.stdout:
                    if golden is not None:
                        result_lines = [l for l in proc.stdout.splitlines() if l.strip().startswith("Result:")]
                        if len(result_lines) > 1:
                            ok = False
                            proc.stderr = (proc.stderr or "") + f"[FAIL: {len(result_lines)} Result: lines (expected 1)]"
                        else:
                            val = _extract_result(proc.stdout, bench_name)
                            if val is None:
                                ok = False
                                proc.stderr = (proc.stderr or "") + "[FAIL: could not extract result from stdout]"
                            elif not _values_match(val, golden, bench_name, lang):
                                ok = False
                                proc.stderr = (proc.stderr or "") + f"[GOLDEN mismatch: expected={golden} got={val}]"
                return {
                    "ms": elapsed,
                    "ok": ok,
                    "skipped": is_skipped,
                    "stdout": proc.stdout[:100000],
                    "stderr": proc.stderr[:1000] if ok else (proc.stderr or "")[:1000],
                }
            except subprocess.TimeoutExpired:
                return {"ms": runner["timeout"] * 1000, "ok": False, "error": "timeout"}
            except Exception as e:
                return {"ms": 0, "ok": False, "error": str(e)}
        finally:
            try:
                os.unlink(tmp_path)
            except OSError:
                pass
    return _run_once


def _canonical_result(lang: str, source_hash: str, ok: bool, ranked: bool,
                     results: list, warmup_results: list,
                     warmup_count: int, completed_warmup_count: int,
                     measured_run_count: int, completed_measured_run_count: int,
                     selected_statistic: str, selected_ms, median_ms, p95_ms,
                     mad_ms, min_ms, max_ms, **extra) -> dict:
    """G0: single canonical result schema for ALL exit paths."""
    r = {
        "language": lang,
        "source_hash": source_hash,
        "ok": ok,
        "ranked": ranked,
        "results": results,
        "warmup_results": warmup_results,
        "warmup_count": warmup_count,
        "completed_warmup_count": completed_warmup_count,
        "measured_run_count": measured_run_count,
        "completed_measured_run_count": completed_measured_run_count,
        "selected_statistic": selected_statistic,
        "selected_ms": selected_ms,
        "median_ms": median_ms,
        "p95_ms": p95_ms,
        "p95_method": "nearest-rank",
        "mad_ms": mad_ms,
        "min_ms": min_ms,
        "max_ms": max_ms,
    }
    r.update(extra)
    return r


def run_language(bench_name: str, lang: str, runs: int, warmups: int = 0, *, preflight: bool = True, statistic: str = "median", _runner_factory=None) -> dict:
    """Run a single benchmark for a single language, N times.

    Preflight (if enabled): one correctness-only run before timing.
    statistic: "median" | "average" | "min" | "max" — determines selected_ms.
    _runner_factory: injectable factory for testing; returns callable for _run_once.
    Returns dict with 'ranked' field.
    """
    runner = RUNNERS.get(lang)
    if not runner:
        return _canonical_result(lang, "", False, False, [], [], 0, 0, 0, 0,
                                 statistic, None, None, None, None, None, None,
                                 status="unknown", error=f"Unknown language: {lang}")

    try:
        code = benchmark_source(bench_name, lang)
        source_hash = hashlib.sha256(code.encode()).hexdigest()[:12]
    except (KeyError, FileNotFoundError) as e:
        return _canonical_result(lang, "", False, False, [], [], 0, 0, 0, 0,
                                 statistic, None, None, None, None, None, None,
                                 status="missing", error=str(e))

    env = os.environ.copy()
    env["RUST_MIN_STACK"] = "8388608"
    env["PATH"] = str(BINARY.parent) + ":" + env.get("PATH", "")

    from check_correctness import GOLDEN, SKIPPED_RESULTS, _extract_result, _values_match
    golden = GOLDEN.get(bench_name)

    if _runner_factory is not None:
        _run_once = _runner_factory()
    else:
        _run_once = _make_default_runner(code, runner, env, golden, bench_name, lang)

    # ── Preflight: one correctness run before timing ──
    if preflight:
        pf = _run_once()
        if not pf["ok"]:
            # Preflight failed — no timing runs, ranked=false
            return _canonical_result(
                lang, source_hash, False, False,
                [pf], [], 0, 0, 0, 0,
                statistic, None, None, None, None, None, None,
                preflight_failed=True, skipped=pf.get("skipped", False))

    # ── Warmup runs (not measured) ──
    warmup_results = []
    for w in range(warmups):
        wr = _run_once()
        wr["warmup"] = w + 1
        warmup_results.append(wr)
        if not wr["ok"]:
            # G0: warmup failure invalidates the batch — preserve warmup_results
            return _canonical_result(
                lang, source_hash, False, False,
                [wr], warmup_results, warmups, len(warmup_results),
                0, 0,
                statistic, None, None, None, None, None, None,
                warmup_failed=True)

    # ── Timing runs ──
    results = []
    for run_num in range(1, runs + 1):
        r = _run_once()
        r["run"] = run_num
        results.append(r)

    ok_runs = [r["ms"] for r in results if r.get("ok")]
    skipped_runs = [r for r in results if r.get("skipped")]
    is_skipped = len(skipped_runs) > 0
    all_ok = len(ok_runs) == runs and not is_skipped

    # ── Statistics (use pure helpers for testability) ──
    avg = round(sum(ok_runs) / len(ok_runs)) if all_ok else None
    median_ms = None
    p95_ms = None
    mad_ms = None
    min_ms = None
    max_ms = None
    if all_ok and ok_runs:
        median_ms = compute_median(ok_runs)
        p95_ms = compute_p95_nearest_rank(ok_runs)
        mad_ms = compute_mad(ok_runs, median_ms)
        min_ms = min(ok_runs)
        max_ms = max(ok_runs)

    # ── Selected statistic ──
    if all_ok and ok_runs:
        stat_map = {"median": median_ms, "average": avg, "min": min_ms, "max": max_ms}
        selected_ms = stat_map.get(statistic, median_ms)
    else:
        selected_ms = None

    return _canonical_result(
        lang, source_hash, all_ok, all_ok,
        results, warmup_results, warmups, len(warmup_results),
        runs, len(results),
        statistic, selected_ms, median_ms, p95_ms, mad_ms, min_ms, max_ms,
        avg_ms=avg, skipped=is_skipped)


def load_existing_results() -> list:
    """Load existing benchmark results from JSON file."""
    if RESULTS_FILE.exists():
        try:
            with open(RESULTS_FILE, encoding="utf-8") as f:
                return json.load(f)
        except Exception:
            pass
    return []


def save_benchmark_result(execution_id: int, entry: dict):
    """Persist a single benchmark result linked to an execution.

    Uses the shared storage layer: SQLite first, then JSON (best-effort).
    """
    bstorage.record_benchmark_result(execution_id, entry)


def classify_unranked_cells(
    all_results: list[dict],
    skipped_results: dict[tuple[str, str], str],
) -> tuple[list[str], list[str]]:
    """Split unranked cells into explicitly accepted skips and real failures."""
    accepted_skips = []
    unexpected_fails = []
    for entry in all_results:
        benchmark = entry["benchmark"]
        for language_result in entry.get("languages", []):
            if language_result.get("ranked", False):
                continue
            language = language_result["language"]
            cell_key = (benchmark, language)
            cell_name = f"{benchmark}/{language}"
            if language_result.get("skipped") and cell_key in skipped_results:
                accepted_skips.append(cell_name)
            else:
                unexpected_fails.append(cell_name)
    return accepted_skips, unexpected_fails


# ── Display helpers ───────────────────────────────────────────────


def status_icon(ok: bool, avg_ms: float | None) -> str:
    """Return colored status indicator."""
    if not ok:
        return f"{RED}✗ FAIL{NC}"
    if avg_ms is None:
        return f"{YELLOW}? N/A{NC}"
    return f"{GREEN}✓{NC}"


def fmt_ms(ms: float | None) -> str:
    """Format milliseconds."""
    if ms is None:
        return f"{GRAY}  N/A{NC}"
    return f"{ms:5.0f}ms"


def build_profile_command(
    python_executable: str,
    profile_script: Path,
    targets: list[str],
    *,
    telemetry: bool = False,
    deep_profile: bool = False,
    profile_arch: str = "auto",
    no_build: bool = False,
) -> list[str]:
    """Import shared implementation from profiling_tools."""
    from profiling_tools import build_profile_command as _bpc
    return _bpc(
        python_executable=python_executable,
        profile_script=profile_script,
        targets=targets,
        telemetry=telemetry,
        deep_profile=deep_profile,
        profile_arch=profile_arch,
        no_build=no_build,
    )


# ── Main ──────────────────────────────────────────────────────────


def main():
    parser = argparse.ArgumentParser(
        description="HudHudScript Cross-Language Benchmark Runner",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Örnekler:
  python3 run_benchmarks.py                    # Tüm benchmark'lar, tüm diller
  python3 run_benchmarks.py --runs 5           # 5'er çalıştırma
  python3 run_benchmarks.py --only fib         # Sadece fibonacci
  python3 run_benchmarks.py --only fib,fact    # Sadece fibonacci + factorial
  python3 run_benchmarks.py --languages python,lua  # Sadece Python ve Lua
  python3 run_benchmarks.py --no-build         # Build etmeden çalıştır
        """,
    )
    parser.add_argument(
        "--runs", type=int, default=7,
        help="Her benchmark için measured çalıştırma sayısı (varsayılan: 7)",
    )
    parser.add_argument(
        "--warmups", type=int, default=2,
        help="Her benchmark için ısınma çalıştırması (measured'a girmez, varsayılan: 2)",
    )
    parser.add_argument(
        "--statistic", type=str, default="median",
        choices=["median", "average", "min", "max"],
        help="Özet istatistik (varsayılan: median)",
    )
    parser.add_argument(
        "--only", type=str, default=None,
        help="Sadece belirtilen benchmark(lar) (virgülle ayrılmış: fib,fact,sieve)",
    )
    parser.add_argument(
        "--languages", type=str, default=None,
        help="Sadece belirtilen dil(ler) (virgülle ayrılmış: python,lua,hudhud)",
    )
    parser.add_argument(
        "--no-build", action="store_true",
        help="HudHud binary'sini derleme (zaten varsa)",
    )
    parser.add_argument(
        "--skip-hudhud", action="store_true",
        help="HudHudScript'i atla (diğer dilleri çalıştır)",
    )
    parser.add_argument(
        "--dry-run", action="store_true",
        help="Çalıştırmadan sadece ne yapılacağını göster",
    )
    parser.add_argument(
        "--profile", action="store_true",
        help="Benchmark bittikten sonra otomatik callgrind + flamegraph üret",
    )
    parser.add_argument(
        "--profile-only-slow", action="store_true",
        help="--profile gibi ama sadece H/P > 6x benchmark'lar için",
    )
    parser.add_argument(
        "--telemetry", action="store_true",
        help="Normal benchmarktan sonra Cargo telemetry feature'lı ayrı profiling çalıştır",
    )
    parser.add_argument(
        "--deep-profile", action="store_true",
        help="Normal benchmarktan sonra tam profiler paketini çalıştır (telemetry dahil)",
    )
    parser.add_argument(
        "--profile-arch",
        choices=("auto", "x86_64", "aarch64", "generic"),
        default="auto",
        help="Yerel profiling mimarisi (varsayılan: auto)",
    )
    parser.add_argument(
        "--expected-tag", type=str, default=None,
        help="Beklenen HudHud version tag'i (binary ile uyuşmazsa abort)",
    )
    parser.add_argument(
        "--official", action="store_true",
        help="Resmî mod: eksik kaynakta abort, tüm tekrarlar başarılı olmalı, --allow-incomplete ile override",
    )
    parser.add_argument(
        "--allow-incomplete", action="store_true",
        help="Eksik kaynak/FAIL durumunda abort etme, ranked=false olarak devam et",
    )
    parser.add_argument(
        "--hudhud-binary", type=str, default=None,
        help="Kullanılacak hudhud binary'sinin absolute path'i (varsayılan: auto-detect)",
    )
    parser.add_argument(
        "--output-dir", type=str, default=None,
        help="Timing/profiling artifact'larının yazılacağı absolute dizin (varsayılan: auto)",
    )
    args = parser.parse_args()

    # ── G0: --hudhud-binary override ──
    global BINARY
    if args.hudhud_binary:
        custom_binary = Path(args.hudhud_binary)
        if not custom_binary.exists():
            print(f"{RED}✗  --hudhud-binary: {custom_binary} bulunamadı{NC}")
            sys.exit(1)
        if not os.access(custom_binary, os.X_OK):
            print(f"{RED}✗  --hudhud-binary: {custom_binary} çalıştırılabilir değil{NC}")
            sys.exit(1)
        BINARY = custom_binary
        print(f"{GREEN}✓  Custom binary: {BINARY}{NC}")
    # ── G0: --output-dir override ──
    output_dir_override = None
    if args.output_dir:
        output_dir_override = Path(args.output_dir)
        output_dir_override.mkdir(parents=True, exist_ok=True)

    # ── Determine benchmarks to run ──
    if args.only:
        selected = [b.strip() for b in args.only.split(",")]
        unknown = set(selected) - set(BENCHMARKS.keys())
        if unknown:
            print(f"{RED}✗  Bilinmeyen benchmark(lar): {', '.join(sorted(unknown))}{NC}")
            print(f"   Kullanılabilir: {', '.join(sorted(BENCHMARKS.keys()))}")
            sys.exit(1)
        bench_keys = selected
    else:
        bench_keys = list(BENCHMARKS.keys())

    # ── Determine languages ──
    if args.languages:
        selected = [l.strip() for l in args.languages.split(",")]
        unknown = set(selected) - set(LANGUAGES)
        if unknown:
            print(f"{RED}✗  Bilinmeyen dil(ler): {', '.join(sorted(unknown))}{NC}")
            print(f"   Kullanılabilir: {', '.join(LANGUAGES)}")
            sys.exit(1)
        langs = selected
    elif args.skip_hudhud:
        langs = [l for l in LANGUAGES if l != "hudhud"]
    else:
        langs = list(LANGUAGES)

    # ── Header ──
    total_tasks = len(bench_keys) * len(langs) * args.runs
    print()
    print(f"{BOLD}{CYAN}╔══════════════════════════════════════════════════════════╗{NC}")
    print(f"{BOLD}{CYAN}║   HudHudScript Cross-Language Benchmark Runner           ║{NC}")
    print(f"{BOLD}{CYAN}╚══════════════════════════════════════════════════════════╝{NC}")
    print()
    print(f"  Benchmark'lar : {', '.join(bench_keys)}")
    print(f"  Diller        : {', '.join(langs)}")
    print(f"  Çalıştırma    : {args.runs} kez/her")
    print(f"  Toplam iş     : {total_tasks} çalıştırma")
    print(f"  Çıktı dosyası : {RESULTS_FILE}")
    print()

    if args.dry_run:
        print(f"{YELLOW}══ DRY RUN — hiçbir şey çalıştırılmadı ══{NC}")
        return

    # ── Build / version-check hudhud ──
    if "hudhud" in langs:
        if args.no_build:
            expected = get_cargo_version()
            actual = get_binary_version(BINARY) if BINARY.exists() else "missing"
            if actual != expected:
                if args.official:
                    print(f"{RED}✗  Resmî mod: --no-build ile binary mismatch (binary={actual}, Cargo.toml={expected}) — abort.{NC}")
                    sys.exit(1)
                print(f"{YELLOW}⚠  --no-build: binary={actual}, Cargo.toml={expected} — devam ediliyor{NC}")
            else:
                print(f"{GREEN}✓  Binary v{actual} — Cargo.toml ile eşleşiyor{NC}")
        else:
            if not ensure_binary():
                print(f"\n{RED}HudHud binary derlenemedi. --skip-hudhud ile devam edebilirsiniz.{NC}")
                sys.exit(1)

    # ── Source matrix pre-check ──
    if args.official and not args.allow_incomplete:
        missing = []
        for b in bench_keys:
            for l in langs:
                try:
                    benchmark_source(b, l)
                except (KeyError, FileNotFoundError):
                    missing.append(f"{b}/{l}")
        if missing:
            print(f"{RED}✗  Resmî mod: {len(missing)} eksik kaynak — abort.{NC}")
            for m in missing:
                print(f"     {m}")
            print(f"   İpucu: --allow-incomplete ile devam edebilirsiniz (ranked=false).")
            sys.exit(1)
        print(f"{GREEN}✓  Kaynak matrisi tam ({len(bench_keys)} × {len(langs)} = {len(bench_keys)*len(langs)} hücre){NC}\n")

    # ── Detect versions ──
    print(f"{CYAN}══ Dil versiyonları tespit ediliyor...{NC}")
    versions = detect_versions()
    for lang in langs:
        ver_str = versions.get(lang, "bilinmiyor")
        print(f"  {lang:>8s}: {ver_str}")
    print()

    # ── Create execution ──
    hudhud_version = versions.get("hudhud", "unknown")
    try:
        version_tag = bstorage.normalize_version_tag(hudhud_version)
    except ValueError:
        print(f"{RED}✗  HudHud versiyonu normalize edilemedi: '{hudhud_version}'{NC}")
        sys.exit(1)

    # ── Expected-tag check ──
    if args.expected_tag:
        try:
            expected_tag = bstorage.normalize_version_tag(args.expected_tag)
        except ValueError:
            print(f"{RED}✗  --expected-tag normalize edilemedi: '{args.expected_tag}'{NC}")
            sys.exit(1)
        if expected_tag != version_tag:
            print(f"{RED}✗  İstenen tag {expected_tag}, çalıştırılacak binary {version_tag}. Benchmark başlatılmadı.{NC}")
            sys.exit(1)
        print(f"{GREEN}✓  Expected tag {expected_tag} binary {version_tag} ile eşleşiyor{NC}")

    # ── Collect provenance metadata ──
    import hashlib as _hashlib
    binary_sha = ""
    git_sha = ""
    try:
        if BINARY.exists():
            binary_sha = _hashlib.sha256(BINARY.read_bytes()).hexdigest()[:16]
    except Exception:
        pass
    try:
        r = subprocess.run(
            ["git", "-C", str(HHS_REPO), "rev-parse", "HEAD"],
            capture_output=True, text=True, timeout=5,
        )
        if r.returncode == 0:
            git_sha = r.stdout.strip()[:12]
    except Exception:
        pass

    execution = bstorage.create_execution(
        version_tag=version_tag,
        selected_benchmarks=bench_keys,
        languages=langs,
        repetitions=args.runs,
        trigger_source="cli",
        command_json={
            "argv": sys.argv,
            "actual_version_tag": version_tag,
            "requested_version_tag": args.expected_tag,
            "git_commit_sha": git_sha,
            "binary_path": str(BINARY),
            "binary_sha256": binary_sha,
        },
    )
    exec_id = execution["id"]
    run_num = execution["run_number"]
    print(f"{BOLD}Benchmark execution: ID {exec_id} · tag {version_tag} · Run #{run_num}{NC}")
    print()

    # ── Run all benchmarks ──
    start_all = time.time()
    all_results = []
    last_error = None

    try:
        for bi, bench_key in enumerate(bench_keys, 1):
            bench = BENCHMARKS[bench_key]
            bench_start = time.time()

            print(f"{BOLD}{CYAN}══ [{bi}/{len(bench_keys)}] {bench['title']} — {bench['desc']} ══{NC}")

            lang_results = []
            for lang in langs:
                if lang not in LANG_SUFFIXES:
                    lang_results.append({"language": lang, "ranked": False, "status": "unknown", "error": "unknown language"})
                    print(f"  {GRAY}{lang:>8s}: bilinmeyen dil{NC}")
                    continue

                source_path = SOURCE_DIR / lang / f"{bench_key}{LANG_SUFFIXES[lang]}"
                if not source_path.exists():
                    lang_results.append(_canonical_result(
                        lang, "", False, False, [], [], 0, 0, 0, 0,
                        "median", None, None, None, None, None, None,
                        status="missing", error=f"source not found: {source_path}"))
                    print(f"  {RED}{lang:>8s}: kaynak yok → ranked=false{NC}")
                    continue

                print(f"  {lang:>8s} ", end="", flush=True)
                res = run_language(bench_key, lang, args.runs, args.warmups, statistic=args.statistic)
                lang_results.append(res)

                # Print per-run results inline
                run_indicators = []
                for r in res["results"]:
                    if r.get("ok"):
                        run_indicators.append(f"{GREEN}{r['ms']}ms{NC}")
                    elif r.get("skipped"):
                        run_indicators.append(f"{YELLOW}SKIP{NC}")
                    else:
                        run_indicators.append(f"{RED}✗{NC}")
                runs_str = " ".join(run_indicators)
                stat_val = res.get("selected_ms")
                stat_str = fmt_ms(stat_val)
                if res.get("skipped"):
                    status = f"{YELLOW}SKIP{NC}"
                else:
                    status = status_icon(res["ok"], stat_val)
                print(f"{runs_str}  → {args.statistic} {stat_str} {status}")

            bench_elapsed = time.time() - bench_start
            bench_entry = {
                "timestamp": datetime.now(timezone.utc).astimezone().isoformat(),
                "benchmark": bench_key,
                "execution_id": exec_id,
                "binary_path": str(BINARY),
                "binary_sha256": binary_sha,
                "versions": versions,
                "languages": lang_results,
            }
            all_results.append(bench_entry)

            # Save after each benchmark (incremental), linked to execution
            save_benchmark_result(exec_id, bench_entry)

            ok_count = sum(1 for lr in lang_results if lr["ok"])
            print(f"  {GRAY}⏱  {bench_elapsed:.1f}s | {ok_count}/{len(lang_results)} geçti{NC}")
            print()

    except KeyboardInterrupt:
        last_error = "KeyboardInterrupt"
        print(f"\n{YELLOW}⚠  Interrupt alındı, execution finalize ediliyor...{NC}")
    except Exception as e:
        last_error = str(e)[:1000]
        print(f"\n{RED}✗  Hata: {e}{NC}")
    finally:
        # ── Semantic post-run check ──
        # Execution status must never be "completed" when a recorded cell is an
        # unexpected FAIL, even for an exploratory/non-official invocation.
        if not last_error:
            from check_correctness import SKIPPED_RESULTS
            accepted_skips, unexpected_fails = classify_unranked_cells(
                all_results, SKIPPED_RESULTS
            )
            if accepted_skips:
                print(f"\n{GREEN}✓  {len(accepted_skips)} accepted SKIP: {', '.join(accepted_skips)}{NC}")
            if unexpected_fails:
                last_error = f"Run FAILED: {len(unexpected_fails)} unexpected unranked cells: {', '.join(unexpected_fails[:10])}"
                print(f"\n{RED}✗  Koşu BAŞARISIZ — {len(unexpected_fails)} beklenmeyen hücre ranked=false{NC}")
                for fc in unexpected_fails[:15]:
                    print(f"     {fc}")
                if len(unexpected_fails) > 15:
                    print(f"     ... ve {len(unexpected_fails) - 15} hücre daha")

        # Finalize execution
        bstorage.finalize_execution(exec_id, error=last_error)
        if last_error:
            print(f"{YELLOW}Execution ID {exec_id} · status=partial/failed{NC}")
            if args.official:
                sys.exit(1)
        else:
            final = bstorage.get_execution(exec_id)
            print(f"{GREEN}Execution ID {exec_id} · status={final['status']}{NC}")

    # ── Summary table ──
    total_elapsed = time.time() - start_all

    # Build table with dynamic column widths
    lang_width = max(8, max(len(l) for l in langs) + 1)
    bench_width = max(18, max(len(BENCHMARKS.get(b, {}).get("title", b)) for b in bench_keys) + 2)
    col_sep = " │ "
    inner_sep = "─┼─"

    def fmt_cell(val, width, color=""):
        text = str(val)
        pad = width - len(text)
        if color:
            return f"{color}{text}{NC}" + " " * pad
        return text + " " * pad

    def line_sep():
        parts = ["─" * bench_width]
        for _ in langs:
            parts.append("─" * lang_width)
        return "─" + "─┼─".join(parts) + "─"

    print()
    print(f"{BOLD}{CYAN}┌{line_sep()[1:-1]}┐{NC}")
    title_line = f"  ÖZET — {len(bench_keys)} benchmark × {len(langs)} dil"
    pad = len(line_sep()) - len(title_line) - 2
    print(f"{BOLD}{CYAN}│{NC} {BOLD}{title_line}{' ' * pad}{CYAN}│{NC}")
    print(f"{BOLD}{CYAN}├{line_sep()[1:-1]}┤{NC}")

    # Header row
    header = fmt_cell("Benchmark", bench_width)
    for lang in langs:
        header += col_sep + fmt_cell(lang, lang_width)
    print(f"{BOLD}│{header} │{NC}")
    print(f"{BOLD}{CYAN}├{line_sep()[1:-1]}┤{NC}")

    total_ok = 0
    total_runs = 0
    lang_totals = {l: {"ok": 0, "fail": 0, "skip": 0, "total_ms": 0.0, "count": 0} for l in langs}

    for entry in all_results:
        bench_key = entry["benchmark"]
        bench_title = BENCHMARKS.get(bench_key, {}).get("title", bench_key)
        row = fmt_cell(bench_title[:bench_width - 1], bench_width)

        ok_langs = [x for x in entry["languages"] if x["ok"] and x.get("selected_ms") is not None]
        best_ms = min((x.get("selected_ms", x.get("avg_ms")) for x in ok_langs), default=None)

        for lang in langs:
            lr = next((x for x in entry["languages"] if x["language"] == lang), None)
            total_runs += 1
            sel_ms = lr.get("selected_ms") if lr else None
            if sel_ms is None and lr:
                sel_ms = lr.get("avg_ms")
            if lr and lr.get("ok") and sel_ms is not None:
                total_ok += 1
                lang_totals[lang]["ok"] += 1
                lang_totals[lang]["total_ms"] += sel_ms
                lang_totals[lang]["count"] += 1
                if sel_ms == best_ms and best_ms is not None:
                    cell = fmt_cell(f"{sel_ms:>5.0f}ms", lang_width, GREEN)
                else:
                    ratio = sel_ms / best_ms if best_ms else 0
                    color = RED if ratio >= 5 else (YELLOW if ratio >= 2 else "")
                    cell = fmt_cell(f"{sel_ms:>5.0f}ms", lang_width, color)
            elif lr and lr.get("skipped"):
                lang_totals[lang]["skip"] += 1
                cell = fmt_cell("  SKIP", lang_width, YELLOW)
            elif lr and not lr.get("ok") and lr.get("ok") is not None:
                lang_totals[lang]["fail"] += 1
                cell = fmt_cell("  FAIL", lang_width, RED)
            else:
                cell = fmt_cell("   N/A", lang_width, GRAY)
            row += col_sep + cell
        print(f"│{row} │")

    print(f"{BOLD}{CYAN}├{line_sep()[1:-1]}┤{NC}")

    # Totals / averages row
    row = fmt_cell("Ortalama", bench_width, BOLD)
    for lang in langs:
        stats = lang_totals[lang]
        if stats["count"] > 0:
            avg = stats["total_ms"] / stats["count"]
            row += col_sep + fmt_cell(f"{avg:>5.0f}ms", lang_width, BOLD)
        else:
            row += col_sep + fmt_cell("   —", lang_width, GRAY)
    print(f"{BOLD}│{row} │{NC}")

    row = fmt_cell("Başarı", bench_width, BOLD)
    for lang in langs:
        stats = lang_totals[lang]
        total = stats["ok"] + stats["fail"]
        if total > 0:
            pct = stats["ok"] / total * 100
            color = GREEN if pct >= 80 else (YELLOW if pct >= 50 else RED)
            row += col_sep + fmt_cell(f"{pct:>4.0f}%", lang_width, color)
        else:
            row += col_sep + fmt_cell("   —", lang_width, GRAY)
    print(f"{BOLD}│{row} │{NC}")

    print(f"{BOLD}{CYAN}└{line_sep()[1:-1]}┘{NC}")
    print()
    print(f"  {GREEN}✓  {len(bench_keys)} benchmark kaydedildi → {RESULTS_FILE}{NC}")
    if exec_id:
        print(f"  {GREEN}   Execution ID {exec_id} · tag {version_tag} · Run #{run_num}{NC}")
    print(f"  {GRAY}⏱  Toplam süre: {total_elapsed:.0f}s{NC}")
    print()

    # ── Otomatik profiling ────────────────────────────────────────────
    if args.profile or args.profile_only_slow or args.telemetry or args.deep_profile:
        # Flamegraph için perf izni kontrolü
        sysctl_conf = Path("/etc/sysctl.conf")
        has_paranoid = False
        if sysctl_conf.exists():
            for line in sysctl_conf.read_text().splitlines():
                if line.strip().startswith("kernel.perf_event_paranoid"):
                    try:
                        if int(line.split("=")[1].strip()) == -1:
                            has_paranoid = True
                    except Exception:
                        pass
        if not has_paranoid:
            print(f"\n  {YELLOW}▸ Uyarı: /etc/sysctl.conf'da kernel.perf_event_paranoid = -1 ayarı bulunamadı.{NC}")
            print(f"    {GRAY}Flamegraph çalıştırmak için şu komutları çalıştırın:{NC}")
            print(f"    {GRAY}  echo 'kernel.perf_event_paranoid = -1' | sudo tee -a /etc/sysctl.conf{NC}")
            print(f"    {GRAY}  sudo sysctl -p{NC}")
            print(f"    {GRAY}Veya geçici olarak: sudo sysctl kernel.perf_event_paranoid=-1{NC}")
            print()

        profile_targets = bench_keys
        if args.profile_only_slow:
            # H/P > 6x benchmark'ları tespit et (son run'daki sonuçlara göre)
            slow = []
            for bk in bench_keys:
                results = load_existing_results()
                # En son bu benchmark için hudhud ve python sonuçları
                h_times = [r for r in results if r.get("benchmark") == bk
                           and any(l["language"] == "hudhud" for l in r.get("languages", []))]
                if h_times:
                    last = h_times[-1]
                    langs_map = {l["language"]: l.get("selected_ms", l.get("avg_ms", 0)) for l in last.get("languages", [])}
                    h, p = langs_map.get("hudhud", 0), langs_map.get("python", 1)
                    if p > 0 and (h / p) > 6:
                        slow.append(bk)
            profile_targets = slow if slow else bench_keys

        if profile_targets:
            import subprocess as _sp
            import sys as _sys
            only_arg = ",".join(profile_targets)
            print(f"\n  {CYAN}▸ Profiling başlıyor: {only_arg}{NC}")
            profile_script = SCRIPT_DIR / "profile_benchmarks.py"
            cmd = build_profile_command(
                _sys.executable,
                profile_script,
                profile_targets,
                telemetry=args.telemetry,
                deep_profile=args.deep_profile,
                profile_arch=args.profile_arch,
                no_build=args.no_build,
            )
            profile_result = _sp.run(cmd, cwd=str(SCRIPT_DIR))
            if (args.telemetry or args.deep_profile) and profile_result.returncode != 0:
                print(f"{RED}✗ Profiling pipeline başarısız (rc={profile_result.returncode}).{NC}")
                sys.exit(profile_result.returncode or 1)


if __name__ == "__main__":
    main()
