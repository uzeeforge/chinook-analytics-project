# Chinook Music Store — Sales Analytics Project

A SQL Server + Power BI analysis of the Chinook sample database (a fictional digital music store), built as a data analyst portfolio project.

## Project Overview

This project analyzes sales, customer behavior, and sales rep performance for a fictional digital music store, using SQL Server for data analysis and Power BI for visualization.

**Dataset:** [Chinook Database](https://github.com/lerocha/chinook-database) — 11 tables covering artists, albums, tracks, customers, employees, and invoices.

## Tools Used
- SQL Server / SSMS — data querying and analysis
- Power BI Desktop — dashboard and visualization

## Entity Relationship Diagram

The database has 3 logical modules:
- **Music catalog:** Artist → Album → Track (tagged with Genre and MediaType)
- **People:** Employee → Customer (support rep), Employee → Employee (manager hierarchy)
- **Sales:** Customer → Invoice → InvoiceLine → Track

## Business Questions & Key Findings

| # | Question | Key Finding |
|---|---|---|
| 1 | Which customers spend the most, and how much does the top 20% contribute to revenue? | Top 20% of customers (12 of 59) generate 22.91% of total revenue |
| 2 | How do sales reps compare in revenue generated? | Jane Peacock leads in total revenue ($833.04), but Steve Johnson has the highest revenue-per-customer ($40.01) |
| 3 | How has monthly revenue changed over time? | Mostly flat (~$37.62/month baseline), with a few spikes/dips, no real seasonality |
| 4 | How does customer spend segment, and how much revenue does each tier represent? | 10 "High spenders" (17% of customers) generate 19.38% of revenue |
| 5 | Which countries generate the most revenue? | USA dominates ($523.06, 91 orders); average order value fairly consistent globally (~$5.30–6.70) |

## SQL Concepts Demonstrated
- Multi-table joins (`INNER JOIN`)
- Aggregation (`GROUP BY`, `HAVING`, `COUNT`, `SUM`, `AVG`)
- Common Table Expressions (`WITH ... AS`)
- Window functions (`NTILE`, `RANK`, `LAG`)
- Conditional logic (`CASE WHEN`)
- Subqueries
- Date functions
- Views (for Power BI integration)

## Repository Structure

Chinook-Analytics-Project/
├── sql/
│   ├── 01_setup_verification.sql
│   ├── 02_schema_exploration.sql
│   ├── 03_exploratory_sql.sql
│   ├── 04_business_questions.sql
│   └── 05_create_views.sql
├── dashboard/
│   ├── Chinook_Dashboard.pbix
│   └── dashboard_overview.pdf
└── README.md


## Dashboard Preview

See `dashboard/dashboard_overview.pdf` for the full Power BI dashboard, covering all 5 business questions above.

## Notes
- Chinook's invoice dates are dynamically generated relative to the date the database script is run, so absolute years in the data will differ depending on when it was set up. The relative pattern (flat baseline with occasional spikes) is the meaningful part, not the specific years.