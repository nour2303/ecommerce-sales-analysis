-- MySQL 8. Non-destructive cleaning view over amazon_sale_report.
-- Based on the supplied exploratory SQL notes. Review its rules before reuse.
-- Exact duplicate candidates exclude the export index and empty export column.
-- Blank amount/currency/courier fields stay NULL; no status is inferred.

CREATE OR REPLACE VIEW amazon_sale_clean AS
SELECT
  ranked.`index` AS source_index,
  NULLIF(TRIM(ranked.`Order ID`), '') AS order_id,
  STR_TO_DATE(NULLIF(TRIM(ranked.`Date`), ''), '%m-%d-%y') AS order_date,
  NULLIF(TRIM(ranked.`Status`), '') AS status,
  NULLIF(TRIM(ranked.`Courier Status`), '') AS courier_status,
  CASE
    WHEN TRIM(ranked.`Qty`) REGEXP '^[0-9]+$'
    THEN CAST(TRIM(ranked.`Qty`) AS UNSIGNED)
    ELSE NULL
  END AS qty,
  NULLIF(UPPER(TRIM(ranked.`currency`)), '') AS currency,
  CASE
    WHEN TRIM(ranked.`Amount`) REGEXP '^-?[0-9]+([.][0-9]+)?$'
    THEN CAST(TRIM(ranked.`Amount`) AS DECIMAL(18,2))
    ELSE NULL
  END AS amount,
  NULLIF(TRIM(ranked.`Category`), '') AS category,
  NULLIF(TRIM(ranked.`SKU`), '') AS sku,
  NULLIF(UPPER(TRIM(TRAILING '.' FROM TRIM(ranked.`ship-city`))), '') AS ship_city,
  CASE UPPER(TRIM(ranked.`ship-state`))
    WHEN 'RJ' THEN 'RAJASTHAN'
    WHEN 'PONDICHERRY' THEN 'PUDUCHERRY'
    WHEN 'PUNJAB/MOHALI/ZIRAKPUR' THEN 'PUNJAB'
    WHEN 'NEW DELHI' THEN 'DELHI'
    WHEN 'ORISSA' THEN 'ODISHA'
    WHEN 'AR' THEN 'ARUNACHAL PRADESH'
    WHEN 'NL' THEN 'NAGALAND'
    WHEN 'PB' THEN 'PUNJAB'
    WHEN 'DADRA AND NAGAR' THEN 'DADRA AND NAGAR HAVELI'
    ELSE NULLIF(UPPER(TRIM(ranked.`ship-state`)), '')
  END AS ship_state,
  NULLIF(TRIM(ranked.`B2B`), '') AS b2b
FROM (
  SELECT raw.*,
    ROW_NUMBER() OVER (
      PARTITION BY `Order ID`, `Date`, `Status`, `Fulfilment`,
        `Sales Channel`, `ship-service-level`, `Style`, `SKU`,
        `Category`, `Size`, `ASIN`, `Courier Status`, `Qty`,
        `currency`, `Amount`, `ship-city`, `ship-state`,
        `ship-postal-code`, `ship-country`, `promotion-ids`,
        `B2B`, `fulfilled-by`
      ORDER BY CAST(`index` AS UNSIGNED)
    ) AS duplicate_rank
  FROM amazon_sale_report AS raw
) AS ranked
WHERE ranked.duplicate_rank = 1;

-- Review counts and unresolved source values. Do not expect the project PDF's
-- row counts: the linked ZIP is a different-sized source extract.
SELECT
  (SELECT COUNT(*) FROM amazon_sale_report) AS raw_rows,
  (SELECT COUNT(*) FROM amazon_sale_clean) AS rows_after_exact_dedupe;

SELECT
  SUM(order_date IS NULL) AS unparsed_dates,
  SUM(amount IS NULL) AS blank_or_unparsed_amounts,
  SUM(currency IS NULL) AS blank_currencies,
  SUM(courier_status IS NULL) AS blank_courier_statuses
FROM amazon_sale_clean;
