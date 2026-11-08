-- 01. Exploração do export GA4 (Google Merchandise Store, dados ofuscados)
-- Fonte: bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*
-- Uma linha = um evento; uma tabela por dia (events_YYYYMMDD).

-- 1. Quais eventos existem e quantos de cada
SELECT event_name, COUNT(*) AS total
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201130'
GROUP BY event_name
ORDER BY total DESC;

-- 2. Usuários e eventos por dia
SELECT PARSE_DATE('%Y%m%d', event_date) AS dia,
  COUNT(DISTINCT user_pseudo_id) AS usuarios,
  COUNT(*) AS eventos
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201130'
GROUP BY dia
ORDER BY dia;

-- 3. Páginas mais vistas (UNNEST em event_params)
SELECT
  (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'page_location') AS pagina,
  COUNT(*) AS views
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201130'
  AND event_name = 'page_view'
GROUP BY pagina
ORDER BY views DESC
LIMIT 20;

-- 4. Usuários por dispositivo e país
SELECT device.category AS device, geo.country AS pais,
  COUNT(DISTINCT user_pseudo_id) AS usuarios
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201130'
GROUP BY device, pais
ORDER BY usuarios DESC
LIMIT 20;
