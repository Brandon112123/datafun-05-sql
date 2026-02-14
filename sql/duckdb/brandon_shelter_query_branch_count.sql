-- sql/duckdb/brandon_shelter_query_branch_count.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Answer a simple structural question:
-- "How many branches do we have in our shelter system?"
--
-- This query does NOT involve the adoption table.
-- It operates only on the independent/parent table.
--
-- WHY:
-- - Establishes the size of the system
-- - Provides context for other KPIs
-- - Helps answer questions like:
--   "Are we expanding by opening new branches,
--    or just increasing adoption volume?"

SELECT
  COUNT(*) AS branch_count
FROM branch;
