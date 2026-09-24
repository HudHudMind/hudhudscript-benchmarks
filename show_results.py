#!/usr/bin/env python3
"""
HudHudScript — Benchmark Sonuç Raporlayıcı (salt-okunur)
=========================================================
Benchmark ÇALIŞTIRMAZ. Mevcut sonuç dosyalarını okuyup konsolda
profesyonel tablolar ve Unicode bar grafiklerle özetler.

Kaynaklar (--source):
    lang    data/benchmark_results.json       (run_benchmarks.py çıktısı — diller arası)
    engine  data/benchmark_engine_results.json (run_benchmarks_engine.py çıktısı — vm/jit/aot)

Hesaplanan istatistikler (her dil / her motor için):
    Arit(m)  aritmetik ortalama (ms)
    Geo(m)   geometrik ortalama (ms)
    Harm(m)  harmonik ortalama (ms)
    GeoSkor  benchmark başına en hızlıya oranın geometrik ortalaması
             (1.00 = her benchmarkta en hızlı; düşük = iyi)

Kullanım:
    python3 show_results.py                          # diller arası, en güncel koşular
    python3 show_results.py --source engine          # vm/jit/aot karşılaştırması
    python3 show_results.py --only fib,ack           # sadece belirli benchmarklar
    python3 show_results.py --languages hudhud,python
    python3 show_results.py --execution 418          # belirli execution'ın kayıtları
    python3 show_results.py --chart fib              # tek benchmarkın bar grafiği
    python3 show_results.py --executions             # execution listesi (tarama yok)
"""

import argparse
import json
import math
import os
import re
import sys
import time
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
DEFAULT_LANG_RESULTS = SCRIPT_DIR / "data" / "benchmark_results.json"
DEFAULT_ENGINE_RESULTS = SCRIPT_DIR / "data" / "benchmark_engine_results.json"

# ── ANSI ──────────────────────────────────────────────────────────
_USE_COLOR = sys.stdout.isatty() and os.environ.get("NO_COLOR") is None


def _c(code: str, s: str) -> str:
    return f"\033[{code}m{s}\033[0m" if _USE_COLOR else s


def BOLD(s):    return _c("1", s)
def CYAN(s):    return _c("0;36", s)
def GREEN(s):   return _c("0;32", s)
def YELLOW(s):  return _c("1;33", s)
def RED(s):     return _c("0;31", s)
def GRAY(s):    return _c("0;90", s)
def MAGENTA(s): return _c("0;35", s)


# ── Biçimlendirme yardımcıları ────────────────────────────────────

def fmt_ms(v) -> str:
    """Milisaniyeyi insan-okur forma çevir."""
    if v is None:
        return "—"
    v = float(v)
    if v < 1000:
        return f"{v:.0f}ms"
    if v < 60_000:
        return f"{v / 1000:.2f}s"
    m, s = divmod(int(v / 1000), 60)
    return f"{m}m{s:02d}s"


def fmt_cell(v) -> str:
    return fmt_ms(v) if v is not None else "—"


def fmt_compact(v) -> str:
    """Tablo hücresi için kompakt süre biçimi (786ms, 1.1s, 41s, 3m)."""
    if v is None:
        return "—"
    v = float(v)
    if v < 1000:
        return f"{v:.0f}ms"
    if v < 10_000:
        return f"{v / 1000:.1f}s"
    if v < 60_000:
        return f"{v / 1000:.0f}s"
    return f"{v / 60_000:.0f}m"


def fmt_ratio(r: float) -> str:
    """Kompakt oran biçimi (1.0x, 7.7x, 29x)."""
    return f"{r:.1f}x" if r < 10 else f"{r:.0f}x"


def cell_text(ms: float, r: float, mode: str) -> str:
    """Tablo hücresi metni — mode: time | ratio | both."""
    if mode == "time":
        return fmt_compact(ms)
    if mode == "ratio":
        return fmt_ratio(r)
    return f"{fmt_compact(ms)} | {fmt_ratio(r)}"


CELL_LEGENDS = {
    "time":  "Hücre: süre — kazanan yeşil-kalın; renk en hızlıya orana göre (yeşil<2x · sarı 2–5x · kırmızı >5x)",
    "ratio": "Hücre: en hızlıya oran — 1.0x = kazanan (yeşil<2x · sarı 2–5x · kırmızı >5x)",
    "both":  "Hücre: süre | en hızlıya oran — 1.0x = kazanan (yeşil<2x · sarı 2–5x · kırmızı >5x)",
}


def ratio_color(r: float) -> str:
    if r >= 5:
        return RED
    if r >= 2:
        return YELLOW
    return GREEN


BAR_PARTS = "▏▎▍▌▋▊▉"


def bar(value: float, max_value: float, width: int = 40, color=GREEN) -> str:
    """Unicode blok bar. value/max_value oranına göre dolu/kısmi bloklar."""
    if max_value <= 0 or value <= 0:
        return ""
    frac = min(value / max_value, 1.0)
    total = frac * width
    full = int(total)
    rem = total - full
    partial = BAR_PARTS[int(rem * len(BAR_PARTS))] if rem > 0.005 else ""
    return color("█" * full + partial)


# ── İstatistik yardımcıları ───────────────────────────────────────

def mean_arith(xs):
    return sum(xs) / len(xs) if xs else None


def mean_geo(xs):
    if not xs or any(x <= 0 for x in xs):
        return None
    return math.exp(sum(math.log(x) for x in xs) / len(xs))


def mean_harm(xs):
    if not xs or any(x <= 0 for x in xs):
        return None
    return len(xs) / sum(1.0 / x for x in xs)


# ── Büyük JSON'u akıtarak oku (belleği şişirmeden) ────────────────

def iter_json_array(path: Path, chunk_size: int = 1 << 22):
    """138MB+ benchmark_results.json'u obje-obje akıt. Tam dosyayı RAM'e almaz."""
    dec = json.JSONDecoder()
    ws = re.compile(r"[\s,]*")
    buf, pos = "", 0
    with open(path, encoding="utf-8") as f:
        while True:
            m = ws.match(buf, pos)
            pos = m.end()
            if pos >= len(buf):
                data = f.read(chunk_size)
                if not data:
                    return
                buf, pos = data, 0
                continue
            c = buf[pos]
            if c == "]":
                return
            if c == "{":
                try:
                    obj, end = dec.raw_decode(buf, pos)
                except json.JSONDecodeError:
                    data = f.read(chunk_size)
                    if not data:
                        return
                    buf = buf[pos:] + data
                    pos = 0
                    continue
                pos = end
                yield obj
            else:  # '[' ve beklenmeyen karakterler
                pos += 1


# ── Veri seçimi ───────────────────────────────────────────────────

def select_latest(entries):
    """Aynı benchmark'ın tekrarlarında en güncel kaydı tut."""
    latest = {}
    for e in entries:
        b = e.get("benchmark")
        if b is None:
            continue
        old = latest.get(b)
        if old is None or str(e.get("timestamp", "")) >= str(old.get("timestamp", "")):
            latest[b] = e
    return latest


def cell_of(lang_result) -> tuple:
    """(durum, ms) — durum: ok | fail | skip."""
    if lang_result is None:
        return ("missing", None)
    if lang_result.get("skipped"):
        return ("skip", None)
    ms = lang_result.get("selected_ms")
    if lang_result.get("ok") and ms is not None and ms > 0:
        return ("ok", float(ms))
    return ("fail", None)


# ── Rapor: diller arası (benchmark_results.json) ──────────────────

def report_lang(args):
    path = Path(args.results)
    if not path.exists():
        print(RED(f"✗ Sonuç dosyası yok: {path}"))
        print(GRAY("  Önce run_benchmarks.py çalıştırın."))
        sys.exit(1)

    size_mb = path.stat().st_size / 1e6
    only = {b.strip() for b in args.only.split(",")} if args.only else None
    langs_filter = {l.strip() for l in args.languages.split(",")} if args.languages else None

    if args.executions:
        list_executions(path)
        return

    print(GRAY(f"Taranıyor: {path} ({size_mb:.0f} MB) ..."), file=sys.stderr)
    t0 = time.time()
    n_scanned = 0
    per_exec = {}          # execution_id -> {benchmark: entry}
    exec_meta = {}         # execution_id -> (timestamp, hudhud_version)
    ts_min, ts_max = None, None
    for e in iter_json_array(path):
        n_scanned += 1
        b = e.get("benchmark")
        if b is None:
            continue
        if only and b not in only:
            continue
        eid = e.get("execution_id")
        ts = str(e.get("timestamp", ""))
        ts_min = ts if ts_min is None or ts < ts_min else ts_min
        ts_max = ts if ts_max is None or ts > ts_max else ts_max
        hv = (e.get("versions") or {}).get("hudhud", "?")
        if eid not in exec_meta:
            exec_meta[eid] = (ts, hv)
        bucket = per_exec.setdefault(eid, {})
        old = bucket.get(b)
        if old is None or ts >= str(old.get("timestamp", "")):
            bucket[b] = e

    if n_scanned == 0:
        print(RED("✗ Dosyada kayıt yok."))
        sys.exit(1)

    if args.execution is not None:
        if args.execution not in per_exec:
            print(RED(f"✗ Execution {args.execution} bulunamadı. "
                      f"Mevcut: {sorted(k for k in per_exec if k is not None)}"))
            sys.exit(1)
        mode = f"execution #{args.execution}"
        selected = per_exec[args.execution]
    else:
        mode = "benchmark başına en güncel kayıt"
        selected = {}
        for bucket in per_exec.values():
            for b, e in bucket.items():
                old = selected.get(b)
                if old is None or str(e.get("timestamp", "")) >= str(old.get("timestamp", "")):
                    selected[b] = e

    # Hücre matrisi: bench -> lang -> (durum, ms)
    matrix = {}
    all_langs = []
    seen_langs = set()
    for b, e in selected.items():
        row = {}
        for lr in e.get("languages", []):
            lang = lr.get("language")
            if langs_filter and lang not in langs_filter:
                continue
            if lang not in seen_langs:
                seen_langs.add(lang)
                all_langs.append(lang)
            row[lang] = cell_of(lr)
        matrix[b] = row

    if not matrix:
        print(RED("✗ Seçime uyan kayıt yok (—only / —languages / —execution filtrelerini kontrol edin)."))
        sys.exit(1)

    # ── Skorlama: kapsama düzeltmesi ──
    # Ham GeoSkor, dilin GEÇTİĞİ benchmarklar üzerinden hesaplanır; ardından başarı
    # oranına göre düzeltilir:
    #     Skor* = GeoSkor × (toplam benchmark ÷ geçen benchmark)
    # %100 başarılı dilin skoru hiç değişmez (çarpan 1.00); başarısızlık oranı
    # arttıkça skor o oranla şişer. Keyfi sabit yok — düzeltme yalnızca başarı
    # oranından türetilir. (Eşdeğer yorum: her FAIL, dilin kendi ortalamasından
    # türeyen bir oran cezası olarak genel skora dağıtılır.)
    n_bench = len(matrix)
    ok_all = {l: 0 for l in all_langs}
    for b, row in matrix.items():
        for l, (st, ms) in row.items():
            if st == "ok":
                ok_all[l] += 1

    # Kazananlar + skorlar
    wins = {l: 0 for l in all_langs}
    ratios = {l: [] for l in all_langs}
    times_ok = {l: [] for l in all_langs}
    fail_cnt = {l: 0 for l in all_langs}
    skip_cnt = {l: 0 for l in all_langs}
    for b, row in matrix.items():
        ok_langs = {l: ms for l, (st, ms) in row.items() if st == "ok"}
        if not ok_langs:
            continue
        best = min(ok_langs.values())
        for l, (st, ms) in row.items():
            if st == "ok":
                times_ok[l].append(ms)
                ratios[l].append(ms / best)
                if ms == best:
                    wins[l] += 1
            elif st == "fail":
                fail_cnt[l] += 1
            elif st == "skip":
                skip_cnt[l] += 1

    def geo_score(l):
        g = mean_geo(ratios[l])
        return g if g is not None else float("inf")

    def score_corrected(l):
        """Skor* = GeoSkor × (n_bench / ok) — kapsama düzeltmeli adil skor."""
        g = geo_score(l)
        if g == float("inf") or ok_all[l] == 0:
            return float("inf")
        return g * (n_bench / ok_all[l])

    # Dil sırası: düzeltilmiş skora göre (en adil skorlu solda)
    all_langs.sort(key=score_corrected)

    # ── Başlık paneli ──
    print()
    print(BOLD(CYAN("╔══════════════════════════════════════════════════════════╗")))
    print(BOLD(CYAN("║   HudHudScript Benchmark Sonuç Raporu — Diller Arası     ║")))
    print(BOLD(CYAN("╚══════════════════════════════════════════════════════════╝")))
    print()
    print(f"  Kaynak    : {path} {GRAY(f'({size_mb:.0f} MB)')}")
    print(f"  Mod       : {mode} {GRAY(f'({n_scanned} kayıt tarandı, {n_bench} benchmark seçildi)')}")
    print(f"  Zaman     : {ts_min or '?'} → {ts_max or '?'}")
    hvs = sorted({(e.get("versions") or {}).get("hudhud", "?") for e in selected.values()} - {"?"})
    if len(hvs) > 6:
        hvs_show = ", ".join(hvs[:6]) + f" +{len(hvs) - 6} sürüm daha"
    else:
        hvs_show = ", ".join(hvs) if hvs else "?"
    print(f"  hudhud    : {hvs_show}")
    print()

    # ── Özet istatistik tablosu ──
    print(BOLD(CYAN("── ÖZET İSTATİSTİKLER ──")))
    hdr = (f"  {'Dil':<10} {'n':>3} {'Zafer':>5} {'Başarı%':>7} "
           f"{'Arit(m)':>10} {'Geo(m)':>10} {'Harm(m)':>10} {'GeoSkor':>8} {'Skor*':>6}")
    print(BOLD(hdr))
    print(GRAY("  " + "─" * (len(hdr) - 2)))
    for l in all_langs:
        n_ok = len(times_ok[l])
        ar = mean_arith(times_ok[l])
        gm = mean_geo(times_ok[l])
        hm = mean_harm(times_ok[l])
        gs = mean_geo(ratios[l])
        cor = score_corrected(l)
        succ = ok_all[l] / n_bench * 100 if n_bench else 0
        name = BOLD(f"{l:<10}")
        sc = GREEN(f"{gs:8.2f}") if gs is not None and gs < 1.05 else (
            YELLOW(f"{gs:8.2f}") if gs is not None and gs < 2.0 else RED(f"{gs:8.2f}"))
        cs = GRAY(f"{'—':>6}") if cor == float("inf") else (
            GREEN(f"{cor:6.2f}") if cor < 1.05 else (
            YELLOW(f"{cor:6.2f}") if cor < 2.0 else RED(f"{cor:6.2f}")))
        print(f"  {name} {n_ok:>3} {wins[l]:>5} {succ:>6.0f}% "
              f"{fmt_cell(ar):>10} {fmt_cell(gm):>10} {fmt_cell(hm):>10} {sc} {cs}")
    incomplete = [l for l in all_langs if fail_cnt[l] + skip_cnt[l]]
    if incomplete:
        det = " · ".join(f"{l}: {ok_all[l]}/{n_bench} → ×{n_bench / ok_all[l]:.2f}"
                         for l in incomplete if ok_all[l])
        print(GRAY(f"  ⚠ Skor* kapsama düzeltmesi: {det}"))
    print(GRAY(
        "\n  Arit/Geo/Harm(m): geçilen benchmarklardaki sürelerin (ms) aritmetik/geometrik/harmonik ortalaması."
        "\n  GeoSkor: benchmark başına en hızlı dile oranın geometrik ortalaması — 1.00 = her zaman en hızlı."
        "\n  Skor* = GeoSkor × (toplam ÷ geçen) — başarı oranına göre düzeltilmiş adil skor (%100 başarılıda GeoSkor'a eşit)."))
    print()

    # ── Grafik 1: Skor* (kapsama düzeltmeli) ──
    print(BOLD(CYAN("── GRAFİK: Skor* — kapsama düzeltmeli (düşük = iyi) ──")))
    gs_vals = {l: score_corrected(l) for l in all_langs}
    mx = max((v for v in gs_vals.values() if v != float("inf")), default=0)
    for l in all_langs:
        v = gs_vals[l]
        label = f"{l:<10}"
        if v == float("inf"):
            print(f"  {label} {GRAY('veri yok')}")
            continue
        print(f"  {label} {v:5.2f} {bar(v, mx, 40, ratio_color(v))}")
    print()

    # ── Grafik 2: Zafer sayıları ──
    print(BOLD(CYAN("── GRAFİK: Zafer sayıları ──")))
    mx = max(wins.values(), default=0)
    for l in sorted(all_langs, key=lambda x: -wins[x]):
        if mx == 0:
            break
        w = wins[l]
        print(f"  {l:<10} {w:5d} {GREEN(bar(w, mx, 40))}")
    if mx == 0:
        print(GRAY("  (kazanan yok — hiçbir hücre ok değil)"))
    print()

    # ── Ana karşılaştırma tablosu (hücre: "değer | oranx") ──
    print(BOLD(CYAN("── BENÇMARK KARŞILAŞTIRMASI ──")))
    bw = max(18, min(30, max(len(b) for b in matrix) + 2))

    # 1. geçiş: düz hücre dizileri → en geniş hücreden kolon genişliği
    plain_rows = {}
    for b, row in matrix.items():
        ok_langs = {l: ms for l, (st, ms) in row.items() if st == "ok"}
        best = min(ok_langs.values()) if ok_langs else None
        cells = {}
        for l in all_langs:
            st, ms = row.get(l, ("missing", None))
            if st == "ok":
                r = (ms / best) if best else 1.0
                style = "win" if ms == best else r
                cells[l] = (cell_text(ms, r, args.cell), style)
            elif st == "skip":
                cells[l] = ("SKIP", "skip")
            elif st == "fail":
                cells[l] = ("✗ FAIL", "fail")
            else:
                cells[l] = ("—", "missing")
        plain_rows[b] = cells
    cw = max(8, max(len(c[0]) for row in plain_rows.values() for c in row.values()))

    # 2. geçiş: renklendir ve bas
    n_cols = len(all_langs)
    top    = " ┌" + "─" * bw + ("┬" + "─" * cw) * n_cols + "┐"
    mid    = " ├" + "─" * bw + ("┼" + "─" * cw) * n_cols + "┤"
    bottom = " └" + "─" * bw + ("┴" + "─" * cw) * n_cols + "┘"
    print(top)
    bench_label = "Benchmark"
    hdr0 = BOLD(f"{bench_label:<{bw}}")
    lang_hdrs = "│".join(BOLD(f"{l[:cw]:>{cw}}") for l in all_langs)
    print(f" │{hdr0}│{lang_hdrs}│")
    print(mid)
    for b in sorted(matrix):
        parts = []
        for l in all_langs:
            plain, style = plain_rows[b][l]
            body = f"{plain:>{cw}}"
            if style == "win":
                parts.append(GREEN(BOLD(body)))
            elif isinstance(style, float):
                parts.append(ratio_color(style)(body))
            elif style == "skip":
                parts.append(YELLOW(body))
            elif style == "fail":
                parts.append(RED(body))
            else:
                parts.append(GRAY(body))
        print(f" │{b[:bw - 1]:<{bw}}│" + "│".join(parts) + "│")
    print(bottom)
    print(GRAY(f"  {CELL_LEGENDS[args.cell]} · SKIP = bilinen eksiklik"))
    print()

    # ── Tek benchmark grafiği ──
    if args.chart:
        chart_one(matrix, args.chart, all_langs)


def chart_one(matrix, key, langs):
    if key not in matrix:
        print(RED(f"✗ Benchmark yok: {key} (mevcut: {', '.join(sorted(matrix))})"))
        sys.exit(1)
    row = matrix[key]
    data = sorted(((l, ms) for l, (st, ms) in row.items() if st == "ok"), key=lambda x: x[1])
    if not data:
        print(YELLOW(f"⚠ {key}: geçerli süre yok"))
        return
    print(BOLD(CYAN(f"── GRAFİK: {key} ──")))
    mx = data[-1][1]
    for l, ms in data:
        print(f"  {l:<10} {fmt_ms(ms):>9} {bar(ms, mx, 40, ratio_color(ms / mx))}")
    print()


# ── Rapor: motor karşılaştırması (benchmark_engine_results.json) ──

def report_engine(args):
    path = Path(args.results)
    if not path.exists():
        print(RED(f"✗ Sonuç dosyası yok: {path}"))
        print(GRAY("  Önce run_benchmarks_engine.py çalıştırın."))
        sys.exit(1)
    d = json.loads(path.read_text(encoding="utf-8"))
    only = {b.strip() for b in args.only.split(",")} if args.only else None

    benches = [b for b in d.get("benchmarks", []) if not only or b["key"] in only]
    if not benches:
        print(RED("✗ Seçime uyan benchmark yok."))
        sys.exit(1)
    engine_names = []
    for b in benches:
        for e in b.get("engines", {}):
            if e not in engine_names:
                engine_names.append(e)

    # ── Skorlama: kapsama düzeltmesi (diller tarafıyla aynı formül) ──
    #     Skor* = GeoSkor × (toplam ÷ desteklenen/ geçen)
    wins = {e: 0 for e in engine_names}
    ratios = {e: [] for e in engine_names}
    times_ok = {e: [] for e in engine_names}
    unsup = {e: 0 for e in engine_names}
    for b in benches:
        row = b.get("engines", {})
        ok_e = {e: v["selected_ms"] for e, v in row.items()
                if v.get("ok") and v.get("selected_ms")}
        if not ok_e:
            continue
        best = min(ok_e.values())
        for e in engine_names:
            v = row.get(e)
            if v is None:
                continue
            if v.get("unsupported"):
                unsup[e] += 1
            if v.get("ok") and v.get("selected_ms"):
                ms = v["selected_ms"]
                times_ok[e].append(ms)
                ratios[e].append(ms / best)
                if ms == best:
                    wins[e] += 1

    def geo_score(e):
        g = mean_geo(ratios[e])
        return g if g is not None else float("inf")

    # Destek/eksik sayımı TÜM benchmarklar üzerinden
    unsup_all = {e: 0 for e in engine_names}
    for b in benches:
        for e in engine_names:
            v = b.get("engines", {}).get(e)
            if v is not None and (v.get("unsupported") or not (v.get("ok") and v.get("selected_ms"))):
                unsup_all[e] += 1
    n_bench = len(benches)

    def score_corrected(e):
        g = geo_score(e)
        supported = n_bench - unsup_all[e]
        if g == float("inf") or supported == 0:
            return float("inf")
        return g * (n_bench / supported)

    engine_names.sort(key=score_corrected)

    print()
    print(BOLD(CYAN("╔══════════════════════════════════════════════════════════╗")))
    print(BOLD(CYAN("║   HudHudScript Benchmark Sonuç Raporu — Motor Karşılaştır. ║")))
    print(BOLD(CYAN("╚══════════════════════════════════════════════════════════╝")))
    print()
    print(f"  Kaynak    : {path}")
    print(f"  Zaman     : {d.get('timestamp', '?')}   hudhud v{d.get('hudhud_version', '?')}")
    print(f"  Koşu      : {d.get('runs', '?')} tekrar · istatistik: {d.get('statistic', '?')} "
          f"· süre: {d.get('total_duration_sec', 0):.0f}s")
    print(f"  Benchmark : {n_bench}")
    print()

    print(BOLD(CYAN("── ÖZET İSTATİSTİKLER (motor başına) ──")))
    hdr = (f"  {'Motor':<14} {'n':>3} {'Zafer':>5} {'Dest.Ön':>7} "
           f"{'Arit(m)':>10} {'Geo(m)':>10} {'Harm(m)':>10} {'GeoSkor':>8} {'Skor*':>6}")
    print(BOLD(hdr))
    print(GRAY("  " + "─" * (len(hdr) - 2)))
    for e in engine_names:
        n_ok = len(times_ok[e])
        gs = mean_geo(ratios[e])
        cor = score_corrected(e)
        name = BOLD(f"{e:<14}")
        sc = GREEN(f"{gs:8.2f}") if gs is not None and gs < 1.05 else (
            YELLOW(f"{gs:8.2f}") if gs is not None and gs < 2.0 else RED(f"{gs:8.2f}"))
        cs = GRAY(f"{'—':>6}") if cor == float("inf") else (
            GREEN(f"{cor:6.2f}") if cor < 1.05 else (
            YELLOW(f"{cor:6.2f}") if cor < 2.0 else RED(f"{cor:6.2f}")))
        print(f"  {name} {n_ok:>3} {wins[e]:>5} {n_bench - unsup_all[e]:>7} "
              f"{fmt_cell(mean_arith(times_ok[e])):>10} {fmt_cell(mean_geo(times_ok[e])):>10} "
              f"{fmt_cell(mean_harm(times_ok[e])):>10} {sc} {cs}")
    incomplete = [e for e in engine_names if unsup_all[e]]
    if incomplete:
        det = " · ".join(f"{e}: {n_bench - unsup_all[e]}/{n_bench} → ×{n_bench / (n_bench - unsup_all[e]):.2f}"
                         for e in incomplete if n_bench - unsup_all[e])
        print(GRAY(f"  ⚠ Skor* kapsama düzeltmesi: {det}"))
    print(GRAY("  Skor* = GeoSkor × (toplam ÷ desteklenen) — %100 kapsanan motorlarda GeoSkor'a eşit."))
    print()

    print(BOLD(CYAN("── GRAFİK: Skor* — kapsama düzeltmeli (düşük = iyi) ──")))
    gs_vals = {e: score_corrected(e) for e in engine_names}
    mx = max((v for v in gs_vals.values() if v != float("inf")), default=0)
    for e in engine_names:
        v = gs_vals[e]
        if v == float("inf"):
            print(f"  {e:<14} {GRAY('veri yok')}")
            continue
        print(f"  {e:<14} {v:5.2f} {bar(v, mx, 40, ratio_color(v))}")
    print()

    print(BOLD(CYAN("── GRAFİK: Zafer sayıları ──")))
    mx = max(wins.values(), default=0)
    for e in sorted(engine_names, key=lambda x: -wins[x]):
        if mx == 0:
            break
        print(f"  {e:<14} {wins[e]:5d} {GREEN(bar(wins[e], mx, 40))}")
    print()

    print(BOLD(CYAN("── BENÇMARK KARŞILAŞTIRMASI ──")))
    bw = max(18, min(30, max(len(b["key"]) for b in benches) + 2))

    # 1. geçiş: düz hücreler → kolon genişliği
    plain_rows = {}
    for b in benches:
        row = b.get("engines", {})
        ok_ms = {e: v["selected_ms"] for e, v in row.items()
                 if v.get("ok") and v.get("selected_ms")}
        best = min(ok_ms.values()) if ok_ms else None
        cells = {}
        for e in engine_names:
            v = row.get(e)
            if v is None:
                cells[e] = ("—", "missing")
            elif v.get("unsupported"):
                cells[e] = ("dest.değil", "missing")
            elif v.get("ok") and v.get("selected_ms"):
                ms = v["selected_ms"]
                r = (ms / best) if best else 1.0
                style = "win" if ms == best else r
                cells[e] = (cell_text(ms, r, args.cell), style)
            else:
                cells[e] = ("✗ FAIL", "fail")
        plain_rows[b["key"]] = cells
    cw = max(list(len(e) for e in engine_names)
             + [len(c[0]) for row in plain_rows.values() for c in row.values()]
             + [8])

    # 2. geçiş: renklendir ve bas
    n_cols = len(engine_names)
    top    = " ┌" + "─" * bw + ("┬" + "─" * cw) * n_cols + "┐"
    mid    = " ├" + "─" * bw + ("┼" + "─" * cw) * n_cols + "┤"
    bottom = " └" + "─" * bw + ("┴" + "─" * cw) * n_cols + "┘"
    print(top)
    bench_label = "Benchmark"
    hdr0 = BOLD(f"{bench_label:<{bw}}")
    eng_hdrs = "│".join(BOLD(f"{e[:cw]:>{cw}}") for e in engine_names)
    print(f" │{hdr0}│{eng_hdrs}│")
    print(mid)
    for b in sorted(benches, key=lambda x: x["key"]):
        parts = []
        for e in engine_names:
            plain, style = plain_rows[b["key"]][e]
            body = f"{plain:>{cw}}"
            if style == "win":
                parts.append(GREEN(BOLD(body)))
            elif isinstance(style, float):
                parts.append(ratio_color(style)(body))
            elif style == "fail":
                parts.append(RED(body))
            else:
                parts.append(GRAY(body))
        print(f" │{b['key'][:bw - 1]:<{bw}}│" + "│".join(parts) + "│")
    print(bottom)
    print(GRAY(f"  {CELL_LEGENDS[args.cell]}"))
    print()

    if args.chart:
        key = args.chart
        row = next((b for b in benches if b["key"] == key), None)
        if row is None:
            print(RED(f"✗ Benchmark yok: {key}"))
            sys.exit(1)
        data = sorted(((e, v["selected_ms"]) for e, v in row["engines"].items()
                       if v.get("ok") and v.get("selected_ms")), key=lambda x: x[1])
        if data:
            print(BOLD(CYAN(f"── GRAFİK: {key} ──")))
            mx = data[-1][1]
            for e, ms in data:
                print(f"  {e:<14} {fmt_ms(ms):>9} {bar(ms, mx, 40, ratio_color(ms / mx))}")
            print()


# ── Execution listesi ─────────────────────────────────────────────

def list_executions(path: Path):
    """Tüm execution'ları özetle (benchmark sayısı + zaman + hudhud sürümü)."""
    print(GRAY(f"Taranıyor: {path} ..."), file=sys.stderr)
    execs = {}
    for e in iter_json_array(path):
        eid = e.get("execution_id")
        if eid is None:
            continue
        rec = execs.setdefault(eid, {"n": 0, "ts": "", "hudhud": "?"})
        rec["n"] += 1
        ts = str(e.get("timestamp", ""))
        if ts > rec["ts"]:
            rec["ts"] = ts
            rec["hudhud"] = (e.get("versions") or {}).get("hudhud", "?")
    print()
    print(BOLD(CYAN(f"── EXECUTION'LAR ({len(execs)}) ──")))
    print(BOLD(f"  {'ID':>5} {'Kayıt':>6} {'Son zaman':<26} hudhud"))
    print(GRAY("  " + "─" * 50))
    for eid in sorted(execs):
        r = execs[eid]
        print(f"  {eid:>5} {r['n']:>6} {r['ts']:<26} {r['hudhud']}")
    print(GRAY("\n  Kullanım: --execution <ID>"))


# ── Main ──────────────────────────────────────────────────────────

def main():
    ap = argparse.ArgumentParser(
        description="Benchmark sonuçlarını okur ve raporlar (benchmark ÇALIŞTIRMAZ)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Örnekler:
  python3 show_results.py                          # diller arası özet + tam tablo
  python3 show_results.py --source engine          # vm / jit / aot karşılaştırması
  python3 show_results.py --only fib,ack,sieve
  python3 show_results.py --languages hudhud,python,lua
  python3 show_results.py --execution 418
  python3 show_results.py --chart fib
  python3 show_results.py --cell ratio          # hücrelerde sadece oran (1.0x, 4.7x...)
  python3 show_results.py --cell both           # hücrelerde süre | oran
  python3 show_results.py --executions
        """)
    ap.add_argument("--source", choices=["lang", "engine"], default="lang",
                    help="lang: benchmark_results.json (diller) · engine: benchmark_engine_results.json")
    ap.add_argument("--results", default=None,
                    help="Sonuç JSON yolu (varsayılan: kaynağa göre data/ altı)")
    ap.add_argument("--only", default=None, help="Sadece bu benchmarklar (virgülle)")
    ap.add_argument("--languages", default=None, help="Sadece bu diller (virgülle, lang kaynağı)")
    ap.add_argument("--execution", type=int, default=None,
                    help="Sadece bu execution_id'nin kayıtları (lang kaynağı)")
    ap.add_argument("--executions", action="store_true",
                    help="Execution listesini göster ve çık (lang kaynağı)")
    ap.add_argument("--chart", default=None, help="Bu benchmark için bar grafiği göster")
    ap.add_argument("--cell", choices=["time", "ratio", "both"], default="time",
                    help="Tablo hücre içeriği: time=sadece süre (varsayılan) · ratio=sadece oran · both=süre | oran")
    ap.add_argument("--no-color", action="store_true", help="ANSI renklerini kapat")
    args = ap.parse_args()

    global _USE_COLOR
    if args.no_color:
        _USE_COLOR = False

    if args.results is None:
        args.results = str(DEFAULT_LANG_RESULTS if args.source == "lang"
                           else DEFAULT_ENGINE_RESULTS)

    if args.source == "lang":
        report_lang(args)
    else:
        report_engine(args)


if __name__ == "__main__":
    main()
