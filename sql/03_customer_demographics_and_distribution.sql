-- Finding total customers
SELECT COUNT(customer_key) as total_customers
FROM dim_customers;

-- Finding out how many registered customers have placed orders
SELECT COUNT(DISTINCT customer_key) as total_purchased_customers
FROM fact_sales;
--      (This means that all of our registered customers have made at least one purchase.)

-- Creating All The Measurements For The REPORT !!!
SELECT "Total Sales" as measure_name ,SUM(sales_amount) as measured_value FROM fact_sales
UNION ALL
SELECT "Total Quantity", SUM(quantity) as total_sold_product  FROM fact_sales
UNION ALL 
SELECT "Average Price" , AVG(price) as avg_price FROM fact_sales
UNION ALL
SELECT "Total Order", COUNT(DISTINCT order_number) as total_order_unique FROM fact_sales 
UNION ALL 
SELECT "Total Product" ,COUNT(DISTINCT product_key) as total_product FROM dim_products 
UNION ALL 
SELECT "Total Customer", COUNT(customer_key) as total_customers FROM dim_customers;
-- -------------------------------------------------------------------------------------------------------

-- Finding total customer by counteries	
SELECT country,COUNT(customer_key) as total_customers
FROM dim_customers
GROUP BY country
ORDER BY total_customers desc; 


-- Finding total customers by gender
SELECT gender,COUNT(customer_key) as total_customers
FROM dim_customers
GROUP BY gender
ORDER BY total_customers desc; 