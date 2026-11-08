-- 05. Receita de anúncio estimada por segmento
-- Premissas HIPOTÉTICAS: 2 espaços de anúncio por página, 80% de fill rate,
-- CPM (US$ por mil impressões) diferente por segmento.

WITH cpm AS (
  SELECT 'Compradores' AS segmento, 30.0 AS cpm UNION ALL
  SELECT 'Fãs engajados', 20.0 UNION ALL
  SELECT 'Leitores ocasionais', 10.0 UNION ALL
  SELECT 'Visitantes de passagem', 6.0
)
SELECT s.segmento,
  SUM(s.page_views) AS page_views,
  SUM(s.page_views) * 2 * 0.8 AS impressoes,
  c.cpm,
  ROUND(SUM(s.page_views) * 2 * 0.8 / 1000 * c.cpm, 2) AS receita_estimada
FROM `SEU_PROJETO.plexus_estudo.segmentos` s
JOIN cpm c USING (segmento)
GROUP BY s.segmento, c.cpm
ORDER BY receita_estimada DESC;
