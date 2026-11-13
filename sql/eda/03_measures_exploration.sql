
/*
===============================================================================
Measures Exploration
===============================================================================
Purpose:
    Calculate foundational business metrics to understand the overall scale
    and characteristics of the Gold layer data.

Key Activities:
    - Calculate total sales and quantity.
    - Calculate average selling price.
    - Count distinct orders, products, and customers.
    - Compare registered entities with entities appearing in sales.
===============================================================================
*/

-- 1. Calculate key business measures
SELECT
    'Total Sales' AS [Measure Type],
    SUM(sales_amount) AS [Measure Value]
FROM gold.fact_sales

UNION ALL

SELECT
    'Total Quantity',
    SUM(quantity)
FROM gold.fact_sales

UNION ALL

SELECT
    'Average Price',
    AVG(price)
FROM gold.fact_sales

UNION ALL

SELECT
    'Order Number',
    COUNT(DISTINCT order_number)
FROM gold.fact_sales

UNION ALL

SELECT
    'Product Number',
    COUNT(DISTINCT product_key)
FROM gold.dim_products

UNION ALL

SELECT
    'Products in Sales',
    COUNT(DISTINCT product_key)
FROM gold.fact_sales

UNION ALL

SELECT
    'Customer Number',
    COUNT(DISTINCT customer_key)
FROM gold.dim_customers

UNION ALL

SELECT
    'Customers with Sales',
    COUNT(DISTINCT customer_key)
FROM gold.fact_sales;
