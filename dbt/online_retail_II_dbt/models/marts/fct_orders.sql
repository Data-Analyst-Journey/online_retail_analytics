SELECT
    invoice_id,
    invoice_date,
    customer_id,
    SUM(quantity) AS total_items,
    SUM(total_price) AS total_revenue
FROM {{ ref('int_orders') }}
GROUP BY invoice_id, invoice_date, customer_id    