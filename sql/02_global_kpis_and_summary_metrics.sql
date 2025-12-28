-- Finding Total Sales
SELECT SUM(sales_amount) as total_sales 
FROM fact_sales;
-- Finding how many product that are sold 
SELECT SUM(quantity) as total_sold_product 
FROM fact_sales;
-- Finding average price
SELECT AVG(price) as avg_price
FROM fact_sales;
-- Finding number of total order 
SELECT COUNT(order_number) as total_order,
COUNT(DISTINCT order_number) as total_order_unique
FROM fact_sales;

-- Finding total number of product 
SELECT COUNT(DISTINCT product_key) as total_product
FROM dim_products;