-- 04. Segmentos de audiência por engajamento

CREATE OR REPLACE TABLE `SEU_PROJETO.plexus_estudo.segmentos` AS
SELECT *,
  CASE
    WHEN comprou THEN 'Compradores'
    WHEN sessoes >= 3 AND min_engajados >= 5 THEN 'Fãs engajados'
    WHEN sessoes = 1 AND page_views <= 2 THEN 'Visitantes de passagem'
    ELSE 'Leitores ocasionais'
  END AS segmento,
  NTILE(4) OVER (ORDER BY min_engajados) AS quartil_engajamento
FROM `SEU_PROJETO.plexus_estudo.usuarios`;

-- Resumo por segmento
SELECT segmento,
  COUNT(*) AS usuarios,
  ROUND(AVG(sessoes), 2) AS media_sessoes,
  ROUND(AVG(min_engajados), 1) AS media_min,
  SUM(page_views) AS page_views,
  ROUND(100 * COUNTIF(device = 'mobile') / COUNT(*), 1) AS pct_mobile
FROM `SEU_PROJETO.plexus_estudo.segmentos`
GROUP BY segmento
ORDER BY usuarios DESC;
