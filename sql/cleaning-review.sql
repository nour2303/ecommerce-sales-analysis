-- MySQL 8 review script, curated from exploratory cleaning notes.
-- Import the semicolon-delimited source CSV into amazon_sale_report first.
-- These queries are read-only: inspect each finding before deciding what to change.

SELECT COUNT(*) AS raw_rows FROM amazon_sale_report;

-- Exact duplicate candidates, excluding the export's row index.
WITH ranked AS (
  SELECT `index`, `Order ID`, `Date`, `SKU`,
         ROW_NUMBER() OVER (
           PARTITION BY `Order ID`, `Date`, `Status`, `Fulfilment`,
                        `Sales Channel`, `ship-service-level`, `Style`, `SKU`,
                        `Category`, `Size`, `ASIN`, `Courier Status`, `Qty`,
                        `currency`, `Amount`, `ship-city`, `ship-state`,
                        `ship-postal-code`, `ship-country`, `promotion-ids`,
                        `B2B`, `fulfilled-by`
           ORDER BY `index`
         ) AS duplicate_rank
  FROM amazon_sale_report
)
SELECT COUNT(*) AS duplicate_candidate_rows
FROM ranked WHERE duplicate_rank > 1;

-- Review blanks together; a blank amount can have a different meaning by status.
SELECT `Status`,
       COUNT(*) AS rows,
       SUM(`Amount` IS NULL OR TRIM(`Amount`) = '') AS blank_amount,
       SUM(`currency` IS NULL OR TRIM(`currency`) = '') AS blank_currency,
       SUM(`Courier Status` IS NULL OR TRIM(`Courier Status`) = '') AS blank_courier_status
FROM amazon_sale_report
GROUP BY `Status`
ORDER BY rows DESC;

-- Check date parsing and state-name normalization candidates.
SELECT `Date`, STR_TO_DATE(`Date`, '%m-%d-%y') AS parsed_date
FROM amazon_sale_report
LIMIT 20;

SELECT UPPER(TRIM(`ship-state`)) AS state_label, COUNT(*) AS rows
FROM amazon_sale_report
GROUP BY UPPER(TRIM(`ship-state`))
ORDER BY rows DESC;

-- Do not infer missing courier status solely from a nonzero amount without
-- checking the order state and the intended business definition.
