-- BUILDING PRODUCT REPORT 
CREATE VIEW report_products AS 
WITH base_query AS (
-- Base Query 
SELECT 
	f.order_number,
    f.order_date,
    f.customer_key,
    f.sales_amount,
    f.quantity,
    p.product_key,
    p.product_name,
    p.category,
    p.subcategory,
    p.cost
FROM fact_sales as f
LEFT JOIN dim_products as p
ON f.product_key = p.product_key 
WHERE order_date IS NOT NULL -- for only considering valid  dates 
),
product_aggregation as(

SELECT 
	product_key,
    product_name,
    category,
    order_date,
    subcategory,
    cost,
    order_date,
    TIMESTAMPDIFF(month, MIN(order_date) , MAX(order_date)) as lifespan,
    MAX(order_date) as last_sale_date,
    MIN(order_date) as first_sale_date,
    COUNT(DISTINCT order_number) as total_orders,
    COUNT(DISTINCT customer_key) as total_customers,
    SUM(sales_amount) as total_sales,
    SUM(quantity) as total_quantity,
    ROUND(SUM(sales_amount) / NULLIF(SUM(quantity), 0), 1) AS avg_selling_price
FROM base_query
GROUP BY product_key,
	product_name,
    category,
    subcategory,
    cost)
    -- Final query
    SELECT 
		product_key, 
        product_name,
		category,
		subcategory,
        order_date,
		cost,
        last_sale_date,
        TIMESTAMPDIFF(month , last_sale_date, CURDATE()) as recency_in_months,
        CASE 
			WHEN total_sales > 50000 THEN "High Performer"
            WHEN total_sales >= 10000 THEN "Mid-Range"
            ELSE "Low Performer"
		END as product_status,
        first_sale_date,
        total_orders,
        total_customers,
        total_sales,
        total_quantity,
        avg_selling_price,
        -- Average Order Revenue 
        CASE 
			WHEN total_orders = 0 THEN 0 
            ELSE total_sales / total_orders
		END as avg_orders_revenue,
		-- Average monthly revenur 
        CASE 
			WHEN total_orders = 0 THEN 0
            ELSE total_sales / lifespan 
		END as avg_monthly_revenue
    FROM product_aggregation;
CREATE OR REPLACE VIEW report_sales_trend AS
SELECT
    f.order_date,
    SUM(f.sales_amount) AS total_sales,
    COUNT(DISTINCT f.order_number) AS total_orders
FROM fact_sales f
WHERE f.order_date IS NOT NULL
GROUP BY f.order_date;