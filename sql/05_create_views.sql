-- Phase 5: Views for Power BI

USE Chinook;
GO

CREATE OR ALTER VIEW vw_CustomerTiers AS
WITH CustomerSpend AS (
    SELECT c.CustomerId,
           c.FirstName + ' ' + c.LastName AS CustomerName,
           SUM(i.Total) AS TotalSpent
    FROM Customer c
    INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
    GROUP BY c.CustomerId, c.FirstName, c.LastName
)
SELECT CustomerId, CustomerName, TotalSpent,
       NTILE(5) OVER (ORDER BY TotalSpent DESC) AS SpendTier
FROM CustomerSpend;
GO

CREATE OR ALTER VIEW vw_SalesRepPerformance AS
SELECT e.EmployeeId,
       e.FirstName + ' ' + e.LastName AS EmployeeName,
       COUNT(DISTINCT c.CustomerId) AS CustomersHandled,
       SUM(i.Total) AS TotalRevenue,
       ROUND(SUM(i.Total) / COUNT(DISTINCT c.CustomerId), 2) AS AvgRevenuePerCustomer,
       RANK() OVER (ORDER BY SUM(i.Total) DESC) AS RevenueRank
FROM Employee e
INNER JOIN Customer c ON e.EmployeeId = c.SupportRepId
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY e.EmployeeId, e.FirstName, e.LastName;
GO

CREATE OR ALTER VIEW vw_MonthlyRevenue AS
WITH Monthly AS (
    SELECT DATEFROMPARTS(YEAR(InvoiceDate), MONTH(InvoiceDate), 1) AS MonthStart,
           SUM(Total) AS Revenue
    FROM Invoice
    GROUP BY DATEFROMPARTS(YEAR(InvoiceDate), MONTH(InvoiceDate), 1)
)
SELECT MonthStart, Revenue,
       LAG(Revenue) OVER (ORDER BY MonthStart) AS PreviousMonthRevenue,
       ROUND((Revenue - LAG(Revenue) OVER (ORDER BY MonthStart)) * 100.0
             / LAG(Revenue) OVER (ORDER BY MonthStart), 2) AS PctChange
FROM Monthly;
GO

CREATE OR ALTER VIEW vw_SpendSegments AS
WITH CustomerSpend AS (
    SELECT CustomerId, SUM(Total) AS TotalSpent
    FROM Invoice
    GROUP BY CustomerId
)
SELECT CASE WHEN TotalSpent < 35 THEN 'Low spender'
            WHEN TotalSpent BETWEEN 35 AND 42 THEN 'Medium spender'
            ELSE 'High spender' END AS SpendSegment,
       COUNT(CustomerId) AS NumCustomers,
       SUM(TotalSpent) AS SegmentRevenue
FROM CustomerSpend
GROUP BY CASE WHEN TotalSpent < 35 THEN 'Low spender'
              WHEN TotalSpent BETWEEN 35 AND 42 THEN 'Medium spender'
              ELSE 'High spender' END;
GO

CREATE OR ALTER VIEW vw_CountryPerformance AS
SELECT BillingCountry,
       COUNT(InvoiceId) AS TotalOrders,
       SUM(Total) AS TotalRevenue,
       ROUND(AVG(Total), 2) AS AvgOrderValue
FROM Invoice
GROUP BY BillingCountry;
GO