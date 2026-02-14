-- sql/duckdb/brandon_shelter_query_adoption_count.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Answer a basic activity question:
-- "How many adoption events have occurred?"
--
-- This query operates on the dependent/child table.
--
-- WHY:
-- - Volume and revenue are different signals
-- - A branch may have many low-fee adoptions
--   or fewer high-fee adoptions
-- - Analysts often start by understanding event counts
--   before analyzing monetary impact

SELECT
  COUNT(*) AS adoption_count
FROM adoption;
