GO

CREATE OR ALTER VIEW dbo.dashboard_sales_overview AS
SELECT
	InvoiceNo,
	InvoiceDate,
	YEAR(InvoiceDate) AS Sales_Year,
	MONTH(InvoiceDate) AS Sales_Month,
	CustomerID,
	Country,
	StockCode,
	Description,
	Quantity,
	UnitPrice,
	Revenue,
	IsCancelled,
	NegativeQuantityNotCancelled,
	NullOrMissingID
FROM
	retail_sales_analytics.dbo.sales_overall

GO

CREATE OR ALTER VIEW dbo.dashboard_kpi_summary AS
SELECT
	SUM(Revenue) AS Total_Revenue,
	SUM(Quantity) AS Total_Units_Sold,
	COUNT(DISTINCT InvoiceNo) AS Total_Orders,
	COUNT(DISTINCT CustomerID) AS Unique_Customers,
	SUM(Revenue) / COUNT(DISTINCT InvoiceNo) AS Average_Revenue_Per_Order,
	MIN(InvoiceDate) AS First_Sale_Date,
	MAX(InvoiceDate) AS Last_Sale_Date
FROM
	retail_sales_analytics.dbo.sales_overall

GO
