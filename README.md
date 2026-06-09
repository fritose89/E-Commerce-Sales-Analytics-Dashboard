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

### 5/23
- Made some edits to the sales_overview by removing some of the unnecessary flags preset by the sales_overall view such as IsCancelled
- Added some new columns to the kpi_summary including Average_Units_Per_Order, Missing_CustomerID_Row_Count, and Percent_Missing_CustomerID
- Added an extra flag check to confirm that a customer has an ID when calculating the number of unique customers for the kpi_summary view
- Finished creating sql05 today along with the above edits
- Now sql05 consists of:
  - dashboard_sales_overview: overall fact table for visuals, used to create slicers
  - dashboard_kpi_summary: totals for creating useful KPI cards 
  - dashboard_monthly_sales: monthly sales trends
  - dashboard_geographic_performance: sales for each country and ranking them by revenue and percent of total revenue
  - dashboard_product_performace: product based sales trends and similar ranking to geographic for product revenue and units sold
  - dashboard_customer_performance: customer sales trends similar ranking to the previous two based on customer revenue includes a simple typing column based on following rules:
    - One-Time Customer: when a customer has just ordered once
    - Repeat Customer: when a customer has ordered more than once
    - High-Value Customer: when the revenue generated from a customer is in the 1st percentile
  - dashboard_cancellation_impact: overall revenue effects of cancellations
  - dashboard_data_quality: overview of which data is used where and which data is throw out during the cleaning process

### 5/25
- Made some minor alterations to sql05 by placing the retail_sales_analytics USE clause at the top of the query this allowed for the views to actually populated in the SSMS Object Explorer window. I realized that SQL needs to be instructed to use a specific database explictly

### 5/28
- Began creation of PowerBI dashboard with KPI cards representing:
  - Total Revenue
  - Total Orders
  - Total Units Sold
  - Unique Customers
  - Average Revenue Per Order
- Will be adding a monthly sales line graph and a couple slicers

### 5/31
- Beginning creation of line and bar graphs on dashboard
- I noticed when visualizing the product breakdown that postage, manual, and dotcom postage appear in 3 of the top 10 products sold by revenue so I will be removing them in the visualization in PowerBI and making a note of this in the rules
- Added A line chart displaying the total revenue by month as well as a bar graph for the top 10 products sold
- Will be editing titles and themeing later

### 6/01
- Created a filter in PowerBI to remove the Postage and Manual products from the top 10 products by revenue chart
- Refined titles in KPI cards and charts
- Created top 10 product and country charts on executive page
- Added filters to the top 10 country and product charts to only show the top 10 by revenue rank
- Had to add the top 13 revenue ranks in the product chart due to postage and manuals accounting for 3 of the top 10 positions
- This might be a first draft of the executive page in terms of theming and color choice

### 6/02
- Added column to sql05 dashboard_sales_overview that displays the first day of the month for each sale called Month_Start_Date
- Edited the titles of the pages
- Created basic slicer for Product & Customer Analysis page 2

### 6/04
- Added same Month_Start_Date column from sales_overview to dashboard_monthly_sales
- Edited sql05 customer_type and broke this column into 2
  - Customer_Order_Frequency: categorizes customers into one-time and repeat customers
  - Customer_Value_Type: categorizes customers into high-value and standard customers based on if the revenue generated from that customer is within the top percentile of a decile
- Added four basic slicers for page 2:
  - Month_Start_Date
  - Country
  - Customer_Value_Type
  - Description
- Created 4 DAX queries to allow the slicers to work:
  - Filtered Revenue: Adds revenue column
  - Filtered Orders: Counts number of orders based on distinct values of the InvoiceNo
  - Filtered Units Sold: Adds quantity column
  - Filtered Customers: Counts number of customers and assigns a flag if there is not a CustomerID
- Added KPI cards to display the data filtered by the slicers
- I will be refining this page over the course of the next couple days

### 6/05
- Updated Customer_Value_Type slicer to not list Blank as a filter option, Blank represented the sales that did not include a customerID found in the dashboard_sales_overall view this is mentioned in the title of the slicer
- Fixed format for KPI cards on page 2 by adding currency representations and adjusting the number of decimal places
- Edited titles for slicers
- Changed Date slicer to between to be able to have a higher level of precision
- Added a bar chart representing the top products sold based on the parameters of the slicers

### 6/06
- Added a DAX measure NotProduct to the dashboard_sales_overview view that flags rows if a product description is ("POSTAGE", "MANUAL", "DOTCOM POSTAGE") these are removed from the top products barchart
- Top products bar chart on page 2 is now filtered by the top 10 using description instead of filtering out the POSTAGE MANUAL and DOTCOM POSTAGE by themselves
- Created title for barchart now Top 10 Products by Revenue working as it should
- Added another page for cancellation impact after the product and customer analysis page
- Created bar chart on page 2 for top 10 customers by revenue that filters using the MissingCustomerID flag
- Added title and data formatting for top 10 customers by revenue

### 6/08
- Updated bar and line charts on page one to have revenue represented as a currency
- Added a line graph of revenue by month that is filtered with the slicers on page 2
- Added a table that displays more details about the top 10 customers filtered in the top 10 customers by revenue bar chart on page 2
- Updated titles of charts on page 2
- Completed page 2
- Started work on page 3 cancellation impact I am going to alter the dashboard_cancellation_impact view in SSMS to pull from the cancelled_sales view instead of the cancelled_sales_summary this will allow for PowerBI to have access to a greater level of detail

