-- MySQL 8. Run after 01_cleaning.sql.
-- These exploratory summaries describe the linked CSV only. They are not the
-- Power BI measures and do not reproduce the stakeholder report's totals.
-- Amount is an order-line field; do not interpret every amount as realized cash.

-- Status mix and amount completeness.
SELECT
  status,
  COUNT(*) AS line_rows,
  SUM(amount IS NULL) AS rows_without_amount,
  ROUND(SUM(amount), 2) AS recorded_amount
FROM amazon_sale_clean
GROUP BY status
ORDER BY line_rows DESC;

-- Monthly amount for explicitly shipped states. Returned/lost states are
-- excluded; this still is not a validated net-revenue definition.
SELECT
  DATE_FORMAT(order_date, '%Y-%m') AS order_month,
  COUNT(*) AS shipped_line_rows,
  ROUND(SUM(amount), 2) AS shipped_line_amount
FROM amazon_sale_clean
WHERE status IN (
  'Shipped', 'Shipped - Delivered to Buyer',
  'Shipped - Picked Up', 'Shipped - Out for Delivery'
)
  AND order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month;

-- Category mix for the same shipped-state subset.
SELECT
  category,
  COUNT(*) AS shipped_line_rows,
  ROUND(SUM(amount), 2) AS shipped_line_amount
FROM amazon_sale_clean
WHERE status IN (
  'Shipped', 'Shipped - Delivered to Buyer',
  'Shipped - Picked Up', 'Shipped - Out for Delivery'
)
GROUP BY category
ORDER BY shipped_line_amount DESC;

-- Potential order value tied to cancellation or return/loss status. This is
-- not money recovered, and source blanks stay excluded from the sum.
SELECT
  status,
  COUNT(*) AS line_rows,
  ROUND(SUM(amount), 2) AS recorded_amount
FROM amazon_sale_clean
WHERE status IN (
  'Cancelled', 'Shipped - Returned to Seller',
  'Shipped - Returning to Seller', 'Shipped - Rejected by Buyer',
  'Shipped - Lost in Transit'
)
GROUP BY status
ORDER BY line_rows DESC;
