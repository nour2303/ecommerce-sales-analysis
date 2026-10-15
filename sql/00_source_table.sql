-- MySQL 8. Run once in a project database before importing the linked CSV.
-- Keep source fields as text so blanks and original labels remain inspectable.
-- Import amazon Big proj.csv with a semicolon delimiter, double-quote text
-- qualifier, UTF-8 encoding, and one header row skipped.

CREATE TABLE IF NOT EXISTS amazon_sale_report (
  `index` TEXT,
  `Order ID` TEXT,
  `Date` TEXT,
  `Status` TEXT,
  `Fulfilment` TEXT,
  `Sales Channel` TEXT,
  `ship-service-level` TEXT,
  `Style` TEXT,
  `SKU` TEXT,
  `Category` TEXT,
  `Size` TEXT,
  `ASIN` TEXT,
  `Courier Status` TEXT,
  `Qty` TEXT,
  `currency` TEXT,
  `Amount` TEXT,
  `ship-city` TEXT,
  `ship-state` TEXT,
  `ship-postal-code` TEXT,
  `ship-country` TEXT,
  `promotion-ids` TEXT,
  `B2B` TEXT,
  `fulfilled-by` TEXT,
  `Unnamed: 22` TEXT
) CHARACTER SET utf8mb4;

-- The linked ZIP's CSV contains 95,264 data rows. Confirm the imported count:
SELECT COUNT(*) AS imported_rows FROM amazon_sale_report;
