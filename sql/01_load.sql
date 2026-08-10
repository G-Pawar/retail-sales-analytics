SET datestyle To 'ISO, MDY';
\copy raw_online_retail FROM 'data/raw/online_retail_II.csv' WITH (FORMAT CSV, HEADER TRUE);