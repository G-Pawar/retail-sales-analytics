# Data

This project uses the **Online Retail II** dataset. The raw CSV is **not committed** to this repository (it is ~45MB and exceeds sensible repo size), so download it locally before running the SQL.

---

## Download

**Option A - Kaggle (single combined CSV, easiest)**
1. Go to https://www.kaggle.com/datasets/mashlyn/online-retail-ii-uci
2. Download the dataset (a free Kaggle account is required).
3. Unzip it and place the CSV here:
   ```
   data/raw/online_retail_II.csv
   ```

**Option B - UCI Machine Learning Repository (original source)**
- https://archive.ics.uci.edu/dataset/352/online+retail
- Provided as an Excel workbook; export the sheet(s) to CSV and save to `data/raw/`.

---

## Dataset overview

Transactions from a UK-based, non-store online retailer specialising in all-occasion giftware, **01/12/2009 - 09/12/2011**. Many customers are wholesalers.

- ~1,000,000 rows
- ~5,200 unique products
- ~5,900 unique customers
- 40+ countries

### Schema

| Column | Type | Description |
|---|---|---|
| `Invoice` | text | Invoice number. A `C` prefix indicates a cancellation/return. |
| `StockCode` | text | Product code. |
| `Description` | text | Product name. |
| `Quantity` | integer | Units per line. Negative on cancellations. |
| `InvoiceDate` | timestamp | Date and time of the transaction. |
| `Price` | numeric | Unit price in GBP. |
| `Customer ID` | text | Customer number. May be null. |
| `Country` | text | Customer's country. |

---

## Attribution & licence

This dataset is used under the **Creative Commons Attribution 4.0 International (CC BY 4.0)** licence, which permits sharing and adaptation for any purpose provided appropriate credit is given.

> Chen, D. (2019). *Online Retail II* [Dataset]. UCI Machine Learning Repository. https://doi.org/10.24432/C5BW33

Licence: https://creativecommons.org/licenses/by/4.0/