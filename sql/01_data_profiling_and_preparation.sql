-- Checking datatypes from our tables
DESCRIBE dim_customers;
DESCRIBE dim_ products;
DESCRIBE fact_sales;
-- IDENTIFY UNIQUE VALUES 
-- Identifying the countries where our customers are located.
SELECT DISTINCT country
FROM dim_customers;

-- Defining our categories
SELECT DISTINCT product_name, category, subcategory
FROM dim_products
ORDER BY 2,3,1 ; 

-- Specifying the data time range. ( Boundries)
-- Finding last and first order to figure how many months sales are available
-- However, since the data type is text, we cannot find a minimum value, so we need to change it to date type.

SELECT (order_date)
FROM fact_sales;

UPDATE fact_sales
SET order_date = NULL
WHERE TRIM(order_date) = '';

ALTER TABLE fact_sales
MODIFY COLUMN order_date DATE;

SELECT MIN(order_date) as first_order_date, 
MAX(order_date) as last_order_date,
TIMESTAMPDIFF(month, MIN(order_date), MAX(order_date)) as order_range_months
FROM fact_sales;


-- Finding oldest and youngest customer 
SELECT (birthdate)
FROM dim_customers;

UPDATE dim_customers
SET birthdate = NULL
WHERE TRIM(birthdate) = '';

ALTER TABLE dim_customers
MODIFY COLUMN birthdate DATE;

SELECT 
MIN(birthdate) as oldest_birthdate,
TIMESTAMPDIFF (year, MIN(birthdate) , CURDATE()) as oldest_age,
MAX(birthdate) as youngest_birthdate,
TIMESTAMPDIFF (year, MAX(birthdate) , CURDATE()) as youngest_age
FROM dim_customers;