# E-Commerce-Sales-Analytics-Dashboard

## Project Overview
In this project I am cleaning messy retail e-commerce data and using this data to identify trends and to give relevant business insight. This project is very similar to my work done as a Business Data Analyst for Nawlins Vape LLC.

## Tools
- SQL Server (SSMS 22)
- Power BI
- Excel
- GitHub

## Business Questions
1. What are the main revenue trends?
2. What are the best selling products (Highest Revenue)
3. Which countries generate the most revenue?
4. Who are the highest-value customers?
5. How do cancellations affect bottom line?

## Dataset
UCI Online Retail dataset

## Status Updates
### 5/11 
- Used Excel to change file format of data from .xlsx to .csv for importing into SSMS
- When importing the data into SSMS I set the data types to the nvarchar type to prevent any import problems:
  - InvoiceNo - nvarchar(50)
  - StockCode - nvarchar(50)
  - Description - nvarchar(260)
  - Quantity - nvarchar(50)
  - InvoiceDate - nvarchar(50)
  - UnitPrice - nvarchar(50)
  - CustomerID - nvarchar(50)
  - Country - nvarchar(75)

### 5/12
- Created database schema for SSMS and added creation script
- During data profiling in SSMS I noticed that orders that are cancelled have a negative quantity, meaning negative quantities whose invoice number does not start with 'c' should be processed separately
- When testing converting InvoiceDate, Quantity, and UnitPrice to their proper datatypes as follows:
   - InvoiceDate - datetime2(7)
   - Quantity - int
   - UnitPrice - decimal(12, 2)
  there were no issues to be noted
- There are many rows that are missing customer ids, which will be included in overall trend and sales calculations but will be left out during customer-level analysis
#### Cleaning Rules
- Convert Quantity from NVARCHAR to INT
- Convert InvoiceDate from NVARCHAR to DATETIME2
- Convert UnitPrice from NVARCHAR TO DECIMAL(12, 2)
- Revenue column added by multiplying Quantity and UnitPrice
- Rows where the InvoiceNo begins with C are marked as cancelled
- Cancelled invoices and rows will not be included in any time based or total revenue calculations
- Cancelled invoices will be analyzed separately
- UnitPrices that are zero or less will be excluded from the revenue and sales analysis
- Rows that have negative Quantities that are not cancellations will be analyzed separately
- Missing customer id rows will be analyzed separately from customer-level analysis
- Missing customer id rows will be included in overall analysis

### 5/16
- Moved template of cleaned views to GitHub
- Refined the cleaning query and added greater detail to the comments
- Added new cleaning query and view creation queries to GitHub
- Created views based on the rules above each view is listed as follows:
  - sales_clean: overall clean view with proper data type conversion, removal of nulls, the addition of the flags, and adding a revenue calculation row
  - sales_overall: sales_clean view with additional filtering to remove cancelled sales, negative quantity sales, and negative unit prices
  - cancelled_sales: sales_clean view with cancelled flag set to true
  - customer_level_sales: sales_clean view with no missing customer IDs
  - missingID_sales: sales_clean view with missing customer IDs
  - negative_quant_no_cancel: sales_clean view with that specific flag set
- Removed clean template from GitHub and replaced with refined cleaning query

### 5/17
- Created first draft of business analysis queries based on rules and business questions
- Initial drafts include filtering by country, product, cancelled orders, and customer level sales
- I am still deciding exactly what should be represent by a simple query and what should be represented by a view
- The overall revenue trend query is almost in final draft and includes average revenue per order columns as well

### 5/18
- Began refinement of summarized business metrics in sql04 file
- Removed all GROUP BY statements in order to turn queries into resuable views
- I learned that views are used to encapsualte resuable, pre-filtered datasets that can then be used to do a more detailed analysis
- All previous queries are now turned into the follow summary views:
  - monthly_sales_summary: breaks down sales and other metrics by month
  - geographic_sales_summary: metrics broken down by country
  - product_sales_summary: metrics on product performance
  - customer_level_sales_summary: individualized customer sales metrics
  - cancelled_orders_summary: condensed metrics on just cancelled order processed separately
- Created a finalized version of the sql04 file to show the progress made between the first and final draft
- Renamed the sql04 draft and finalized file to show they are data summaries and not actual analysis queries

### 5/21
- Started creation of PowerBI dashboard views
- Created the following views:
  - dashboard_sales_overview: overall fact table for visuals, used to create slicers
  - dashboard_kpi_summary: totals for creating useful KPI cards 
