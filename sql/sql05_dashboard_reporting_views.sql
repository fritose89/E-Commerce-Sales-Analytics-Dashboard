USE retail_sales_analytics;
GO

CREATE OR ALTER VIEW dbo.dashboard_sales_overview AS
SELECT
	InvoiceNo,
	InvoiceDate,
	YEAR(InvoiceDate) AS Sales_Year,
	MONTH(InvoiceDate) AS Sales_Month,
	DATEFROMPARTS(YEAR(InvoiceDate), MONTH(InvoiceDate), 1) AS Month_Start_Date,
	CustomerID,
	Country,
	StockCode,
	Description,
	Quantity,
	UnitPrice,
	Revenue,
	NullOrMissingID
FROM
	dbo.sales_overall;

GO

CREATE OR ALTER VIEW dbo.dashboard_kpi_summary AS
SELECT
	SUM(Revenue) AS Total_Revenue,
	SUM(Quantity) AS Total_Units_Sold,
	COUNT(DISTINCT InvoiceNo) AS Total_Orders,
	COUNT(DISTINCT CASE WHEN NullOrMissingID = 0 THEN CustomerID END) AS Unique_Customers,
	SUM(Revenue) / COUNT(DISTINCT InvoiceNo) AS Average_Revenue_Per_Order,
	SUM(Quantity) / COUNT(DISTINCT InvoiceNo) AS Average_Units_Per_Order,
	MIN(InvoiceDate) AS First_Sale_Date,
	MAX(InvoiceDate) AS Last_Sale_Date,
	SUM(CASE WHEN NullOrMissingID = 1 THEN 1 ELSE 0 END) AS Missing_CustomerID_Row_Count,
	100.0 * SUM(CASE WHEN NullOrMissingID = 1 THEN 1 ELSE 0 END) / COUNT(*) AS Percent_Missing_CustomerID
FROM
	dbo.sales_overall;

GO

CREATE OR ALTER VIEW dbo.dashboard_monthly_sales AS
SELECT
	Sales_Year,
	Sales_Month,
	DATEFROMPARTS(Sales_Year, Sales_Month, 1) AS Month_Start_Date,
	Total_Monthly_Revenue,
	Total_Units_Sold,
	Total_Orders,
	Avg_Revenue_Per_Order
FROM
	dbo.monthly_sales_summary;

GO

CREATE OR ALTER VIEW dbo.dashboard_geographic_performance AS
SELECT
	Country,
	Total_Revenue,
	Total_Units_Sold,
	Total_Orders,
	Unique_Customers,
	Avg_Revenue_Per_Order,
	Total_Revenue / SUM(Total_Revenue) OVER() AS Revenue_Percent_Of_total,
	RANK() OVER(ORDER BY Total_Revenue DESC) AS Revenue_Rank
FROM
	dbo.geographic_sales_summary;

GO

CREATE OR ALTER VIEW dbo.dashboard_product_performance AS
SELECT
	StockCode,
	Description,
	Total_Revenue,
	Total_Units_Sold,
	Total_Orders,
	Unique_Customers,
	Total_Revenue / Total_Units_Sold AS Avg_Revenue_Per_Unit,
	RANK() OVER(ORDER BY Total_Revenue DESC) AS Product_Revenue_Rank,
	RANK() OVER(ORDER BY Total_Units_Sold DESC) AS Product_Units_Rank
FROM
	dbo.product_sales_summary;

GO

CREATE OR ALTER VIEW dbo.dashboard_customer_performance AS 
SELECT
	CustomerID,
	Total_Revenue,
	Total_Units_Sold,
	Total_Orders,
	First_Order_Date,
	Last_Order_Date,
	Avg_Revenue_Per_Order,
	DATEDIFF(DAY, First_Order_Date, Last_Order_Date) AS Customer_Lifespan_Days,
	RANK() OVER(ORDER BY Total_Revenue DESC) AS Customer_Revenue_Rank,
	CASE
		WHEN Total_Orders = 1 THEN 'One-Time Customer'
		WHEN Total_Orders > 1 THEN 'Repeat Customer'
		WHEN NTILE(10) OVER(ORDER BY Total_Revenue DESC) = 1 THEN 'High-Value Customer'
	END AS Customer_Type
FROM
	dbo.customer_level_sales_summary;

GO

CREATE OR ALTER VIEW dbo.dashboard_cancellation_impact AS 
SELECT
	InvoiceNo,
	CustomerID,
	Country,
	Total_Cancelled_Units,
	Total_Revenue_Lost,
	ABS(Total_Revenue_Lost) AS Revenue_Lost_Positive
FROM
	dbo.cancelled_orders_summary;

GO

CREATE OR ALTER VIEW dbo.dashboard_data_quality_summary AS 
SELECT
	COUNT(*) AS Total_Cleaned_Rows,
	SUM(CASE WHEN IsCancelled = 0 AND NegativeQuantityNotCancelled = 0 AND Quantity > 0 AND UnitPrice > 0 THEN 1 ELSE 0 END) AS Valid_Sales_Rows, --Also the Rows included in revenue
	SUM(CASE WHEN IsCancelled = 1 THEN 1 ELSE 0 END) AS Cancelled_Rows,
	SUM(CASE WHEN NegativeQuantityNotCancelled = 1 THEN 1 ELSE 0 END) AS Negative_Quantity_Not_Cancelled_Rows,
	SUM(CASE WHEN UnitPrice < 0 THEN 1 ELSE 0 END) AS Invalid_UnitPrice_Rows,
	SUM(CASE WHEN IsCancelled = 1 THEN 1 ELSE 0 END) + SUM(CASE WHEN NegativeQuantityNotCancelled = 1 THEN 1 ELSE 0 END) + SUM(CASE WHEN UnitPrice < 0 THEN 1 ELSE 0 END) AS Rows_Excluded_From_Revenue,
	SUM(CASE WHEN NullOrMissingID = 0 THEN 1 ELSE 0 END) AS Rows_Included_In_Customer_Analysis,
	100.0 * SUM(CASE WHEN IsCancelled = 0 AND NegativeQuantityNotCancelled = 0 AND Quantity > 0 AND UnitPrice > 0 THEN 1 ELSE 0 END) / COUNT(*) AS Percent_Valid_Sales,
	100.0 * SUM(CASE WHEN IsCancelled = 1 THEN 1 ELSE 0 END) / COUNT(*) AS Percent_Cancelled,
	100.0 * SUM(CASE WHEN NullOrMissingID = 1 THEN 1 ELSE 0 END) / COUNT(*) AS Percent_Missing_CustomerID

FROM
	dbo.sales_clean;

GO