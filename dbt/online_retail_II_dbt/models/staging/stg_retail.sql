WITH raw_data AS (
    SELECT * FROM {{ source('retail', 'online_retail_raw') }}
)

SELECT
    "Invoice" AS invoice_id,
    "StockCode" AS stock_code,
    "Description" AS description,
    CAST("Quantity" AS INTEGER) AS quantity,
    CAST("InvoiceDate" AS TIMESTAMP) AS invoice_date,
    CAST("Price" AS NUMERIC) AS price,
    CAST("Customer ID" AS INTEGER) AS customer_id,
    "Country" AS country
FROM raw_data
WHERE "Customer ID" IS NOT NULL AND "Quantity">0
AND "Price">0    