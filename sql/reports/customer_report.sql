
/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    Create a customer-level report containing purchasing behavior,
    customer segmentation, demographic attributes, and purchasing KPIs.

Data Sources:
    - gold.fact_sales
    - gold.dim_customers

Key Transformations:
    - Integrate sales transactions with customer information.
    - Aggregate purchasing metrics at the customer level.
    - Calculate customer age and age segments.
    - Classify customers based on purchasing behavior.
    - Calculate recency, average purchase, and monthly purchase KPIs.
===============================================================================
*/

CREATE OR ALTER VIEW gold.customer_report AS

-- 1. Retrieve base data from sales and customer tables
WITH base_query AS (
    SELECT
        s.order_number,
        s.customer_key,
        s.order_date,
        s.sales_amount,
        s.quantity,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.gender,
        c.marital_status,

        -- Calculate customer age as of the reporting date
        DATEDIFF(YEAR, c.birthdate, '2014-05-01')
        - CASE
            WHEN DATEADD(
                YEAR,
                DATEDIFF(YEAR, c.birthdate, '2014-05-01'),
                c.birthdate
            ) > '2014-05-01' THEN 1
            ELSE 0
          END AS age

    FROM gold.fact_sales s
    LEFT JOIN gold.dim_customers c
        ON s.customer_key = c.customer_key
    WHERE s.order_date IS NOT NULL
),

-- 2. Aggregate purchasing metrics at the customer level
customer_aggregation AS (
    SELECT
        customer_key,
        customer_name,
        gender,
        marital_status,
        age,
        SUM(sales_amount) AS total_purchase,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT order_number) AS total_order,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        MAX(order_date) AS recent_order
    FROM base_query
    GROUP BY
        customer_key,
        customer_name,
        gender,
        marital_status,
        age
),

-- 3. Segment customers based on purchasing behavior
final_result AS (
    SELECT
        customer_key,
        customer_name,
        gender,
        marital_status,
        age,
        total_purchase,
        total_quantity,
        total_order,
        lifespan,
        recent_order,

        CASE
            WHEN lifespan >= 12 AND total_purchase > 5000
                THEN 'VIP'
            WHEN lifespan >= 12 AND total_purchase <= 5000
                THEN 'Regular'
            ELSE 'New'
        END AS customer_segmentation,

        CASE
            WHEN age IS NULL THEN 'Unknown'
            WHEN age < 20 THEN 'Under 20'
            WHEN age BETWEEN 20 AND 29 THEN '20-29'
            WHEN age BETWEEN 30 AND 39 THEN '30-39'
            WHEN age BETWEEN 40 AND 49 THEN '40-49'
            ELSE '50 and Above'
        END AS customer_age_segment

    FROM customer_aggregation
)

-- 4. Calculate additional customer KPIs
SELECT
    customer_key,
    customer_name,
    gender,
    marital_status,
    age,
    total_purchase,
    total_quantity,
    total_order,
    lifespan,
    recent_order,
    customer_segmentation,
    customer_age_segment,

    -- Average purchase per order
    total_purchase / NULLIF(total_order, 0) AS average_purchase,

    -- Average monthly purchase over customer lifespan
    total_purchase / NULLIF(lifespan, 0) AS monthly_purchase,

    -- Recency: months since the most recent purchase
    DATEDIFF(MONTH, recent_order, '2014-05-01') AS recency

FROM final_result;
