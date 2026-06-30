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

CREATE TABLE IF NOT EXISTS benchmark_runs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    benchmark TEXT NOT NULL,
    timestamp TEXT NOT NULL,
    versions_json TEXT,
    execution_id INTEGER REFERENCES benchmark_executions(id) ON DELETE CASCADE
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

CREATE INDEX IF NOT EXISTS idx_benchmark_executions_tag ON benchmark_executions(version_tag, run_number DESC);
CREATE INDEX IF NOT EXISTS idx_benchmark_executions_started ON benchmark_executions(started_at DESC);
CREATE INDEX IF NOT EXISTS idx_benchmark_runs_execution ON benchmark_runs(execution_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_benchmark_runs_execution_benchmark ON benchmark_runs(execution_id, benchmark) WHERE execution_id IS NOT NULL;
