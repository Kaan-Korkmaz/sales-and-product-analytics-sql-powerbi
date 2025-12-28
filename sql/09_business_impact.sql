-- Finding the category that has the greatest impact on overall business


WITH category_sales as (
SELECT 
	category, 
    SUM(sales_amount) as total_sales
FROM fact_sales as f
LEFT JOIN dim_products as p
ON f.product_key = p.product_key
GROUP BY category
 ) 
SELECT 
	category ,
	total_sales,
	SUM(total_sales) OVER() as overall_sales,
	CONCAT ( ROUND((total_sales / SUM(total_sales) OVER() ) * 100 ,2),"%") as percentage_overall_sales
FROM category_sales
ORDER BY total_sales DESC;
