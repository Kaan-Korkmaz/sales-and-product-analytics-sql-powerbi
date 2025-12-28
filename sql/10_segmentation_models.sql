-- Data Segmentation 
-- Segmenting product into cost ranges and counting how many product fall into each segment 

WITH product_segment_cost as  (
SELECT
 product_key, product_name, cost,
 CASE 
	WHEN cost < 100 THEN "Below 100"
	WHEN  cost BETWEEN 100 AND 500 THEN "100-500"
    WHEN  cost BETWEEN 500 AND 1000 THEN "500-1000"
    ELSE "Above 1000" 
END cost_range
FROM dim_products  ) 

SELECT 
cost_range ,
COUNT(product_key) as total_product
FROM product_segment_cost
GROUP BY cost_range
ORDER BY total_product DESC;

-- Grouping the customers based on their spending behaviour 
-- VIP :Customers with at least 12 months of history and spending more then 5000
-- Regular : Customers with at least 12 months of history but spending 5000 or less 
-- New : Customers with a lifespan less then 12 months.
WITH customer_spending as(
SELECT 
c.customer_key,
SUM(f.sales_amount) as total_spending ,
MIN(order_date) as first_order,
MAX(order_date) as last_order,
TIMESTAMPDIFF(month, MIN(order_date), MAX(order_date)) as lifespan 
FROM fact_sales as f
LEFT JOIN dim_customers as c
ON f.customer_key= c.customer_key
GROUP BY c.customer_key )

SELECT 
customer_status,
COUNT(customer_key) as total_customers
FROM (
	SELECT 
    customer_key,
	CASE 
		WHEN lifespan >= 12 AND total_spending > 5000 THEN "VIP"
		WHEN lifespan >= 12 AND total_spending <= 5000 THEN "Regular"
		ELSE "New"
	END as customer_status
	FROM customer_spending ) as subquery
GROUP BY customer_status
ORDER BY total_customers DESC;
