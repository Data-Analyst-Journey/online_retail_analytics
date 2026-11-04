WITH orders AS (
    SELECT * FROM {{ ref('int_orders') }}
),

max_date AS (
    SELECT MAX(invoice_date) + INTERVAL '1 day' AS snapshot_date FROM orders
),

rfm_base AS (
    SELECT
        customer_id,
        country, -- اضافه شد
        MAX(invoice_date) AS last_purchase_date,
        MIN(invoice_date) AS first_purchase_date,
        COUNT(DISTINCT invoice_id) AS frequency,
        SUM(total_price) AS monetary,
        EXTRACT(DAY FROM (SELECT snapshot_date FROM max_date) - MAX(invoice_date)) AS recency
    FROM orders
    GROUP BY customer_id, country -- اضافه شد
)

SELECT
    customer_id,
    country, -- اضافه شد
    first_purchase_date,
    last_purchase_date,
    recency,
    frequency,
    monetary,
    NTILE(4) OVER (ORDER BY recency DESC) AS r_score,
    NTILE(4) OVER (ORDER BY frequency ASC) AS f_score,
    NTILE(4) OVER (ORDER BY monetary ASC) AS m_score,
    CASE 
        WHEN NTILE(4) OVER (ORDER BY recency DESC) >= 3 
         AND NTILE(4) OVER (ORDER BY frequency ASC) >= 3 
         AND NTILE(4) OVER (ORDER BY monetary ASC) >= 3 THEN 'VIP'
        WHEN NTILE(4) OVER (ORDER BY recency DESC) >= 3 
         AND NTILE(4) OVER (ORDER BY frequency ASC) >= 2 THEN 'Loyal'
        WHEN NTILE(4) OVER (ORDER BY recency DESC) <= 2 
         AND NTILE(4) OVER (ORDER BY frequency ASC) >= 2 THEN 'At Risk'
        ELSE 'Lost'
    END AS segment
FROM rfm_base