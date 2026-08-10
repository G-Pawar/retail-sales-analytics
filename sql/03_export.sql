-- 03_export.sql - portable extract so the .pbix opens without a live DB
\copy (SELECT * FROM sales_clean) TO 'powerbi/sales_clean.csv' WITH (FORMAT csv, HEADER true)