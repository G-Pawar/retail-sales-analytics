DROP TABLE IF EXISTS raw_online_retail;
CREATE TABLE raw_online_retail (
    invoice_no TEXT,
    stock_code TEXT,
    description TEXT,
    quantity INTEGER,
    invoice_date TIMESTAMP,
    unit_price NUMERIC(10,2),
    customer_id TEXT,
    country TEXT
)