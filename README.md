# SQL Data Warehouse Project

A SQL Server-based data warehouse project that ingests raw CRM and ERP source data, standardizes it through a medallion-style pipeline, and exposes curated analytics views for reporting and business analysis.

## Overview

This project demonstrates a practical end-to-end data warehousing workflow using T-SQL. It follows a layered design:

- **Bronze layer:** Raw source tables loaded from CSV files
- **Silver layer:** Cleaned, standardized, and deduplicated data
- **Gold layer:** Star-schema-style dimensional and fact views for analysis

The project models sales, customer, and product data from multiple source systems and presents it in a reporting-friendly structure.

## Objectives

- Consolidate data from CRM and ERP sources into a single warehouse
- Build a repeatable ingestion and transformation pipeline
- Standardize inconsistent values, nulls, and date formats
- Provide a clean analytical layer for reporting
- Demonstrate practical SQL data warehousing patterns

## Architecture

The warehouse is organized into three schemas:

- `bronze`: Raw, source-aligned tables
- `silver`: Curated and business-ready tables
- `gold`: Analytical views, including dimensions and facts

At a high level:

1. Raw CSV files are loaded into the bronze schema.
2. The silver layer applies cleaning, deduplication, and standardization rules.
3. Gold views combine the refined data into customer, product, and sales analytics structures.

## Source Data

The project is built around common CRM and ERP data elements, including:

- Customer information
- Product information
- Sales transactions
- ERP customer metadata
- ERP location metadata
- ERP product category data

Raw source files are expected under the `datasets` directory, including folders such as:

- `datasets/source_crm/`
- `datasets/source_erp/`

## Project Structure

```text
sql-data-warehouse-project/
├── LICENSE
├── README.md
├── datasets/
│   └── ... raw CSV files for CRM and ERP sources
├── docs/
│   └── project documentation placeholders
├── scripts/
│   ├── init_database.sql
│   ├── create_bronze_tables.sql
│   ├── bronze/
│   │   └── proc_load_bronze.sql
│   ├── silver/
│   │   ├── create_silver_tables.sql
│   │   ├── proc_load_silver.sql
│   │   ├── load_silver_table1.sql
│   │   ├── load_silver_table2.sql
│   │   ├── load_silver_table3.sql
│   │   └── load_erp_silver_tables.sql
│   └── gold/
│       ├── load_view_dim_customers.sql
│       ├── load_view_dim_products.sql
│       └── load_view_fact_sales.sql
├── tests/
│   └── placeholder
├── test_broze_table1.sql
├── test_bronze_table2.sql
└── .gitignore
```

## Database Setup

1. Open SQL Server Management Studio (SSMS) or another SQL Server client.
2. Run `scripts/init_database.sql` to create the `DataWarehouse` database and schemas.
3. Run `scripts/create_bronze_tables.sql` to create the raw bronze tables.
4. Update the local file paths in the bulk-insert scripts if your CSV files are stored elsewhere.
5. Execute the bronze load procedure to ingest the raw source data.

## Loading Pipeline

The project uses SQL scripts and stored procedures to move data through the warehouse layers:

- `bronze.load_bronze` loads raw CSV files into the bronze schema.
- `silver.load_silver` performs validation, cleaning, and business transformations.
- Gold views expose dimensional and fact data for analytical queries.

## Gold Layer Outputs

The gold layer includes the following views:

- `gold.dim_customers`
- `gold.dim_products`
- `gold.fact_sales`

These views are designed to support reporting and analytics without exposing raw source artifacts.

## Example Analytics Use Cases

- Sales trend analysis by product and customer
- Customer segmentation and demographic analysis
- Product performance by category and subcategory
- Revenue and quantity analysis over time

## Technologies Used

- Microsoft SQL Server
- Transact-SQL (T-SQL)
- CSV source files
- `BULK INSERT` operations for ingestion

## Getting Started

Run the scripts in the following order:

```sql
-- Create the database and schemas
:r scripts/init_database.sql

-- Create bronze tables
:r scripts/create_bronze_tables.sql

-- Load bronze data
EXEC bronze.load_bronze;

-- Clean and transform data into silver tables
EXEC silver.load_silver;
```

> **Note:** File paths in the bulk-insert scripts may need to be adjusted to match your local environment.

## Notes

This project is intended as a learning and demonstration repository for SQL-based data warehousing patterns. It highlights practical concepts such as:

- Staged ingestion
- Schema separation by data quality
- Data normalization and standardization
- Dimensional modeling
- Business-ready reporting views

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contributing

Contributions, improvements, and enhancements are welcome. Suggestions for better transformation logic, validation checks, or documentation improvements are encouraged.
