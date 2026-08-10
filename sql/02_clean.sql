DROP TABLE IF EXISTS sales_clean;
CREATE TABLE sales_clean AS
SELECT
    invoice_no,
    stock_code,
    INITCAP(TRIM(description))                          AS description,
    quantity,
    invoice_date,
    invoice_date::date                                  AS invoice_day,      -- for the Power BI date link
    unit_price,
    NULLIF(split_part(TRIM(customer_id), '.', 1), '')   AS customer_id,      -- strip trailing .0, empty -> NULL
    country,
    ROUND(quantity * unit_price, 2)                     AS line_revenue,     -- negative on returns (correct)
    (invoice_no LIKE 'C%')                              AS is_cancellation   -- flags, doesn't delete
FROM raw_online_retail
WHERE unit_price > 0                    -- drops free/adjustment lines
  AND quantity <> 0                     -- drops zero-quantity junk
  AND stock_code !~* '^(POST|DOT|M|BANK CHARGES|AMAZONFEE|CRUK)$';  -- non-product codes