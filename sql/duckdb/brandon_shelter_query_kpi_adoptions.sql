-- sql/duckdb/brandon_shelter_query_kpi_revenue.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Calculate a Key Performance Indicator (KPI) for the shelter domain using DuckDB SQL.
--
-- KPI DRIVES THE WORK:
-- In analytics, we do not start with "write a query."
-- We start with a KPI that supports an actionable decision.
--
-- ACTIONABLE OUTCOME:
-- We want to identify which branches are generating the most adoption revenue so we can:
-- - allocate staff during high adoption periods,
-- - increase marketing in high-performing locations,
-- - investigate why low-performing branches are underperforming,
-- - improve outreach efforts where impact is strongest.
--
-- In this example, our KPI is total adoption revenue by branch.
--
-- ANALYST RESPONSIBILITY:
-- Analysts determine how to:
-- - identify needed tables,
-- - join them correctly,
-- - aggregate at the correct level,
-- - and present results clearly for decision-makers.
--
-- ASSUMPTION:
-- We always run all commands from the project root directory.
--
-- EXPECTED PROJECT PATHS:
--   SQL:  sql/duckdb/brandon_shelter_query_kpi_revenue.sql
--   DB:   artifacts/duckdb/brandon_shelter.duckdb
--
--
-- ============================================================
-- TOPIC DOMAIN + 1:M RELATIONSHIP
-- ============================================================
-- OUR DOMAIN: SHELTER
-- Two tables in a 1-to-many relationship:
-- - branch (1): independent/parent table
-- - adoption (M): dependent/child table
--
-- HOW THIS RELATES TO OUR KPI:
-- - branch tells us where the adoption occurred.
-- - adoption contains the measurable activity (fee, animal_type, date).
-- - To compute revenue by branch, we must:
--   1) connect adoption to branch,
--   2) aggregate fees at the branch level.
--
--
-- ============================================================
-- KPI DEFINITION
-- ============================================================
-- KPI NAME: Total Adoption Revenue by Branch
--
-- KPI QUESTION:
-- "How much adoption revenue did each branch generate?"
--
-- MEASURE:
-- - revenue = SUM(adoption.fee)
--
-- GRAIN:
-- - one row per branch
--
--
-- ============================================================
-- EXECUTION
-- ============================================================

SELECT
  b.branch_id,
  b.branch_name,
  b.city,
  b.system_name,
  COUNT(a.adoption_id) AS adoption_count,
  ROUND(SUM(a.fee), 2) AS total_revenue,
  ROUND(AVG(a.fee), 2) AS avg_adoption_fee
FROM branch AS b
JOIN adoption AS a
  ON RIGHT(a.shelter_id, 3) = RIGHT(b.branch_id, 3)
GROUP BY
  b.branch_id,
  b.branch_name,
  b.city,
  b.system_name
ORDER BY total_revenue DESC;
