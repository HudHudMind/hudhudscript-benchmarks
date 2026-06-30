"""
Shared benchmark storage layer — framework-independent module used by both
CLI (run_benchmarks.py) and Flask (blueprints/benchmark.py).

Responsibilities:
- Schema migration (idempotent, add execution_id column to legacy tables)
- Execution lifecycle (create, record child, finalize)
- Tag counter management (race-safe run_number allocation)
- JSON atomik okuma/yazma (fcntl.flock + os.replace)
- Query helpers (tag summaries, execution lists, result loading)

Do not import Flask or any blueprint here.  Only sqlite3, json, os, fcntl.
"""

import json
import os
import sqlite3
import fcntl
import tempfile
import re
from datetime import datetime, timezone
from pathlib import Path

DATA_DIR = Path(__file__).resolve().parent / "data"
DATA_DIR.mkdir(parents=True, exist_ok=True)
DB_PATH = DATA_DIR / "reviews.db"
RESULTS_FILE = DATA_DIR / "benchmark_results.json"
RESULTS_LOCK = DATA_DIR / "benchmark_results.json.lock"


# ── Version normalisation ─────────────────────────────────────────

def normalize_version_tag(raw: str) -> str:
    """Normalise a raw version string to canonical tag format.

    "hudhud 0.7.359" -> "0.7.359"
    "v0.7.359"       -> "0.7.359"
    "0.7.359"        -> "0.7.359"
    """
    if not raw:
        raise ValueError("Empty version tag; cannot normalise")
    raw = raw.strip()
    # Strip leading 'v' or 'V'
    raw = re.sub(r'^[vV]', '', raw)
    # Strip leading "hudhud " prefix (case-insensitive)
    raw = re.sub(r'^[hH][uU][dD][hH][uU][dD]\s+', '', raw)
    raw = raw.strip()
    if not raw:
        raise ValueError(f"Version tag became empty after normalisation: {raw}")
    return raw


# ── Schema / migration ────────────────────────────────────────────

def ensure_benchmark_schema(conn: sqlite3.Connection) -> None:
    """Idempotent schema migration: create new tables, add execution_id column.

    Safe to call multiple times; uses IF NOT EXISTS and PRAGMA table_info checks.
    Must be called inside a transaction or the caller should commit.
    """
    conn.execute("PRAGMA foreign_keys = ON")

    # 1. New tables
    conn.executescript("""
        CREATE TABLE IF NOT EXISTS benchmark_runs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            benchmark TEXT NOT NULL,
            timestamp TEXT NOT NULL,
            versions_json TEXT
        );

        CREATE TABLE IF NOT EXISTS benchmark_run_results (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            run_id INTEGER NOT NULL REFERENCES benchmark_runs(id) ON DELETE CASCADE,
            language TEXT NOT NULL,
            avg_ms REAL,
            ok INTEGER NOT NULL,
            results_json TEXT
        );

        CREATE TABLE IF NOT EXISTS benchmark_tag_counters (
            version_tag     TEXT PRIMARY KEY,
            last_run_number INTEGER NOT NULL
        );

        CREATE TABLE IF NOT EXISTS benchmark_executions (
            id                        INTEGER PRIMARY KEY AUTOINCREMENT,
            version_tag               TEXT NOT NULL,
            run_number                INTEGER NOT NULL,
            status                    TEXT NOT NULL DEFAULT 'running',
            started_at                TEXT NOT NULL,
            finished_at               TEXT,
            expected_benchmark_count  INTEGER NOT NULL,
            completed_benchmark_count INTEGER NOT NULL DEFAULT 0,
            selected_benchmarks_json  TEXT NOT NULL,
            languages_json            TEXT NOT NULL,
            repetitions               INTEGER NOT NULL,
            trigger_source            TEXT NOT NULL,
            command_json              TEXT,
            error_message             TEXT,
            UNIQUE (version_tag, run_number),
            CHECK (status IN ('running', 'completed', 'partial', 'failed'))
        );
    """)

    # Indexes for new tables (IF NOT EXISTS)
    for idx_sql in [
        "CREATE INDEX IF NOT EXISTS idx_benchmark_executions_tag ON benchmark_executions(version_tag, run_number DESC)",
        "CREATE INDEX IF NOT EXISTS idx_benchmark_executions_started ON benchmark_executions(started_at DESC)",
    ]:
        conn.execute(idx_sql)

    # 2. Check if execution_id column exists on benchmark_runs
    cur = conn.execute("PRAGMA table_info(benchmark_runs)")
    cols = {row[1] for row in cur.fetchall()}

    if "execution_id" not in cols:
        conn.execute("""
            ALTER TABLE benchmark_runs
            ADD COLUMN execution_id INTEGER
                REFERENCES benchmark_executions(id) ON DELETE CASCADE
        """)

    # 3. Indexes for added column (safe to create even after column exists)
    for idx_sql in [
        "CREATE INDEX IF NOT EXISTS idx_benchmark_runs_execution ON benchmark_runs(execution_id)",
        "CREATE UNIQUE INDEX IF NOT EXISTS idx_benchmark_runs_execution_benchmark ON benchmark_runs(execution_id, benchmark) WHERE execution_id IS NOT NULL",
    ]:
        try:
            conn.execute(idx_sql)
        except sqlite3.OperationalError:
            pass  # partial index may fail on old SQLite; non‑critical


# ── JSON lock helpers ─────────────────────────────────────────────

def _acquire_json_lock() -> int:
    """Acquire exclusive lock on the JSON results file. Returns fd."""
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    fd = os.open(str(RESULTS_LOCK), os.O_CREAT | os.O_RDWR)
    fcntl.flock(fd, fcntl.LOCK_EX)
    return fd


def _release_json_lock(fd: int) -> None:
    """Release lock and close fd."""
    try:
        fcntl.flock(fd, fcntl.LOCK_UN)
    except Exception:
        pass
    try:
        os.close(fd)
    except Exception:
        pass


def _load_json() -> list:
    """Load benchmark_results.json (no lock — caller must hold lock)."""
    if RESULTS_FILE.exists():
        try:
            with open(RESULTS_FILE, encoding="utf-8") as f:
                return json.load(f)
        except Exception:
            pass
    return []


def _save_json_atomic(data: list) -> None:
    """Atomik olarak benchmark_results.json'u güncelle (temp + os.replace).

    Caller must hold the JSON lock.
    """
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    tmp_fd, tmp_path = tempfile.mkstemp(
        suffix=".json", prefix="benchmark_results_", dir=str(DATA_DIR)
    )
    try:
        with os.fdopen(tmp_fd, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        os.replace(tmp_path, str(RESULTS_FILE))
    except Exception:
        # Clean up temp on failure
        try:
            os.unlink(tmp_path)
        except OSError:
            pass
        raise


# ── Execution lifecycle ──────────────────────────────────────────

def create_execution(
    version_tag: str,
    selected_benchmarks: list[str],
    languages: list[str],
    repetitions: int = 3,
    trigger_source: str = "cli",
    command_json: dict | None = None,
) -> dict:
    """Create a new parent execution row and allocate run_number.

    Race-safe: uses BEGIN IMMEDIATE transaction.
    Returns dict with id, version_tag, run_number, status.
    """
    conn = sqlite3.connect(str(DB_PATH))
    conn.execute("PRAGMA foreign_keys = ON")
    ensure_benchmark_schema(conn)  # idempotent (may commit via executescript)

    tag = normalize_version_tag(version_tag)
    started = datetime.now(timezone.utc).astimezone().isoformat()
    expected = len(selected_benchmarks)

    # Re‑open if ensure_benchmark_schema executed a script (commits implicitly)
    conn.close()
    conn = sqlite3.connect(str(DB_PATH))
    conn.execute("PRAGMA foreign_keys = ON")

    try:
        conn.execute("BEGIN IMMEDIATE")
        cur = conn.cursor()

        # Allocate run_number
        cur.execute(
            "SELECT last_run_number FROM benchmark_tag_counters WHERE version_tag = ?",
            (tag,),
        )
        row = cur.fetchone()
        if row is None:
            run_number = 1
            cur.execute(
                "INSERT INTO benchmark_tag_counters (version_tag, last_run_number) VALUES (?, ?)",
                (tag, run_number),
            )
        else:
            run_number = row[0] + 1
            cur.execute(
                "UPDATE benchmark_tag_counters SET last_run_number = ? WHERE version_tag = ?",
                (run_number, tag),
            )

        # Insert execution row
        cur.execute(
            """INSERT INTO benchmark_executions
               (version_tag, run_number, status, started_at,
                expected_benchmark_count, selected_benchmarks_json,
                languages_json, repetitions, trigger_source, command_json)
               VALUES (?, ?, 'running', ?, ?, ?, ?, ?, ?, ?)""",
            (
                tag,
                run_number,
                started,
                expected,
                json.dumps(selected_benchmarks, ensure_ascii=False),
                json.dumps(languages, ensure_ascii=False),
                repetitions,
                trigger_source,
                json.dumps(command_json, ensure_ascii=False) if command_json else None,
            ),
        )
        execution_id = cur.lastrowid

        conn.commit()
        return {
            "id": execution_id,
            "version_tag": tag,
            "run_number": run_number,
            "status": "running",
            "started_at": started,
            "expected_benchmark_count": expected,
        }
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


def record_benchmark_result(execution_id: int, entry: dict) -> int:
    """Insert a child benchmark result row linked to an execution.

    Returns the child row ID (benchmark_runs.id).
    Entry dict must contain: benchmark, timestamp, versions, languages.

    SQLite insert is committed first; then JSON is atomically updated.
    JSON failure does NOT roll back SQLite.
    """
    conn = sqlite3.connect(str(DB_PATH))
    conn.execute("PRAGMA foreign_keys = ON")
    ensure_benchmark_schema(conn)

    benchmark = entry["benchmark"]
    timestamp = entry["timestamp"]
    versions_json = json.dumps(entry.get("versions", {}), ensure_ascii=False)

    try:
        cur = conn.cursor()
        cur.execute(
            """INSERT INTO benchmark_runs
               (benchmark, timestamp, versions_json, execution_id)
               VALUES (?, ?, ?, ?)""",
            (benchmark, timestamp, versions_json, execution_id),
        )
        run_id = cur.lastrowid

        for lang in entry.get("languages", []):
            cur.execute(
                """INSERT INTO benchmark_run_results
                   (run_id, language, avg_ms, ok, results_json)
                   VALUES (?, ?, ?, ?, ?)""",
                (
                    run_id,
                    lang["language"],
                    lang.get("avg_ms"),
                    int(lang.get("ok", False)),
                    json.dumps(lang.get("results", []), ensure_ascii=False),
                ),
            )

        # Update parent completed count
        cur.execute(
            """UPDATE benchmark_executions
               SET completed_benchmark_count = (
                   SELECT COUNT(DISTINCT benchmark)
                   FROM benchmark_runs
                   WHERE execution_id = ?
               )
               WHERE id = ?""",
            (execution_id, execution_id),
        )

        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()

    # ── JSON update (post-commit, best-effort) ──
    try:
        fd = _acquire_json_lock()
        try:
            data = _load_json()
            # Annotate entry with execution metadata for JSON portability
            json_entry = dict(entry)
            json_entry["execution_id"] = execution_id
            # Fetch run_number and version_tag from parent
            conn2 = sqlite3.connect(str(DB_PATH))
            conn2.row_factory = sqlite3.Row
            cur2 = conn2.cursor()
            cur2.execute(
                "SELECT run_number, version_tag FROM benchmark_executions WHERE id = ?",
                (execution_id,),
            )
            row = cur2.fetchone()
            if row:
                json_entry["run_number"] = row["run_number"]
                json_entry["version_tag"] = row["version_tag"]
            conn2.close()

            data.append(json_entry)
            _save_json_atomic(data)
        finally:
            _release_json_lock(fd)
    except Exception as e:
        print(f"[benchmark_storage] JSON write error (DB committed): {e}")

    return run_id


def finalize_execution(execution_id: int, error: str | None = None) -> dict:
    """Finalise an execution: compute status and set finished_at.

    Returns the updated execution dict.
    """
    conn = sqlite3.connect(str(DB_PATH))
    conn.execute("PRAGMA foreign_keys = ON")
    conn.row_factory = sqlite3.Row

    try:
        cur = conn.cursor()
        cur.execute(
            "SELECT * FROM benchmark_executions WHERE id = ?",
            (execution_id,),
        )
        row = cur.fetchone()
        if not row:
            conn.close()
            raise ValueError(f"Execution {execution_id} not found")

        expected = row["expected_benchmark_count"]
        completed = row["completed_benchmark_count"]
        finished = datetime.now(timezone.utc).astimezone().isoformat()

        if completed == 0:
            status = "failed"
        elif completed >= expected:
            status = "completed"
        else:
            status = "partial"

        cur.execute(
            """UPDATE benchmark_executions
               SET status = ?, finished_at = ?, error_message = ?
               WHERE id = ?""",
            (status, finished, error, execution_id),
        )
        conn.commit()

        return {
            "id": execution_id,
            "version_tag": row["version_tag"],
            "run_number": row["run_number"],
            "status": status,
            "started_at": row["started_at"],
            "finished_at": finished,
            "expected_benchmark_count": expected,
            "completed_benchmark_count": completed,
            "error_message": error,
        }
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


def get_execution(execution_id: int) -> dict | None:
    """Return a single execution dict or None."""
    conn = sqlite3.connect(str(DB_PATH))
    conn.row_factory = sqlite3.Row
    try:
        cur = conn.cursor()
        cur.execute(
            "SELECT * FROM benchmark_executions WHERE id = ?",
            (execution_id,),
        )
        row = cur.fetchone()
        if not row:
            return None
        return dict(row)
    finally:
        conn.close()


def list_tag_summaries() -> list[dict]:
    """Return summary for every version_tag that has executions.

    Includes status breakdown (completed/partial/failed/running) and
    legacy child count (execution_id IS NULL) for reference.
    """
    conn = sqlite3.connect(str(DB_PATH))
    conn.execute("PRAGMA foreign_keys = ON")
    conn.row_factory = sqlite3.Row
    try:
        cur = conn.cursor()

        # Count executions per tag with status breakdown
        cur.execute("""
            SELECT version_tag,
                   COUNT(*)                        AS attempt_count,
                   SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS completed_count,
                   SUM(CASE WHEN status = 'partial' THEN 1 ELSE 0 END)   AS partial_count,
                   SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END)    AS failed_count,
                   SUM(CASE WHEN status = 'running' THEN 1 ELSE 0 END)   AS running_count,
                   MAX(id)                         AS latest_execution_id
            FROM benchmark_executions
            GROUP BY version_tag
            ORDER BY version_tag DESC
        """)
        exec_rows = cur.fetchall()

        # Count legacy child rows per tag (version parsed from versions_json)
        cur.execute("""
            SELECT versions_json
            FROM benchmark_runs
            WHERE execution_id IS NULL
        """)
        legacy_by_tag = {}
        for row in cur.fetchall():
            try:
                versions = json.loads(row["versions_json"] or "{}")
                raw = versions.get("hudhud", "")
                tag = normalize_version_tag(raw) if raw else None
                if tag:
                    legacy_by_tag[tag] = legacy_by_tag.get(tag, 0) + 1
            except Exception:
                pass

        summaries = []
        for row in exec_rows:
            tag = row["version_tag"]
            summaries.append({
                "version_tag": tag,
                "attempt_count": row["attempt_count"],
                "completed_count": row["completed_count"],
                "partial_count": row["partial_count"],
                "failed_count": row["failed_count"],
                "running_count": row["running_count"],
                "latest_execution_id": row["latest_execution_id"],
                "legacy_result_count": legacy_by_tag.get(tag, 0),
            })
        return summaries
    finally:
        conn.close()


def list_executions(version_tag: str) -> list[dict]:
    """Return all executions for a tag, newest first."""
    conn = sqlite3.connect(str(DB_PATH))
    conn.row_factory = sqlite3.Row
    try:
        tag = normalize_version_tag(version_tag)
        cur = conn.cursor()
        cur.execute(
            """SELECT * FROM benchmark_executions
               WHERE version_tag = ?
               ORDER BY run_number DESC""",
            (tag,),
        )
        return [dict(row) for row in cur.fetchall()]
    except ValueError:
        return []
    finally:
        conn.close()


def load_results(
    execution_id: int | None = None,
    version_tag: str | None = None,
) -> list[dict]:
    """Load benchmark results, merging SQLite with JSON.

    - execution_id set → only results for that execution.
    - version_tag set + execution_id None → all results for that tag (legacy + executions).
    - Both None → all results.
    """
    # ── Load from JSON ──
    json_results = []
    try:
        if RESULTS_FILE.exists():
            with open(RESULTS_FILE, encoding="utf-8") as f:
                json_results = json.load(f)
    except Exception:
        pass

    # ── Build SQLite merged results ──
    conn = sqlite3.connect(str(DB_PATH))
    conn.execute("PRAGMA foreign_keys = ON")
    conn.row_factory = sqlite3.Row

    seen = set()
    all_results = []

    def _add_result(entry: dict):
        key = (entry.get("execution_id"), entry.get("benchmark"), entry.get("timestamp"))
        if key in seen:
            return
        seen.add(key)
        all_results.append(entry)

    # First pass: JSON entries
    for e in json_results:
        eid = e.get("execution_id")
        ver = e.get("version_tag", "")

        # Filter
        if execution_id is not None and eid != execution_id:
            continue
        if version_tag is not None and execution_id is None:
            if ver != version_tag:
                continue

        _add_result(e)

    # Second pass: SQLite entries not already in JSON
    try:
        cur = conn.cursor()
        sql = "SELECT id, benchmark, timestamp, versions_json, execution_id FROM benchmark_runs ORDER BY timestamp"
        cur.execute(sql)
        rows = cur.fetchall()

        for row in rows:
            # Build dedupe key
            eid = row["execution_id"]
            bm = row["benchmark"]
            ts = row["timestamp"]
            json_key = (eid, bm, ts)
            if json_key in seen:
                continue

            # Version filter (parse from versions_json)
            raw_ver = ""
            try:
                versions = json.loads(row["versions_json"] or "{}")
                raw_ver = versions.get("hudhud", "")
            except Exception:
                pass
            ver = normalize_version_tag(raw_ver) if raw_ver else ""

            # Filters
            if execution_id is not None and eid != execution_id:
                continue
            if version_tag is not None and execution_id is None:
                if ver != version_tag:
                    continue

            # Fetch language results
            cur2 = conn.cursor()
            cur2.execute(
                "SELECT language, avg_ms, ok, results_json FROM benchmark_run_results WHERE run_id = ?",
                (row["id"],),
            )
            lang_rows = cur2.fetchall()
            languages = []
            for lr in lang_rows:
                languages.append({
                    "language": lr["language"],
                    "avg_ms": lr["avg_ms"],
                    "ok": bool(lr["ok"]),
                    "results": json.loads(lr["results_json"]) if lr["results_json"] else [],
                })

            entry = {
                "timestamp": ts,
                "benchmark": bm,
                "versions": json.loads(row["versions_json"]) if row["versions_json"] else {},
                "languages": languages,
                "execution_id": eid,
                "version_tag": ver,
            }

            # If part of an execution, annotate with parent metadata
            if eid:
                cur3 = conn.cursor()
                cur3.execute(
                    "SELECT run_number, status FROM benchmark_executions WHERE id = ?",
                    (eid,),
                )
                erow = cur3.fetchone()
                if erow:
                    entry["run_number"] = erow["run_number"]
                    entry["execution_status"] = erow["status"]

            _add_result(entry)
    except Exception as e:
        print(f"[benchmark_storage] SQLite load error: {e}")

    conn.close()
    return all_results


def delete_execution(execution_id: int) -> bool:
    """Delete a parent execution and all child rows (CASCADE handles children).

    Also removes JSON entries with matching execution_id.
    Does NOT decrement tag_counter (run numbers are permanent).
    """
    # ── SQLite delete ──
    conn = sqlite3.connect(str(DB_PATH))
    conn.execute("PRAGMA foreign_keys = ON")
    try:
        cur = conn.cursor()
        cur.execute("DELETE FROM benchmark_executions WHERE id = ?", (execution_id,))
        conn.commit()
        deleted = cur.rowcount > 0
    except Exception:
        conn.rollback()
        deleted = False
    finally:
        conn.close()

    # ── JSON delete ──
    if deleted:
        try:
            fd = _acquire_json_lock()
            try:
                data = _load_json()
                data = [e for e in data if e.get("execution_id") != execution_id]
                _save_json_atomic(data)
            finally:
                _release_json_lock(fd)
        except Exception as e:
            print(f"[benchmark_storage] JSON delete error (DB deleted): {e}")

    return deleted


# ── Convenience helpers ──────────────────────────────────────────

def get_version_tag_from_versions(entry: dict) -> str:
    """Extract and normalise version_tag from a legacy entry's versions dict."""
    raw = (entry.get("versions") or {}).get("hudhud", "")
    if not raw:
        return ""
    try:
        return normalize_version_tag(raw)
    except ValueError:
        return ""
