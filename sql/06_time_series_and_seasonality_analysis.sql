-- Seasonal changes over time
SELECT 
	DATE_FORMAT(order_date, "%Y-%m-01") as order_date,
	SUM(sales_amount) as total_sales,
	COUNT(DISTINCT customer_key) as total_customers
FROM fact_sales
WHERE order_date IS NOT NULL 
GROUP BY  DATE_FORMAT(order_date, "%Y-%m-01") 
ORDER BY  DATE_FORMAT(order_date, "%Y-%m-01") ;

-- Seasonal changes over time (different approach)
SELECT 
	YEAR(order_date) as order_year,
	MONTH(order_date) as order_month,
	SUM(sales_amount) as total_sales,
	COUNT(DISTINCT customer_key) as total_customers
FROM fact_sales
WHERE order_date IS NOT NULL 
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);