WITH stg AS (
    SELECT * FROM {{ ref('stg_retail') }}
)
SELECT
    invoice_id,
    stock_code,
    description,
    quantity,
    invoice_date,
    price,
    customer_id,
    country,
    (quantity * price) AS total_price
FROM stg    