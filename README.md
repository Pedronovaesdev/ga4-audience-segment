# GA4 Audience Segments

Segmentação de audiência a partir do export do **Google Analytics 4 no BigQuery**, com estimativa do valor publicitário de cada segmento.

**Dados:** `bigquery-public-data.ga4_obfuscated_sample_ecommerce` (Google Merchandise Store, 01/11/2020 a 31/01/2021).

## Pipeline

```
eventos GA4 (brutos) → sessões → usuários → segmentos → valor publicitário
```

| Etapa | Arquivo |
|---|---|
| Exploração | [`sql/01_exploracao.sql`](sql/01_exploracao.sql) |
| Sessões | [`sql/02_sessoes.sql`](sql/02_sessoes.sql) |
| Usuários | [`sql/03_usuarios.sql`](sql/03_usuarios.sql) |
| Segmentos | [`sql/04_segmentos.sql`](sql/04_segmentos.sql) |
| Valor publicitário | [`sql/05_valor_publicitario.sql`](sql/05_valor_publicitario.sql) |

## Resultados

| Segmento | Usuários | % usuários | Sessões (média) | Min. engajados (média) | Page views | Receita estimada (US$) | % receita |
|---|---:|---:|---:|---:|---:|---:|---:|
| Visitantes de passagem | 167.651 | 62,1% | 1,00 | 0,2 | 241.821 | 2.321,48 | 7,7% |
| Leitores ocasionais | 92.991 | 34,4% | 1,63 | 2,2 | 709.674 | 11.354,78 | 37,7% |
| Fãs engajados | 5.093 | 1,9% | 4,96 | 15,1 | 170.605 | 5.459,36 | 18,1% |
| Compradores | 4.419 | 1,6% | 3,57 | 23,5 | 228.328 | 10.959,74 | 36,4% |

**Principais achados**

- **3,5% dos usuários** (fãs engajados + compradores) geram **29,5% das page views** e **54,6% da receita estimada**.
- **62% dos usuários** são visitantes de passagem (1 sessão, menos de 1 minuto) e geram **7,7% da receita**.
- Um comprador vê em média **52 páginas**; um visitante de passagem, **1,4**.

> A receita usa premissas **hipotéticas**: 2 anúncios por página, 80% de fill rate e CPM de US$ 6 a US$ 30 conforme o segmento. A diferença de page views entre os segmentos independe dessas premissas.

## Boas práticas de custo

- Sem `SELECT *`: o BigQuery é colunar e cobra pelas colunas lidas.
- Filtro por data com `_TABLE_SUFFIX` para ler só os dias necessários.
- Camadas materializadas: as etapas seguintes leem tabelas pequenas, não o dado bruto.

## Como rodar

1. Crie um dataset `plexus_estudo` no local **US**.
2. Troque `SEU_PROJETO` pelo ID do seu projeto.
3. Rode os arquivos em ordem, de `01` a `05`.

**Stack:** BigQuery · SQL · GA4
