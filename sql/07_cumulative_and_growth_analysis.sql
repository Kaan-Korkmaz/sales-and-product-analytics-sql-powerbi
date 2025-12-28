-- Cumulative Analyzes ( Understanding whether business is growing or declining )
-- Calculating the total sales per month and the running total of sales over time 
 SELECT 
	order_date, 
	total_sales,
    SUM(total_sales) OVER (PARTITION BY YEAR(order_date) ORDER BY order_date) as running_total_sales,
    ROUND(AVG(avg_price) OVER ( ORDER BY order_date) ,1)as moving_average_price
FROM (
	SELECT DATE_FORMAT(order_date, "%Y-%m-01") as order_date,
		   SUM(sales_amount) as total_sales,
		   AVG(price) as avg_price
	FROM fact_sales
	WHERE order_date IS NOT NULL 
	GROUP BY DATE_FORMAT(order_date, "%Y-%m-01")
	ORDER BY DATE_FORMAT(order_date, "%Y-%m-01") ) as subquery;