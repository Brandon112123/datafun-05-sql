-- sql/duckdb/brandon_shelter_query_adoptions_summary.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Summarize overall adoption activity across ALL branches.
--
-- This query answers:
-- - "What is our total adoption revenue?"
-- - "What is the average adoption fee?"
--
-- WHY:
-- - Establishes system-wide performance
-- - Provides a baseline before breaking results down by branch
-- - Helps answer:
--   "Is overall adoption performance strong or weak?"

SELECT
  COUNT(*) AS adoption_count,
  ROUND(SUM(fee), 2) AS total_revenue,
  ROUND(AVG(fee), 2) AS avg_adoption_fee
FROM adoption;
