# Retail Sales Analytics - SQL -> Power BI

An end-to-end analysis of ~1M real UK retail transactions: raw CSV -> PostgreSQL cleaning and modelling -> SQL business analysis -> an interactive Power BI dashboard with insights and recommendations. Built with the lens of someone who has actually reported KPIs to store management.

> **Status: in progress.** The data pipeline (load, profile, clean) is complete; SQL analysis and the Power BI dashboard are next. This README is updated as each phase lands.

---

## Project status

- [x] **Data pipeline** - load raw CSV into PostgreSQL, profile data quality, build a cleaned fact table
- [x] **Data dictionary** - schema, data-quality findings and cleaning decisions
- [ ] SQL analysis - revenue trend, top products, country, RFM segmentation, cohort retention
- [ ] Power BI model - date dimension, star-schema relationships, DAX measures
- [ ] Dashboard - executive overview, product performance, customer insights
- [ ] Insights & recommendations

---

## What's built so far

**Data pipeline (`sql/`)** - the raw file lands untouched in `raw_online_retail`; `sales_clean` is the analysis-ready fact table.

| Script | Purpose |
|---|---|
| `00_schema.sql` | Defines the raw landing table. |
| `01_load.sql` | Loads the CSV via `\copy` (idempotent - truncates before loading). |
| `02_clean.sql` | Builds `sales_clean`: flags cancellations, drops non-sales and administrative rows, normalises customer IDs and descriptions, derives `line_revenue` and `invoice_day`. |
| `03_export.sql` | Exports the cleaned table for import into Power BI. |

**Cleaning highlights (full rationale in the [data dictionary](docs/data_dictionary.md)):**
- Cancellations (`C`-prefixed invoices) are **flagged, not deleted**, so returns net off revenue honestly.
- Administrative stock codes (postage, carriage, fees, adjustments, test rows) are removed; genuine products retained.
- Null customer IDs (~22.8% of rows) are kept for revenue analysis but excluded from customer-level analysis.
- All cleaning is done in SQL, so the transformation logic is version-controlled and reviewable.

---

## Tech stack

| Layer | Tools |
|---|---|
| Database | PostgreSQL |
| Analysis | SQL (window functions, CTEs - *in progress*) |
| Visualisation | Power BI, DAX (*upcoming*) |
| Version control | Git / GitHub |

---

## Repository structure

```
retail-sales-analytics/
├── data/
│   └── README.md          # dataset download instructions + attribution
├── sql/
│   ├── 00_schema.sql      # raw landing table
│   ├── 01_load.sql        # CSV ingest
│   ├── 02_clean.sql       # cleaning, flags, derived fields
│   └── 03_export.sql      # portable extract for Power BI
├── docs/
│   └── data_dictionary.md # schema, data-quality findings, cleaning decisions
├── README.md
├── LICENSE
└── .gitignore
```

---

## Reproduce it

**Prerequisites:** PostgreSQL and a SQL client (psql or DBeaver). Power BI Desktop for the dashboard once that phase lands.

```bash
# 1. Clone
git clone https://github.com/G-Pawar/retail-sales-analytics.git
cd retail-sales-analytics

# 2. Download the dataset into data/raw/ - see data/README.md

# 3. Create the database, then run the pipeline (from psql)
#    \i sql/00_schema.sql
#    \i sql/01_load.sql
#    \i sql/02_clean.sql
#    \i sql/03_export.sql
```

The raw and cleaned CSVs are not committed (they exceed sensible repo size); `03_export.sql` regenerates the cleaned extract locally for Power BI.

---

## Data

**Online Retail II** - transactions from a UK-based, non-store online retailer, 01/12/2009–09/12/2011. ~1,067,000 rows, 5,305 products, 5,942 customers, 43 countries.

> Chen, D. (2019). *Online Retail II* [Dataset]. UCI Machine Learning Repository. https://doi.org/10.24432/C5BW33
> Licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).

---

## Author

**Gurpreet Pawar** - MSci Computer Science. University of Birmingham
[LinkedIn](https://linkedin.com/in/gurpreet811) · [GitHub](https://github.com/G-Pawar)

## Licence

Code released under the [MIT Licence](LICENSE). Dataset under CC BY 4.0 as above.
