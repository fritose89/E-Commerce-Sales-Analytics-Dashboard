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

## Dashboard Preview and Screenshots

### Page 1 - Executive Sales Overview
![Executive Sales Overview](dashboard/screenshots/dashboard_page_1_executive_overview.png)

### Page 2 - Product and Customer Analysis
![Product and Customer Analysis](dashboard/screenshots/dashboard_page_2_product_and_customer_analysis.png
)

### Page 3 - Cancellation Impact
![Cancellation Impact](dashboard/screenshots/dashboard_page_3_cancellation_impact.png
)

### Page 4 - Data Quality Summary
![Data Quality Summary](dashboard/screenshots/dashboard_page_4_data_quality_summary.png
)

## Data Cleaning Summary
The raw data set was first brought into Excel to convert the data from .xlsx to .csv and then imported into SSMS 22 for SQL query analysis. All data types were first set to NVARCHAR to prevent any strange importing errors. SQL views were created in order to convert all the columns into the appropriate data types and to group the data into a set of related views. A base cleaned view called sales_clean was created as a template to build the other more specific views.

### Data Cleaning Rules
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
- Removed Postage and Manual from products in product analysis 
- Customers in the top 10% by revenue are considered "High-Value"

## Key Findings
- $10.67M was made from around 20K valid orders as defined above
- Most of the revenue is generated from August through November 2011 which could be indicative of a holiday rush
- Monthly revenue peaked during November 2011 at $1.5M 
- The "Regency Cakestand 3 Tier" generated the most revenue during this period at $175K followed closely by the "Paper Craft, Little Birdie" at $168K
- The United Kingdom generated the most revenue by far at $9M
- Excluding the United Kingdom which is around 90% of all sales, Netherlands generated $285K in revenue
- The top customer by revenue is "14646" generating $280K over 73 orders
- Customers considered "High-Value" account for $5.47M about 50% of all revenue generated
- Cancellations resulted in $897K in lost revenue across 4K orders
- About 24.9% of all sales were missing a CustomerID these rows are not included in customer-level analysis
- Out of around 542K rows of data around 530K rows are considered valid from the cleaning rules
- Greater detailed findings can be found in REPORT.md