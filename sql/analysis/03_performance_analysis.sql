
/*
===============================================================================
Performance Analysis
===============================================================================
Purpose:
    Evaluate product sales performance over time by comparing actual sales
    with historical averages and previous-year performance.

Key Activities:
    - Aggregate annual sales by product.
    - Calculate each product's average annual sales.
    - Compare annual sales with the product's historical average.
    - Compare annual sales with the previous observed year's sales.
    - Classify performance using CASE expressions.
===============================================================================
*/

-- 1. Analyze yearly product performance
WITH yearly_product_sales AS (
    SELECT
        product_key,
        YEAR(order_date) AS [Year],
        SUM(sales_amount) AS [Total Sales]
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY
        product_key,
        YEAR(order_date)
),

product_performance AS (
    SELECT
        product_key,
        [Year],
        [Total Sales],

        AVG([Total Sales]) OVER (
            PARTITION BY product_key
        ) AS [Product Average Sales],

        LAG([Total Sales], 1) OVER (
            PARTITION BY product_key
            ORDER BY [Year]
        ) AS [Previous Year Sales]

    FROM yearly_product_sales
)

SELECT
    p.product_key,
    p.product_name,
    p.category,
    t.[Year],
    t.[Total Sales],
    t.[Product Average Sales],

    t.[Total Sales] - t.[Product Average Sales]
        AS [Difference From Average],

    CASE
        WHEN t.[Total Sales] > t.[Product Average Sales]
            THEN 'Above Average'
        WHEN t.[Total Sales] < t.[Product Average Sales]
            THEN 'Below Average'
        ELSE 'Average'
    END AS [Average Performance],

    t.[Previous Year Sales],

    t.[Total Sales] - t.[Previous Year Sales]
        AS [Difference From Previous Year],

    CASE
        WHEN t.[Previous Year Sales] IS NULL
            THEN 'No Previous Data'
        WHEN t.[Total Sales] > t.[Previous Year Sales]
            THEN 'Increasing'
        WHEN t.[Total Sales] < t.[Previous Year Sales]
            THEN 'Decreasing'
        ELSE 'No Change'
    END AS [Yearly Trend]

FROM product_performance t
LEFT JOIN gold.dim_products p
    ON t.product_key = p.product_key
ORDER BY
    p.product_key,
    t.[Year];
