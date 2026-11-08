-- 02. Camada de sessões: eventos agrupados por user_pseudo_id + ga_session_id
-- Troque SEU_PROJETO pelo ID do seu projeto no Google Cloud.

CREATE OR REPLACE TABLE `SEU_PROJETO.plexus_estudo.sessoes` AS
WITH ev AS (
  SELECT
    user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS session_id,
    event_name,
    TIMESTAMP_MICROS(event_timestamp) AS ts,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'engagement_time_msec') AS eng_ms,
    device.category AS device,
    geo.country AS country,
    traffic_source.medium AS medium
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
)
SELECT
  user_pseudo_id, session_id,
  MIN(ts) AS inicio, MAX(ts) AS fim,
  COUNTIF(event_name = 'page_view') AS page_views,
  SUM(IFNULL(eng_ms, 0)) / 1000 AS seg_engajados,
  COUNTIF(event_name = 'purchase') > 0 AS comprou,
  ANY_VALUE(device) AS device,
  ANY_VALUE(country) AS country,
  ANY_VALUE(medium) AS medium
FROM ev
WHERE session_id IS NOT NULL
GROUP BY user_pseudo_id, session_id;
