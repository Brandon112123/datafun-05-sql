-- sql/duckdb/brandon_shelter_bootstrap.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Creates shelter tables and loads data from CSV files (DuckDB).
--
-- EXPECTED PROJECT PATHS:
--   SQL:  sql/duckdb/brandon_shelter_bootstrap.sql
--   CSV:  data/shelter/branch.csv
--   CSV:  data/shelter/adoption.csv
--   DB:   artifacts/duckdb/brandon_shelter.duckdb
--
--
-- ============================================================
-- STEP 1: CREATE TABLES (PARENT FIRST, THEN CHILD)
-- ============================================================

-- Create parent table
CREATE TABLE IF NOT EXISTS branch (
  branch_id TEXT PRIMARY KEY,
  branch_name TEXT NOT NULL,
  city TEXT NOT NULL,
  system_name TEXT NOT NULL
);

-- Create child table
CREATE TABLE IF NOT EXISTS adoption (
  adoption_id TEXT PRIMARY KEY,
  shelter_id TEXT NOT NULL,
  animal_type TEXT NOT NULL,
  outcome TEXT NOT NULL,
  fee DOUBLE NOT NULL,
  adopt_date DATE NOT NULL
);

--
-- ============================================================
-- STEP 2: LOAD DATA (PARENT FIRST, THEN CHILD)
-- ============================================================

-- Load parent table first
COPY branch
FROM 'data/shelter/branch.csv'
(HEADER, DELIMITER ',', QUOTE '"', ESCAPE '"');

-- Load child table second
COPY adoption
FROM 'data/shelter/adoption.csv'
(HEADER, DELIMITER ',', QUOTE '"', ESCAPE '"');
