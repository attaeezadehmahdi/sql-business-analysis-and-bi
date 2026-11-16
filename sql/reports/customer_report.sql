
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

-- Creating Cstomer Report
--- 1) retrive data from different source
--- 2) aggregate data (summarization)
--- 3) Segmentation
--- 4) KPI i want to have
-- 1
CREATE OR ALTER VIEW gold.customer_report AS 
WITH base_query AS (
SELECT 
s.order_number,
s.customer_key,
s.order_date,
s.sales_amount,
s.quantity,
CONCAT(c.first_name,' ',c.last_name) AS customer_name,
c.gender,
c.marital_status,
c.country,
DATEDIFF(YEAR,c.birthdate,'2014-02-01') AS age
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
WHERE order_date IS NOT NULL
),
customer_aggregation AS (
SELECT 
	customer_key,
	customer_name,
	gender,
	marital_status,
	age,
	country,
	SUM(Sales_amount) AS total_purchase,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT order_number) AS total_order,
	DATEDIFF(MONTH,MIN(Order_date),MAX(Order_date)) AS lifespan,
	MIN(Order_date) AS first_order,
	MAX(Order_Date) AS recent_order,
	DATEDIFF(MONTH,MAX(Order_Date),'2014-02-01') AS recency
FROM base_query
GROUP BY customer_key,
		customer_name,
		gender,
  		marital_status,
		age,
		country
	), final_result AS(
SELECT 
	customer_key,
	customer_name,
	country,
	gender,
	marital_status,
	age,
	total_purchase,
	total_quantity,
	total_order,
	lifespan,
	first_order,
	recent_order,
	recency,
	CASE 
		WHEN lifespan >= 12 AND total_purchase >= 5000 THEN 'VIP'
		WHEN  lifespan >= 12 AND total_purchase < 5000 THEN 'Regular'
		ELSE 'Low Tenure'
	END customer_segmentation,
	CASE 
		WHEN age IS NULL THEN NULL
		WHEN age < 20 THEN 'Under 20'
		WHEN age between 20 and 29 THEN '20-29'
		WHEN age between 30 and 39 THEN '30-39'
		WHEN age between 40 and 49 THEN '40-49'
		ELSE '50 and Above'
	END customer_age_segment,
	CASE 
		WHEN recency <= 6 THEN 'Active'
		WHEN recency <= 12 THEN 'At Risk'
		ELSE 'Lost'
	END AS customer_status
FROM customer_aggregation
)
SELECT 
	customer_key,
	customer_name,
	country,
	gender,
	marital_status,
	age,
	total_purchase,
	total_quantity,
	total_order,
	lifespan,
	customer_segmentation,
	customer_status,
	customer_age_segment,
	first_order,
	recent_order,
	recency,
	CASE 
		WHEN total_order = 0 THEN 0
		ELSE CAST(total_purchase AS float)/total_order
	END AS average_order_value,
	CASE 
		WHEN lifespan = 0 THEN total_purchase
		ELSE CAST(total_purchase AS float)/ lifespan
	END AS monthly_purchase,
	DENSE_RANK() OVER (
    PARTITION BY country
    ORDER BY total_purchase DESC
) AS customer_rank
FROM final_result
