# Data Source and Preparation

## Data Source

This project uses the Gold layer of the SQL Server Data Warehouse developed in the following repository:

[SQL Data Warehouse Project](https://github.com/attaeezadehmahdi/sql-data-warehouse-project)

The warehouse contains the cleaned and transformed business data used for exploratory data analysis, analytical queries, and reporting.

## Database Tables

The analysis uses three tables from the Gold layer:

| Table | Description |
|---|---|
| `gold.dim_customers` | Contains customer information and demographic attributes. |
| `gold.dim_products` | Contains product details, categories, and related attributes. |
| `gold.fact_sales` | Contains sales transactions and associated measures. |

## Database Setup

Before running the SQL scripts in this repository:

1. Set up the SQL Server Data Warehouse by following the instructions in the [source project](https://github.com/attaeezadehmahdi/sql-data-warehouse-project).
2. Execute the warehouse ETL process to populate the Bronze, Silver, and Gold layers.
3. Ensure that the Gold schema and its required tables are available in SQL Server.
4. Connect to the database from SQL Server Management Studio (SSMS).
5. Run the analysis scripts in this repository.

## Notes

- Raw CSV datasets are maintained in the source data warehouse repository.
- This repository does not duplicate the original datasets.
- The SQL analysis scripts depend on the Gold-layer tables being available in SQL Server.
