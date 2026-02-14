"""
brandon_duckdb_shelter.py

Author: Brandon
Date: 2026-02

Project: Shelter Analytics Pipeline (DuckDB)

Purpose:
Build, reset, and analyze a 1:M relational shelter database using DuckDB.
This script automates SQL execution and logs the full analytics pipeline.

Project Structure (relative to repo root):
    SQL:  sql/duckdb/*.sql
    CSV:  data/shelter/*.csv
    DB:   artifacts/duckdb/brandon_shelter.duckdb
"""

# ============================================================
# IMPORTS
# ============================================================

import logging
from pathlib import Path
from typing import Final

from datafun_toolkit.logger import get_logger, log_header
import duckdb

# ============================================================
# LOGGER CONFIGURATION
# ============================================================

LOG: logging.Logger = get_logger("P05", level="INFO")


# ============================================================
# GLOBAL CONSTANTS
# ============================================================

ROOT_DIR: Final[Path] = Path.cwd()
SQL_DIR: Final[Path] = ROOT_DIR / "sql" / "duckdb"
ARTIFACTS_DIR: Final[Path] = ROOT_DIR / "artifacts" / "duckdb"
DB_PATH: Final[Path] = ARTIFACTS_DIR / "brandon_shelter.duckdb"


# ============================================================
# HELPER FUNCTIONS
# ============================================================

def read_sql(sql_path: Path) -> str:
    """Read SQL file contents."""
    if not sql_path.exists():
        raise FileNotFoundError(f"Missing SQL file: {sql_path.name}")
    return sql_path.read_text(encoding="utf-8")


def run_sql_script(con: duckdb.DuckDBPyConnection, sql_path: Path) -> None:
    """Execute DDL / COPY / DROP scripts."""
    LOG.info(f"RUN SCRIPT  → {sql_path.name}")
    con.execute(read_sql(sql_path))
    LOG.info(f"DONE SCRIPT → {sql_path.name}")


def run_sql_query(con: duckdb.DuckDBPyConnection, sql_path: Path) -> None:
    """Execute SELECT query and log formatted results."""
    LOG.info("")
    LOG.info(f"RUN QUERY   → {sql_path.name}")

    result = con.execute(read_sql(sql_path))
    rows = result.fetchall()
    columns = [col[0] for col in result.description]

    LOG.info("-" * 50)
    LOG.info(", ".join(columns))
    LOG.info("-" * 50)

    for row in rows:
        LOG.info(", ".join(str(value) for value in row))

    LOG.info("-" * 50)


# ============================================================
# MAIN PIPELINE
# ============================================================

def main() -> None:
    """Execute full shelter analytics pipeline."""
    log_header(LOG, "Shelter Analytics Pipeline (DuckDB)")

    LOG.info(f"ROOT_DIR  → {ROOT_DIR}")
    LOG.info(f"SQL_DIR   → {SQL_DIR}")
    LOG.info(f"DB_PATH   → {DB_PATH}")

    ARTIFACTS_DIR.mkdir(parents=True, exist_ok=True)

    con = duckdb.connect(str(DB_PATH))

    try:
        # ----------------------------------------------------
        # 1. CLEAN DATABASE
        # ----------------------------------------------------
        run_sql_script(con, SQL_DIR / "brandon_shelter_clean.sql")

        # ----------------------------------------------------
        # 2. BOOTSTRAP DATABASE
        # ----------------------------------------------------
        run_sql_script(con, SQL_DIR / "brandon_shelter_bootstrap.sql")

        # ----------------------------------------------------
        # 3. STRUCTURAL METRICS
        # ----------------------------------------------------
        run_sql_query(con, SQL_DIR / "brandon_shelter_query_branch_count.sql")
        run_sql_query(con, SQL_DIR / "brandon_shelter_query_adoption_count.sql")

        # ----------------------------------------------------
        # 4. AGGREGATE ANALYSIS
        # ----------------------------------------------------
        run_sql_query(con, SQL_DIR / "brandon_shelter_query_adoptions_summary.sql")
        run_sql_query(con, SQL_DIR / "brandon_shelter_query_adoptions_by_animal.sql")

        # ----------------------------------------------------
        # 5. KPI METRICS
        # ----------------------------------------------------
        run_sql_query(con, SQL_DIR / "brandon_shelter_query_kpi_adoptions.sql")

    finally:
        con.close()

    LOG.info("PIPELINE COMPLETE ✓")


# ============================================================
# ENTRY POINT
# ============================================================

if __name__ == "__main__":
    main()

