# Data Dictionary - Online Retail II

Reference for the raw source table and the data-quality findings that informed cleaning (`sql/02_clean.sql`). Figures below come from profiling the raw load of **1,067,371 rows** (transactions 01/12/2009 – 09/12/2011).

---

## Source table: `raw_online_retail`

| Column | Type | Description | Notes |
|---|---|---|---|
| `invoice_no` | TEXT | Invoice number, one per transaction (multiple rows per invoice). | A `C` prefix marks a cancellation/return. |
| `stock_code` | TEXT | Product identifier. | Some codes are administrative, not products (see below). |
| `description` | TEXT | Product name. | Inconsistent casing; some nulls. Normalised with `INITCAP(TRIM(...))`. |
| `quantity` | INTEGER | Units on the line. | Negative on returns and stock adjustments. |
| `invoice_date` | TIMESTAMP | Date and time of the transaction. | Range 2009-12-01 07:45 → 2011-12-09 12:50. |
| `unit_price` | NUMERIC(10,2) | Unit price in GBP. | Some zero/negative values (adjustment lines). |
| `customer_id` | TEXT | Customer identifier. | Stored with a trailing `.0` in the raw file; ~22.8% null. |
| `country` | TEXT | Customer's country. | 43 distinct values; UK-dominant. |

---

## Dataset scale

| Metric | Value |
|---|---|
| Rows (transaction lines) | 1,067,371 |
| Distinct products | 5,305 |
| Distinct customers | 5,942 |
| Distinct countries | 43 |
| Date range | 2009-12-01 → 2011-12-09 |

---

## Data-quality observations

| Observation | Count | % of rows | Decision |
|---|---|---|---|
| Null customer IDs | 243,007 | 22.8% | **Kept** for revenue analysis; **excluded** from customer-level analysis (RFM, cohorts). Dropping them would understate revenue by ~a fifth. |
| Non-positive quantity | 22,950 | 2.1% | Zero-quantity lines **dropped**; negative-quantity lines **kept** as genuine returns. |
| Non-positive unit price | 6,225 | 0.6% | **Dropped** - these are adjustment/administrative lines, not sales. |
| Cancellation invoices (`C` prefix) | 19,494 | 1.8% | **Kept and flagged** via `is_cancellation`, so returns net off revenue honestly. |
| Duplicate rows | ~34k | 3.2% | **Deduped** with SELECT DISTINCT |

**Note on returns vs cancellations:** negative-quantity lines (22,950) exceed `C`-prefixed cancellation invoices (19,494) by ~3,500. So some negative lines are manual stock adjustments *not* captured by the invoice prefix alone - a reason to reason about returns via `quantity`/`line_revenue` rather than the `C` flag exclusively.

---

## Non-product stock codes

Profiling stock codes that do not begin with a digit surfaced a set of administrative codes mixed in with real products. Meanings are inferred from the codes and their descriptions.

| Code(s) | Inferred meaning | Treatment |
|---|---|---|
| `POST`, `DOT` | Postage / DOTCOM postage | Removed |
| `C2` | Carriage | Removed |
| `M` | Manual adjustment | Removed |
| `D` | Discount | Removed |
| `S` | Samples | Removed |
| `BANK CHARGES` | Bank charges | Removed |
| `ADJUST` | Manual stock adjustment | Removed |
| `AMAZONFEE` | Amazon marketplace fee | Removed |
| `CRUK` | Charity commission (Cancer Research UK) | Removed |
| `TEST001`, `TEST…` | Test transactions | Removed |
| `gift_0001_*` | Gift-voucher sales | **Kept** - real revenue, though non-physical (low volume, ~74 rows) |
| `DCGS*`, `DCGSSGIRL`, `DCGSSBOY`, `PADS` | Genuine products | Kept |

Removal is exact-match on the administrative codes (plus a `TEST` prefix), so real product codes - which are numeric or begin with digits - are unaffected.

---

## Cleaning decisions (`sql/02_clean.sql`)

The raw table lands untouched; `sales_clean` is the analysis-ready fact table. Transformations applied:

- **Flag, don't delete, cancellations** - `is_cancellation` from the `C` prefix; negative `line_revenue` nets returns off gross revenue.
- **Drop non-sales lines** - `unit_price > 0` and `quantity <> 0` remove adjustment and zero-quantity rows.
- **Drop administrative stock codes** - postage, carriage, fees, charges, adjustments and test rows (see table above).
- **Normalise customer IDs** - strip the trailing `.0` and convert blanks to `NULL` so null-handling is explicit.
- **Normalise descriptions** - `INITCAP(TRIM(...))` for consistent casing.
- **Derive fields** - `line_revenue = quantity * unit_price`, and `invoice_day` (date only) for the Power BI date relationship.

All cleaning is done in SQL rather than Power Query, so the transformation logic is version-controlled and reviewable.
