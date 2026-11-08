# E-Commerce Sales Analysis (SQL & Power BI)

**Business Question:** What drove the Q2 revenue decline across 131,000+ e-commerce orders, where are cancellations concentrated, and which categories show the strongest growth potential?

This project combines **MySQL** for data cleaning and validation with a two-page interactive **Power BI** dashboard and stakeholder report analyzing **127,200 cleaned transaction records**.

## Key Findings

- **Revenue Trend:** Total realized revenue reached **₹69.6M**, declining by **20.6%** from ₹25.7M in April to ₹20.4M in June.
- **Category Concentration Risk:** Three product categories generated **91% of total revenue**, and the **Set** category alone accounted for **81% of the overall revenue drop**—making it the top priority for merchandising review.
- **Cancellations & Returns:** Uncompleted orders (cancelled, returned, or refunded) represented **₹8.3M in lost order value**, with clear regional and fulfillment hotspots identified in the dashboard.
- **Growth Pockets:** **Western Dress** grew by **27%** over the same period, and B2B buyers placed higher-value orders with lower cancellation rates than individual consumers.

## Repository Files

| File | Description |
| --- | --- |
| [`dashboard.pbix`](dashboard.pbix) | Two-page interactive Power BI Desktop report with data model and DAX measures. |
| [`dashboard-overview.png`](dashboard-overview.png) | Overview dashboard page showing revenue trends, category mix, and order outcomes. |
| [`dashboard-set-filter.png`](dashboard-set-filter.png) | Drill-down view filtered to the **Set** category. |
| [`stakeholder-report.pdf`](stakeholder-report.pdf) | Five-page executive stakeholder report with methodology, KPI definitions, and recommendations. |
| [`sql/00_source_table.sql`](sql/00_source_table.sql) | MySQL schema definition for the raw semicolon-delimited sales extract. |
| [`sql/01_cleaning.sql`](sql/01_cleaning.sql) | Non-destructive SQL cleaning view handling deduplication and field standardization. |
| [`sql/02_analysis.sql`](sql/02_analysis.sql) | Analytical SQL queries summarizing order statuses, monthly trends, categories, and cancellations. |
| [`sql/cleaning-review.sql`](sql/cleaning-review.sql) | Data quality audit queries verifying primary keys, nulls, and category distributions. |
| [`data-dictionary.md`](data-dictionary.md) | Documentation of source fields, business rules, and cleaned schema definitions. |

![Power BI overview](dashboard-overview.png)

## Reproducing the Analysis

1. Download the [raw dataset sample archive](https://nour2303.github.io/assets/docs/Amazon_Sales_Raw_Data.zip) hosted with the portfolio.
2. Run [`sql/00_source_table.sql`](sql/00_source_table.sql) in MySQL 8 and import the semicolon-delimited CSV into `amazon_sale_report`.
3. Execute [`sql/01_cleaning.sql`](sql/01_cleaning.sql) to create the deduplicated, standardized analytical view, followed by [`sql/02_analysis.sql`](sql/02_analysis.sql) to generate the summary tables.
4. Open [`dashboard.pbix`](dashboard.pbix) in Power BI Desktop to explore the interactive visuals and DAX measures, and refer to [`stakeholder-report.pdf`](stakeholder-report.pdf) for the full executive narrative.
