-- sql/duckdb/brandon_shelter_clean.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Reset the shelter database by removing existing tables.
--
-- Drop child table first (adoption),
-- then parent table (branch).

-- Drop dependent/child table first
DROP TABLE IF EXISTS adoption;

-- Drop independent/parent table second
DROP TABLE IF EXISTS branch;
