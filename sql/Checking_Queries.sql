
SELECT * FROM dim_customers;

SELECT * FROM fct_orders;

SELECT SUM(total_revenue) FROM fct_orders;

SELECT COUNT(DISTINCT invoice_id) FROM fct_orders;

SELECT
    d.country,
	SUM(f.total_revenue) AS grand_total
FROM dim_customers d JOIN fct_orders f ON d.customer_id = f.customer_id 
GROUP BY d.country
ORDER BY grand_total DESC
LIMIT 10;

SELECT COUNT(DISTINCT customer_id) FROM fct_orders;

WITH total_amt AS (
SELECT 
    SUM(total_revenue) AS grand_total_revenue,
	COUNT(DISTINCT invoice_id) AS total_orders
	FROM fct_orders
)
SELECT 
    grand_total_revenue / total_orders
FROM total_amt;	