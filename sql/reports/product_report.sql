
/*
===============================================================================
Product Report
===============================================================================
Purpose:
    Create a product-level report containing sales performance metrics,
    product segmentation, and purchasing KPIs.

Data Sources:
    - gold.fact_sales
    - gold.dim_products

Key Transformations:
    - Integrate sales transactions with product information.
    - Aggregate sales metrics at the product level.
    - Calculate product lifespan and performance segments.
    - Calculate recency, average sales per order, and monthly sales.

Output:
    gold.product_report
===============================================================================
*/

CREATE OR ALTER VIEW gold.product_report AS

-- 1. Retrieve base data from sales and product tables
WITH base_query AS (
    SELECT
        s.order_number,
        s.product_key,
        s.sales_amount,
        s.quantity,
        s.order_date,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON s.product_key = p.product_key
),

-- 2. Aggregate sales metrics at the product level
product_aggregation AS (
    SELECT
        product_key,
        product_name,
        subcategory,
        category,
        cost,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT order_number) AS total_order,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order
    FROM base_query
    GROUP BY
        product_key,
        product_name,
        subcategory,
        category,
        cost
),

-- 3. Calculate product lifespan and performance segment
final_result AS (
    SELECT
        product_key,
        product_name,
        subcategory,
        category,
        cost,
        total_sales,
        total_quantity,
        total_order,
        first_order,
        last_order,
        DATEDIFF(MONTH, first_order, last_order) AS lifespan,

        CASE
            WHEN total_sales > 50000 THEN 'High Performance'
            WHEN total_sales >= 10000 THEN 'Medium Performance'
            ELSE 'Low Performance'
        END AS product_segment

    FROM product_aggregation
)

-- 4. Calculate additional product KPIs
SELECT
    product_key,
    product_name,
    subcategory,
    category,
    cost,
    total_sales,
    total_quantity,
    total_order,
    last_order,
    lifespan,
    product_segment,

    -- Recency: months since the last order
    DATEDIFF(MONTH, last_order, '2014-05-01') AS recency_metric,

    -- Average sales per order
    total_sales / NULLIF(total_order, 0) AS average_sales_per_order,

    -- Average monthly sales over the product lifespan
    total_sales / NULLIF(lifespan, 0) AS monthly_sales

FROM final_result;
