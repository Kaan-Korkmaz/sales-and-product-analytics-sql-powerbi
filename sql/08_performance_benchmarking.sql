 -- Performance Analysis ( comparing the current value to a target value )
 -- Analyzing the yearly performance of products  by comparing their sales to both the average sales performance of the product and the previous year's sales

WITH yearly_product_sales as (
SELECT
	YEAR(f.order_date) as order_year, 
	p.product_name,
    SUM(f.sales_amount) as current_sales

FROM fact_sales as f
LEFT JOIN dim_products as p
ON f.product_key=p.product_key
WHERE order_date IS NOT NULL 
GROUp BY YEAR(f.order_date), product_name
ORDER BY YEAR(f.order_date) 
)
SELECT 
	order_year,
    product_name,
    current_sales,
    ROUND (AVG(current_sales) OVER( PARTITION BY product_name ) ,1)as avg_sales ,
    current_sales -  ROUND (AVG(current_sales) OVER( PARTITION BY product_name ) ,1) as diff_avg , 
CASE WHEN current_sales -  ROUND (AVG(current_sales) OVER( PARTITION BY product_name ) ,1) > 0 THEN "Above Avg"
	 WHEN current_sales -  ROUND (AVG(current_sales) OVER( PARTITION BY product_name ) ,1) < 0 THEN "Below Avg"
     ELSE "Avg"
END avg_change,
LAG (current_sales) OVER (PARTITION BY product_name ORDER BY order_year) as previous_year_sales,
current_sales - LAG (current_sales) OVER (PARTITION BY product_name ORDER BY order_year) as diff_prev_year,
CASE WHEN current_sales -  LAG (current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN "Increase"
	 WHEN current_sales -  LAG (current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN "Decrease"
     ELSE "No Change"
END prev_year_change
FROM yearly_product_sales 
ORDER BY product_name, order_year;

