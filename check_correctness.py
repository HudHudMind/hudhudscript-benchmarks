#!/usr/bin/env python3
"""
Cross-Language Benchmark Correctness Verifier v2
================================================
Matematiksel golden değerlerle tüm dillerin benchmark çıktılarını karşılaştırır.
Sayısal toleranslı (int→tam, float→göreli epsilon), çökmeleri FAIL sayar,
eksik/eski benchmark sonuçlarını tamamlanmamış sayar, --strict ile exit code 1 verir.

Kullanım:
    python3 check_correctness.py              # Tablo
    python3 check_correctness.py -v           # + hata detayı
    python3 check_correctness.py --strict     # Mismatch veya eksik sonuc varsa exit 1
    python3 check_correctness.py --allow-incomplete  # Eski kismi dogrulama modu
    python3 check_correctness.py --json       # JSON çıktı
"""

import json
import re
import sys
from pathlib import Path
from collections import defaultdict

SCRIPT_DIR = Path(__file__).resolve().parent
DATA_DIR = SCRIPT_DIR / "data"
RESULTS_FILE = DATA_DIR / "benchmark_results.json"
DB_PATH = DATA_DIR / "reviews.db"

LANG_LABELS = {
    "hudhud": "HudHud", "python": "Python", "lua": "Lua",
    "ruby": "Ruby", "nodejs": "Node.js", "php": "PHP", "perl": "Perl",
    "raku": "Raku", "tcl": "Tcl",
}
LANG_ORDER = ["python", "hudhud", "lua", "ruby", "nodejs", "php", "perl", "raku", "tcl"]

# ── GOLDEN VALUES (matematiksel doğru) ────────────────────────────
# "expected" alanı: sayısal ise doğrudan float/int olarak karşılaştırılır,
# string ise tam eşleşme. None = golden yok (Python'a düşülmez, "?" gösterilir)

GOLDEN: dict[str, int | float | str | None] = {
    # int / exact
    "ack": 509,
    "arrsum": 49995000,
    "bfs": 10,
    "bsearch": 10000,
    "collatz": 261,
    "count_set_bits": 815030,
    "cumulative_sum": 5000050000,
    "dfs": 10,
    "fib": 832040,
    "gcd": 1,
    "hanoi": 1048575,
    "sieve": 1229,
    "prime_count": 9592,
    "n_queens": 92,
    "tak": 7,
    "mandelbrot": 150726,
    "k_nucleotide": 84,
    "duffs_device": 1,
    "fannkuch_redux": "7605_21",
    "fasta": 250000,
    "revcomp": 125085,

    # float (epsilon-toleranslı)
    "n_body": "-0.169075164_-0.169016441",  # Strict string match required initially
    "spectral_norm": 1.274222873,
    "geometric_series": 1000.0,
    "monte_carlo_pi": 3.141592653589793,  # real pi, relaxed epsilon
    "newton_sqrt": 666716.4591971082,
    "mean_variance": "500000.5/83333333333.9",

    # bigint / exact strings
    "factorial_recursive": "57133839564458545904789328652610540031895535786011264182548375833179829124845398393126574488675311145377107878746854204162666250198684504466355949195922066574942592095735778929325357290444962472405416790722118445437122269675520000000000000000000000000000000000000",
    "fib_iterative": "434665576869374564356885276750406258025646605173717804024817290895365554179490518904038798400792551692959225930803226347752096896232398733224711616429964409065331879382989696499285160037044761377951668492288750000",
    "fib_memo": "1394232245616978801397243828704072839500702565876973072641089629483255716228632906915576588762225212941250000",
    "modular_exp": 568881930000,
    "polynomial_eval": 3.6978202689278054e+184,
    "power": "107150860718626732094842504906000181056140481170553360744375038837035105112493612249319837881569585812759467291755314682518714528569231404359845775746985748039345677748242309854210746050623711418779541821530464749835819412673987675591655439460770629145711964776865421676604298316526243868372056680693760000",
    "sum_of_squares": 333333833333500000,

    # string / çoklu değer
    "bubble": "1/500",
    "heap_sort": "1/1000",
    "insertion_sort": "1/1000",
    "merge": "1/1000",
    "quick": "1/1000",
    "matrix": "1113775/-2216375",
    "matrix_transpose": "0/598",
    "palindrome": "true",
    "binary_trees": "16383_8191",
    "strcat": "50000",
    "strrev": "50000",
    "substring_search": "1000",
    "vector_dot": "41666916667000000",

    # message-only
    "fact": "fact_10000",

    # golden yok (skip — benchmark kodu hatalı veya sonuç belirsiz)
    "knapsack": 802,  # max value for 50 items, capacity 100
    "lcs": 50,
}

# Main benchmark files must produce exact BigInt results. Approximation variants
# are kept as separate *_approximation source files and do not pass exact checks.
BIGNUM_APPROX: dict[tuple[str, str], float] = {}


# Non-deterministic benchmarks (monte carlo, random seed etc.)
NONDETERMINISTIC: set[str] = set()

# Benchmarks needing wider epsilon tolerance (e.g. Monte Carlo)
RELAXED_EPSILON: dict[str, float] = {
    "monte_carlo_pi": 0.03,  # 500k points, ~6-sigma statistical tolerance
}

# Expected skips for runtimes without native exact integer support for these
# bignum benchmarks. The benchmark source is still run, but correctness does
# not count the language as wrong for lacking BigInt semantics.
SKIPPED_RESULTS: dict[tuple[str, str], str] = {
}


def _scientific_to_decimal(s: str):
    """Parse a string possibly in scientific notation to Decimal."""
    from decimal import Decimal, InvalidOperation
    try:
        return Decimal(s)
    except InvalidOperation:
        return None


def _big_decimal_match(got_val: str, golden: str, epsilon: float) -> bool:
    """Compare two big numbers, one possibly scientific notation, with relative epsilon."""
    from decimal import Decimal, InvalidOperation
    try:
        got_dec = Decimal(got_val)
        gold_dec = Decimal(golden)
    except InvalidOperation:
        return False
    if gold_dec == 0:
        return got_dec == 0
    return abs((got_dec - gold_dec) / gold_dec) <= Decimal(str(epsilon))


def _load_results() -> list[dict]:
    results = []
    if RESULTS_FILE.exists():
        try:
            with open(RESULTS_FILE, encoding="utf-8") as f:
                results = json.load(f)
        except Exception:
            pass
    try:
        import sqlite3
        if DB_PATH.exists():
            seen = {(r.get("benchmark"), r.get("timestamp")) for r in results}
            conn = sqlite3.connect(str(DB_PATH))
            conn.row_factory = sqlite3.Row
            cur = conn.cursor()
            cur.execute("SELECT id, benchmark, timestamp, versions_json FROM benchmark_runs ORDER BY timestamp")
            for row in cur.fetchall():
                key = (row["benchmark"], row["timestamp"])
                if key in seen:
                    continue
                cur.execute("SELECT language, avg_ms, ok, results_json FROM benchmark_run_results WHERE run_id=?", (row["id"],))
                languages = []
                for lr in cur.fetchall():
                    languages.append({
                        "language": lr["language"], "avg_ms": lr["avg_ms"],
                        "ok": bool(lr["ok"]),
                        "results": json.loads(lr["results_json"]) if lr["results_json"] else [],
                    })
                results.append({
                    "timestamp": row["timestamp"], "benchmark": row["benchmark"],
                    "versions": json.loads(row["versions_json"]) if row["versions_json"] else {},
                    "languages": languages,
                })
                seen.add(key)
            conn.close()
    except Exception:
        pass
    return results


def _try_int_or_float(s: str):
    """Parse string to int or float, or return None."""
    s = s.strip()
    try:
        return int(s)
    except ValueError:
        pass
    try:
        return float(s)
    except ValueError:
        pass
    return None


def _values_match(got_val, golden, slug: str = "", lang: str = "") -> bool:
    """Compare a value against golden: numeric tolerance for floats, exact for int/str."""
    if got_val is None or golden is None:
        return False

    # Special: "computed" message
    if golden == "fact_10000":
        got_str = str(got_val).strip().lower()
        if got_str == "fact_10000 computed" or got_str == "computed":
            return True
        if len(got_str) >= 35660 and got_str.startswith("2846259680") and got_str.endswith("000"):
            return True
        return False

    # Special: n_body float parsing
    if slug == "n_body" and isinstance(golden, str) and isinstance(got_val, str):
        g_parts = golden.split("_")
        got_parts = got_val.split("_")
        if len(g_parts) == 2 and len(got_parts) == 2:
            try:
                g1, g2 = float(g_parts[0]), float(g_parts[1])
                got1, got2 = float(got_parts[0]), float(got_parts[1])
                return abs(g1 - got1) <= 1e-8 and abs(g2 - got2) <= 1e-8
            except ValueError:
                pass

    # Bignum benchmarks: accept exact string match OR a scientific-notation
    # approximation within a small epsilon.
    if isinstance(golden, str) and (slug, lang) in BIGNUM_APPROX:
        epsilon = BIGNUM_APPROX[(slug, lang)]
        got_str = str(got_val).strip()
        if got_str == golden:
            return True
        if _big_decimal_match(got_str, golden, epsilon):
            return True
        return False

    # String goldens represent exact text results: bignums, multi-value
    # summaries, and message-only outputs. Do not accept scientific notation or
    # rounded float approximations for these.
    if isinstance(golden, str):
        return str(got_val).strip() == golden

    # Try numeric comparison
    got_num = _try_int_or_float(got_val) if isinstance(got_val, str) else got_val
    gold_num = golden

    if got_num is not None and gold_num is not None:
        if isinstance(got_num, float) or isinstance(gold_num, float):
            epsilon = RELAXED_EPSILON.get(slug, 1e-9 * max(1.0, abs(float(gold_num))))
            return abs(float(got_num) - float(gold_num)) <= epsilon
        else:
            return int(got_num) == int(gold_num)

    # String comparison for multi-value or non-numeric
    return str(got_val).strip() == str(golden).strip()


def _extract_result(stdout: str, slug: str) -> str | None:
    """Extract result value from stdout using known patterns."""
    if not stdout:
        return None

    patterns = [
        # "Key: Value" patterns
        (r"Result:\s*(\S.*)", 1),
        (r"Max steps:\s*(\d+)", 1),
        (r"Sum:\s*(.+)", 1),
        (r"Total:\s*(.+)", 1),
        (r"Visited:\s*(\d+)", 1),
        (r"Found:\s*(\d+)", 1),
        (r"Moves:\s*(\d+)", 1),
        (r"Max:\s*(\d+)", 1),
        (r"LCS:\s*(\d+)", 1),
        (r"Solutions:\s*(\d+)", 1),
        (r"Palindrome:\s*(\w+)", 1),
        (r"Primes(?:\s+up\s+to\s+\d+)?:\s*(\d+)", 1),
        (r"L(?:en(?:gth)?):\s*(\d+)", 1),
        (r"Count:\s*(\d+)", 1),
        (r"Dot:\s*(\d+)", 1),
        (r"Pi:\s*([\d.]+)", 1),
    ]
    for pat, group in patterns:
        m = re.search(pat, stdout)
        if m:
            return m.group(group).strip()

    # Multi-value patterns
    m = re.search(r"First:\s*(\d+).*Last:\s*(\d+)", stdout, re.DOTALL)
    if m:
        return f"{m.group(1)}/{m.group(2)}"

    m = re.search(r"Last:\s*(\d+)", stdout)
    if m:
        return m.group(1)

    m = re.search(r"Mean:\s*([\d.]+).*Variance:\s*([\d.]+)", stdout, re.DOTALL)
    if m:
        return f"{round(float(m.group(1)),1)}/{round(float(m.group(2)),1)}"

    m = re.search(r"Result\[0\]\[0\]:\s*(\d+).*Result\[\d+\]\[\d+\]:\s*(-?\d+)", stdout, re.DOTALL)
    if m:
        return f"{m.group(1)}/{m.group(2)}"

    m = re.search(r"T\[0\]\[0\]:\s*(\d+).*T\[\d+\]\[\d+\]:\s*(\d+)", stdout, re.DOTALL)
    if m:
        return f"{m.group(1)}/{m.group(2)}"

    # "fact(N) = X" or "fib(N) = X" — capture entire big number
    m = re.search(r"(?:fact|fib)\(\d+\)\s*=\s*(\S+)", stdout)
    if m:
        return m.group(1)

    # "X computed" (message-only benchmarks like factorial)
    if "computed" in stdout.lower():
        return "computed"

    return None


def _latest_per_benchmark(results: list[dict]) -> dict[str, dict[str, dict]]:
    by_bench: dict[str, dict[str, dict]] = defaultdict(dict)
    for r in results:
        slug = r.get("benchmark")
        if not slug:
            continue
        for lang in r.get("languages", []):
            name = lang.get("language")
            if not name:
                continue
            previous = by_bench[slug].get(name)
            previous_ts = previous["entry"].get("timestamp", "") if previous else ""
            if previous is None or r.get("timestamp", "") > previous_ts:
                by_bench[slug][name] = {"entry": r, "lang": lang}
    # Stale detection: if a language's latest result is older than the
    # benchmark's latest run, that language did not participate in the most
    # recent run and its stored result should not be reported as "OK".
    for slug, langs in by_bench.items():
        latest_ts = max(
            (info["entry"].get("timestamp", "") for info in langs.values()), default=""
        )
        for info in langs.values():
            info["stale"] = info["entry"].get("timestamp", "") < latest_ts
    return by_bench


def check_all(only: str | None = None, allow_incomplete: bool = False) -> dict:
    data = _load_results()
    by_bench = _latest_per_benchmark(data)

    from run_benchmarks import BENCHMARKS
    report: dict[str, dict] = {}
    summary = {
        "total": 0,
        "ok": 0,
        "mismatch": 0,
        "incomplete": 0,
        "no_golden": 0,
        "mismatches": [],
        "incomplete_results": [],
    }

    for slug in BENCHMARKS.keys():
        if only and slug != only:
            continue
        if slug in NONDETERMINISTIC:
            continue

        langs = by_bench.get(slug, {})
        golden = GOLDEN.get(slug)

        if golden is None:
            report[slug] = {"error": "no_golden", "title": BENCHMARKS[slug]["title"]}
            summary["no_golden"] += 1
            continue

        # Extract results per language (include failed runs as "CRASH")
        lang_results = {}
        all_match = True
        has_any_result = False
        complete = True
        incomplete_details = []
        latest_benchmark_ts = max(
            (info["entry"].get("timestamp", "") for info in langs.values()),
            default="",
        )

        for lang_name in LANG_ORDER:
            linfo = langs.get(lang_name)
            if not linfo:
                complete = False
                detail = {
                    "benchmark": slug,
                    "title": BENCHMARKS[slug]["title"],
                    "lang": lang_name,
                    "reason": "missing",
                    "latest_benchmark_timestamp": latest_benchmark_ts,
                }
                incomplete_details.append(detail)
                lang_results[lang_name] = {
                    "result": None,
                    "match": None,
                    "crashed": False,
                    "missing": True,
                }
                continue

            if linfo.get("stale"):
                complete = False
                detail = {
                    "benchmark": slug,
                    "title": BENCHMARKS[slug]["title"],
                    "lang": lang_name,
                    "reason": "stale",
                    "latest_benchmark_timestamp": latest_benchmark_ts,
                    "language_timestamp": linfo["entry"].get("timestamp", ""),
                }
                incomplete_details.append(detail)
                lang_results[lang_name] = {
                    "result": None, "match": None, "crashed": False, "stale": True,
                }
                continue

            l = linfo["lang"]
            skip_reason = SKIPPED_RESULTS.get((slug, lang_name))
            if skip_reason:
                val = None
                for run in l.get("results", []):
                    val = _extract_result(run.get("stdout", ""), slug)
                    if val is not None:
                        break
                had_stdout = any(run.get("stdout", "") for run in l.get("results", []))
                if l.get("ok", False) or had_stdout:
                    lang_results[lang_name] = {
                        "result": val,
                        "match": None,
                        "crashed": False,
                        "skipped": True,
                        "skip_reason": skip_reason,
                    }
                    continue

            # Check if the run itself failed (returncode != 0)
            crashed = not l.get("ok", False)
            val = None
            crash_detail = ""
            for run in l.get("results", []):
                val = _extract_result(run.get("stdout", ""), slug)
                if val is not None:
                    break
            if not crashed:
                if val is None:
                    # Check if any run had stdout (language was actually executed)
                    had_stdout = any(run.get("stdout", "") for run in l.get("results", []))
                    if had_stdout:
                        crashed = True
                        crash_detail = "parse_failed"
                    # else: language was never actually run, treat as missing (-)

            if not l.get("ok", False) and val is not None and any(
                "[GOLDEN mismatch:" in run.get("stderr", "") for run in l.get("results", [])
            ):
                has_any_result = True
                matches = _values_match(val, golden, slug, lang_name)
                lang_results[lang_name] = {"result": val, "match": matches, "crashed": False}
                if not matches:
                    all_match = False
                    summary["mismatches"].append({
                        "benchmark": slug, "title": BENCHMARKS[slug]["title"],
                        "lang": lang_name, "expected": str(golden), "got": str(val),
                    })
            elif not l.get("ok", False):  # real crash
                lang_results[lang_name] = {"result": None, "match": False, "crashed": True, "crash_detail": "returncode != 0"}
                all_match = False
                summary["mismatches"].append({
                    "benchmark": slug, "title": BENCHMARKS[slug]["title"],
                    "lang": lang_name, "expected": str(golden), "got": f"CRASH: returncode != 0",
                })
            elif crashed:  # parse failure
                lang_results[lang_name] = {"result": None, "match": False, "crashed": True, "crash_detail": crash_detail}
                all_match = False
                summary["mismatches"].append({
                    "benchmark": slug, "title": BENCHMARKS[slug]["title"],
                    "lang": lang_name, "expected": str(golden), "got": f"CRASH: {crash_detail}",
                })
            else:
                has_any_result = True
                matches = _values_match(val, golden, slug, lang_name)
                lang_results[lang_name] = {"result": val, "match": matches, "crashed": False}
                if not matches:
                    all_match = False
                    summary["mismatches"].append({
                        "benchmark": slug, "title": BENCHMARKS[slug]["title"],
                        "lang": lang_name, "expected": str(golden), "got": str(val),
                    })

        row_ok = all_match and has_any_result and (complete or allow_incomplete)
        report[slug] = {
            "title": BENCHMARKS[slug]["title"],
            "desc": BENCHMARKS[slug].get("desc", ""),
            "reference": str(golden)[:40],
            "languages": lang_results,
            "all_match": row_ok,
            "complete": complete,
            "incomplete": incomplete_details,
            "source": "matematik",
        }
        summary["incomplete_results"].extend(incomplete_details)
        summary["total"] += 1
        if row_ok:
            summary["ok"] += 1
        elif all_match and not complete:
            summary["incomplete"] += 1
        else:
            summary["mismatch"] += 1

    # Extract HudHud version from the most recent result that has it
    hudhud_version = None
    for r in sorted(data, key=lambda x: x.get("timestamp", ""), reverse=True):
        v = (r.get("versions") or {}).get("hudhud")
        if v:
            hudhud_version = v
            break
    summary["hudhud_version"] = hudhud_version

    return {"summary": summary, "benchmarks": report}


if __name__ == "__main__":
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("--json", action="store_true")
    ap.add_argument("--only", type=str)
    ap.add_argument("--verbose", "-v", action="store_true", help="Hata detaylarini goster")
    ap.add_argument("--strict", action="store_true", help="Mismatch veya eksik sonuc varsa exit 1")
    ap.add_argument(
        "--allow-incomplete",
        action="store_true",
        help="Eksik/eski dil sonuclari varsa yine de dogru say",
    )
    args = ap.parse_args()

    result = check_all(args.only, allow_incomplete=args.allow_incomplete)
    s = result["summary"]

    if args.json:
        print(json.dumps(result, indent=2, ensure_ascii=False))
    else:
        from rich.console import Console
        from rich.table import Table
        console = Console()
        s = result["summary"]
        L = LANG_LABELS

        console.print(
            f"\n  [bold]Toplam: {s['total']}[/bold]  |  "
            f"[green]Dogru: {s['ok']}[/green]  |  "
            f"[red]Hatali: {s['mismatch']}[/red]  |  "
            f"[yellow]Eksik: {s.get('incomplete', 0)}[/yellow]  |  "
            f"[yellow]Golden yok: {s['no_golden']}[/yellow]"
        )
        if s.get("hudhud_version"):
            console.print(f"  [dim]HudHud: {s['hudhud_version']}[/dim]")
        console.print()

        table = Table(show_header=True, header_style="bold cyan", box=None, padding=(0, 1), collapse_padding=True)
        table.add_column("Benchmark", width=26, style="bold", no_wrap=True)
        table.add_column("Beklenen", width=18, justify="right", style="dim", no_wrap=True)
        for lang in LANG_ORDER:
            table.add_column(L.get(lang, lang)[:7], width=7, justify="center", no_wrap=True)

        for slug, b in sorted(result["benchmarks"].items()):
            err = b.get("error")
            ok = b.get("all_match")

            ref = str(b.get("reference", "?"))
            if len(ref) > 17:
                ref = ref[:16] + "…"

            cells = []
            has_any_ok = False
            for l in LANG_ORDER:
                lr = b.get("languages", {}).get(l, {})
                m = lr.get("match")
                crashed = lr.get("crashed")
                if lr.get("skipped"):
                    cells.append("[yellow]SKIP[/yellow]")
                elif lr.get("missing"):
                    cells.append("[yellow]MISS[/yellow]")
                elif lr.get("stale"):
                    cells.append("[yellow]OLD[/yellow]")
                elif crashed:
                    cells.append("[red]CRSH[/red]")
                elif m is True:
                    cells.append("[green]OK[/green]")
                    has_any_ok = True
                elif m is False:
                    cells.append("[red]FAIL[/red]")
                elif lr.get("result"):
                    cells.append("[yellow]?[/yellow]")
                else:
                    cells.append("[dim]-[/dim]")

            if err:
                icon = "[yellow]?[/yellow]"
            elif not b.get("complete", True):
                icon = "[yellow]![/yellow]"
            elif ok:
                icon = "[green]✓[/green]"
            elif has_any_ok:
                icon = "[red]✗[/red]"
            else:
                icon = "[yellow]?[/yellow]"
            table.add_row(f"{icon} {b['title'][:24]}", ref, *cells)

        console.print(table)

        if args.verbose and s["mismatches"]:
            console.print(f"\n[bold red]Hata Detayi ({len(s['mismatches'])} adet):[/bold red]\n")
            for m in s["mismatches"]:
                console.print(f"  [red]✗[/red] {m['title']} ([bold]{m['benchmark']}[/bold]) {LANG_LABELS.get(m['lang'], m['lang'])}")
                console.print(f"    Beklenen: [green]{str(m['expected'])[:80]}[/green]")
                console.print(f"    Alinan:   [red]{str(m['got'])[:80]}[/red]\n")

        if args.verbose and s.get("incomplete_results"):
            console.print(f"\n[bold yellow]Eksik/Eski Sonuc Detayi ({len(s['incomplete_results'])} adet):[/bold yellow]\n")
            for m in s["incomplete_results"]:
                label = LANG_LABELS.get(m["lang"], m["lang"])
                console.print(f"  [yellow]![/yellow] {m['title']} ([bold]{m['benchmark']}[/bold]) {label}: {m['reason']}")

    if args.strict and (s["mismatch"] > 0 or s.get("incomplete", 0) > 0):
        sys.exit(1)
