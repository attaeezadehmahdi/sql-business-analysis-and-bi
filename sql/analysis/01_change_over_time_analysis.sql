
/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    Analyze changes in business metrics over time to identify trends,
    patterns, and variations in sales activity.

Key Activities:
    - Aggregate sales, quantity, and orders by month.
    - Examine the number of active sales days per month.
    - Identify the number of months represented in each year.
===============================================================================
*/

-- 1. Analyze monthly sales, quantity, orders, and active sales days
WITH monthly_metrics AS (
    SELECT
        DATETRUNC(MONTH, order_date) AS [Month],
        SUM(sales_amount) AS [Total Sales],
        SUM(quantity) AS [Total Quantity],
        COUNT(DISTINCT order_number) AS [Total Orders],
        COUNT(DISTINCT CAST(order_date AS DATE)) AS [Active Sales Days]
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
)

SELECT
    [Month],
    [Total Sales],
    [Total Quantity],
    [Total Orders],
    [Active Sales Days],
    COUNT(*) OVER (
        PARTITION BY YEAR([Month])
    ) AS [Months in Year]
FROM monthly_metrics
ORDER BY [Month];
