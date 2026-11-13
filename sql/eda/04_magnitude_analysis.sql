
/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    Aggregate business measures across different dimensions to understand
    the distribution and scale of business activities.

Key Activities:
    - Analyze customer distribution by gender and marital status.
    - Examine sales, orders, and customers by country.
    - Analyze sales and product distribution by category.
===============================================================================
*/

-- 1. Number of customers by gender:
--    Compare customers in sales transactions with registered customers.

SELECT
    'Sales' AS [Table],
    c.gender,
    COUNT(DISTINCT f.customer_key) AS Customer_Number
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
GROUP BY c.gender

UNION ALL

SELECT
    'Customer' AS [Table],
    gender,
    COUNT(customer_key) AS Customer_Number
FROM gold.dim_customers
GROUP BY gender

ORDER BY [Table], Customer_Number DESC;


-- 2. Number of customers by marital status
SELECT
    c.marital_status,
    COUNT(DISTINCT f.customer_key) AS Customer_Number
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
GROUP BY c.marital_status
ORDER BY Customer_Number DESC;


-- 3. Customer sales performance:
--    Calculate total orders, total sales, and average sales per order.

SELECT
    customer_key,
    COUNT(order_number) AS [Total Orders],
    SUM(Total_Sales) AS [Total Sales],
    AVG(Total_Sales) AS [Average Sales Per Order]
FROM (
    SELECT
        customer_key,
        order_number,
        SUM(sales_amount) AS Total_Sales
    FROM gold.fact_sales
    GROUP BY customer_key, order_number
) t
GROUP BY customer_key
ORDER BY [Total Sales] DESC;


-- 4. Sales, customers, and orders by country
SELECT
    c.country,
    SUM(f.sales_amount) AS [Total Sales],
    COUNT(DISTINCT f.customer_key) AS [Number of Customers],
    COUNT(DISTINCT f.order_number) AS [Number of Orders],
    SUM(f.sales_amount) /
        NULLIF(COUNT(DISTINCT f.customer_key), 0)
        AS [Average Sales Per Customer]
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY [Total Sales] DESC;


-- 5. Registered customers by country
SELECT
    country,
    COUNT(customer_key) AS Customer_Number
FROM gold.dim_customers
GROUP BY country
ORDER BY Customer_Number DESC;


-- 6. Sales and order performance by product category
SELECT
    p.category,
    COUNT(DISTINCT f.order_number) AS [Order Number],
    SUM(f.sales_amount) AS [Total Sales],
    COUNT(DISTINCT f.product_key) AS [Products Sold]
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY [Total Sales] DESC;


-- 7. Average product cost and product count by category
SELECT
    category,
    AVG(cost) AS [Average Cost],
    COUNT(DISTINCT product_key) AS [Product Number]
FROM gold.dim_products
GROUP BY category
ORDER BY [Average Cost] DESC;
