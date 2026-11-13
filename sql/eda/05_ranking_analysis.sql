
/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    Identify the highest- and lowest-performing products, subcategories,
    and customers based on selected business metrics.

Key Activities:
    - Identify top-performing products by revenue.
    - Identify lowest-performing products by revenue.
    - Rank product subcategories by revenue.
    - Identify top customers by total sales.
    - Identify customers with the lowest order activity.
===============================================================================
*/

-- 1. Top 5 products by revenue
SELECT TOP (5) WITH TIES
    f.product_key,
    p.product_name,
    p.category,
    SUM(f.sales_amount) AS [Total Sales]
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY
    f.product_key,
    p.product_name,
    p.category
ORDER BY [Total Sales] DESC;


-- 2. Bottom 5 products by revenue
SELECT TOP (5) WITH TIES
    f.product_key,
    p.product_name,
    SUM(f.sales_amount) AS [Total Sales]
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY
    f.product_key,
    p.product_name
ORDER BY [Total Sales] ASC;


-- 3. Top 5 subcategories by revenue
SELECT TOP (5) WITH TIES
    p.subcategory,
    p.category,
    SUM(f.sales_amount) AS [Total Sales]
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY
    p.subcategory,
    p.category
ORDER BY [Total Sales] DESC;


-- 4. Top 5 customers by total sales
SELECT *
FROM (
    SELECT
        c.customer_id,
        c.first_name + ' ' + c.last_name AS [Customer Full Name],
        SUM(f.sales_amount) AS [Total Sales],
        ROW_NUMBER() OVER (
            ORDER BY SUM(f.sales_amount) DESC
        ) AS [Rank]
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
) t
WHERE [Rank] <= 5;


-- 5. Customers with the lowest order activity
SELECT TOP (3) WITH TIES
    c.customer_id,
    c.first_name + ' ' + c.last_name AS [Customer Full Name],
    COUNT(DISTINCT f.order_number) AS [Total Orders]
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY [Total Orders] ASC;
