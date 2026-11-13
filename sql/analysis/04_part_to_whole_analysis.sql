
/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    Examine the contribution of individual product categories to overall
    business sales.

Key Activities:
    - Aggregate sales by product category.
    - Calculate total sales across all categories.
    - Calculate each category's percentage contribution to total sales.
    - Rank categories by their sales contribution.
===============================================================================
*/

-- 1. Calculate category contribution to total sales
WITH sales_by_category AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS [Category Sales]
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    GROUP BY p.category
)

SELECT
    category,
    [Category Sales],

    SUM([Category Sales]) OVER () AS [Total Sales],

    CAST(
        100.0 * [Category Sales]
        / NULLIF(SUM([Category Sales]) OVER (), 0)
        AS DECIMAL(10,2)
    ) AS [Percentage of Total Sales]

FROM sales_by_category
ORDER BY [Percentage of Total Sales] DESC;
