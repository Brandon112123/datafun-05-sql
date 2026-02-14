-- Aggregate adoptions by animal type

SELECT
  animal_type,
  COUNT(*) AS adoption_count,
  ROUND(SUM(fee), 2) AS total_revenue,
  ROUND(AVG(fee), 2) AS avg_adoption_fee
FROM adoption
GROUP BY animal_type
ORDER BY total_revenue DESC;

