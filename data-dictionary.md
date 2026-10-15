# Source data dictionary

The original CSV in the [portfolio ZIP](https://nour2303.github.io/assets/docs/Amazon_Sales_Raw_Data.zip) is semicolon-delimited and has 24 headers. These are the fields used to understand the project:

| Source field | Meaning / handling |
| --- | --- |
| `index` | Row index from the export; not an order identifier. |
| `Order ID` | Order reference. One order can have multiple line items. |
| `Date` | Source order date text, formatted as `MM-DD-YY` in the supplied sample. |
| `Status` | Order state used to distinguish completed, cancelled, and returned/lost orders. |
| `Courier Status` | Shipment state; blanks need review before any imputation. |
| `Qty` | Item quantity. A zero value is not automatically an invalid order. |
| `currency` | Transaction currency; source sample uses INR. |
| `Amount` | Line amount stored as text in the imported table; parse before aggregation. |
| `Category`, `SKU`, `ASIN` | Product grouping and identifiers. |
| `ship-state` | Destination state; spelling and abbreviations require normalization. |
| `B2B` | Business-order indicator. |
| `Unnamed: 22` | Empty export column omitted from the cleaned model. |

Blank values, duplicate rows, and status labels should be profiled before removal. The stakeholder report documents the project’s resulting counts and dashboard measures.
