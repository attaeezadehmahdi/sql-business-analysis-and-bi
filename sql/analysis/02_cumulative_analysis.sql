
/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    Analyze accumulated business performance and moving trends over time.

Key Activities:
    - Calculate monthly running sales totals.
    - Calculate monthly running order totals.
    - Calculate moving averages for sales and orders.
    - Compare yearly cumulative sales and moving averages.
===============================================================================
*/

-- 1. Monthly running totals and moving averages
WITH monthly_metrics AS (
    SELECT
        DATETRUNC(MONTH, order_date) AS [Month],
        SUM(sales_amount) AS [Total Sales],
        COUNT(DISTINCT order_number) AS [Total Orders]
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
)

SELECT
    [Month],
    [Total Sales],

    -- Running total resets at the beginning of each year
    SUM([Total Sales]) OVER (
        PARTITION BY YEAR([Month])
        ORDER BY [Month]
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS [Yearly Running Sales],

    -- Average of the previous four months, excluding the current month
    AVG([Total Sales]) OVER (
        ORDER BY [Month]
        ROWS BETWEEN 4 PRECEDING AND 1 PRECEDING
    ) AS [Sales Moving Average],

    [Total Orders],

    AVG(CAST([Total Orders] AS DECIMAL(18,2))) OVER (
        ORDER BY [Month]
        ROWS BETWEEN 4 PRECEDING AND 1 PRECEDING
    ) AS [Orders Moving Average]

FROM monthly_metrics
ORDER BY [Month];


-- 2. Yearly running total and moving average
WITH yearly_metrics AS (
    SELECT
        YEAR(order_date) AS [Year],
        SUM(sales_amount) AS [Total Sales]
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY YEAR(order_date)
)

SELECT
    [Year],
    [Total Sales],

    SUM([Total Sales]) OVER (
        ORDER BY [Year]
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS [Running Total],

    AVG([Total Sales]) OVER (
        ORDER BY [Year]
        ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
    ) AS [Moving Average]

FROM yearly_metrics
ORDER BY [Year];
