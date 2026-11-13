
/*
===============================================================================
Date Exploration
===============================================================================
Purpose:
    Examine date ranges and temporal coverage across the Gold layer.

Key Activities:
    - Identify earliest and latest order dates.
    - Examine shipping and due-date ranges.
    - Explore customer birth-date ranges.
===============================================================================
*/

-- 1. Explore sales transaction date ranges
SELECT
    MIN(order_date) AS [First Order Date],
    MAX(order_date) AS [Last Order Date],
    MIN(shipping_date) AS [First Ship Date],
    MAX(shipping_date) AS [Last Ship Date],
    MIN(due_date) AS [First Due Date],
    MAX(due_date) AS [Last Due Date]
FROM gold.fact_sales;

-- 2. Explore customer birth-date ranges
SELECT
    MIN(birthDate) AS [Min Birth Date],
    MAX(birthDate) AS [Max Birth Date]
FROM gold.dim_customers;

