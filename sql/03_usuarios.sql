-- 03. Camada de usuários: uma linha por usuário, lendo a tabela de sessões
-- (bem menor e mais barata que o dado bruto).

CREATE OR REPLACE TABLE `SEU_PROJETO.plexus_estudo.usuarios` AS
SELECT
  user_pseudo_id,
  COUNT(*) AS sessoes,
  SUM(page_views) AS page_views,
  ROUND(SUM(seg_engajados) / 60, 1) AS min_engajados,
  LOGICAL_OR(comprou) AS comprou,
  APPROX_TOP_COUNT(device, 1)[OFFSET(0)].value AS device,
  ANY_VALUE(country) AS country,
  ANY_VALUE(medium) AS medium,
  MIN(inicio) AS primeira_visita,
  MAX(inicio) AS ultima_visita
FROM `SEU_PROJETO.plexus_estudo.sessoes`
GROUP BY user_pseudo_id;
