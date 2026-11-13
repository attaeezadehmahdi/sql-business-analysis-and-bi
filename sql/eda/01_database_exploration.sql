01. Database Exploration

A. Script description (SQL header)

/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    Explore the Gold layer database structure, including available tables,
    columns, and object metadata.

Key Activities:
    - Identify available tables.
    - Inspect table columns and their data types.
    - Examine table structures using SQL Server system procedures.
===============================================================================
*/
-- 1. Explore available tables
SELECT *
FROM INFORMATION_SCHEMA.TABLES;

-- 2. Explore columns of the customer dimension
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';

-- 3. Explore columns of the product dimension
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products';

-- 4. Explore columns of the sales fact table
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales';

-- 5. Examine detailed customer table information
EXEC sp_help 'gold.dim_customers';
