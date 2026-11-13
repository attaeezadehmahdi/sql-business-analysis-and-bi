# SQL Business Analysis and BI

## Overview

This project focuses on business analysis and reporting using SQL Server and Power BI. It explores customer and product performance through exploratory data analysis, analytical SQL queries, and reporting views.

The project builds on the Gold layer developed in the following data warehouse project:

**Source Data Warehouse:** [SQL Data Warehouse Project](https://github.com/attaeezadehmahdi/sql-data-warehouse-project)

## Project Objectives

- Explore and understand the available business data.
- Analyze sales trends and business performance.
- Evaluate customer and product performance.
- Develop reusable SQL reporting views.
- Build interactive Power BI dashboards.

## Data Source

The analysis uses the Gold layer of the SQL Data Warehouse project, consisting of:

| Table | Description |
|---|---|
| `gold.dim_customers` | Customer information and attributes |
| `gold.dim_products` | Product information and categories |
| `gold.fact_sales` | Sales transaction records |

Raw datasets and the ETL process are documented in the source data warehouse repository.

## Repository Structure

```text
sql-business-analysis-and-bi/
│
├── data/
│   └── README.md
│
├── sql/
│   ├── eda/
│   ├── analysis/
│   └── reports/
│
├── powerbi/
│
├── reports/
│   └── screenshots/
│
└── README.md
```

## SQL Analysis

### 1. Exploratory Data Analysis (EDA)

- Database exploration
- Date exploration
- Measures exploration
- Magnitude analysis
- Ranking analysis

### 2. Analytical Analysis

- Change-over-time analysis
- Cumulative analysis
- Performance analysis
- Part-to-whole analysis

### 3. Reporting Views

- Customer report
- Product report

## Power BI Dashboard

*To be added.*

## Tools and Technologies

- Microsoft SQL Server
- T-SQL
- Power BI

## Related Project

[SQL Data Warehouse Project](https://github.com/attaeezadehmahdi/sql-data-warehouse-project)
