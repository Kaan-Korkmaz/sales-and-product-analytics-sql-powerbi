-- Finding the 10 top customer who generate the highest revenue 
SELECT first_name, last_name, country, SUM(f.sales_amount) as total_revenue
FROM fact_sales as f
LEFT JOIN dim_customers as c
ON f.customer_key = c.customer_key
GROUP BY  first_name, last_name, country
ORDER BY total_revenue DESC
LIMIT 10 ;

-- Finding the 5 top customer who generate the fewest orders 

SELECT c.customer_key, first_name ,  last_name,  COUNT( DISTINCT order_number) as total_orders
FROM fact_sales as f
LEFT JOIN dim_customers as c
ON f.customer_key = c.customer_key
GROUP BY customer_key, first_name, last_name 
ORDER BY total_orders ASC
LIMIT 5 ;