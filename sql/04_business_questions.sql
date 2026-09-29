USE Chinook;

-- Q1: Customer value tiers
WITH CustomerSpend AS (
    SELECT c.CustomerId,
           c.FirstName + ' ' + c.LastName AS CustomerName,
           SUM(i.Total) AS TotalSpent
    FROM Customer c
    INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
    GROUP BY c.CustomerId, c.FirstName, c.LastName
),
Tiered AS (
    SELECT CustomerName, TotalSpent,
           NTILE(5) OVER (ORDER BY TotalSpent DESC) AS SpendTier
    FROM CustomerSpend
)
SELECT 
    SUM(CASE WHEN SpendTier = 1 THEN TotalSpent ELSE 0 END) AS Top20PctRevenue,
    SUM(TotalSpent) AS TotalRevenue,
    ROUND(SUM(CASE WHEN SpendTier = 1 THEN TotalSpent ELSE 0 END) * 100.0 / SUM(TotalSpent), 2) AS Top20PctContribution
FROM Tiered;

-- Q2: Sales rep performance
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    COUNT(DISTINCT c.CustomerId) AS CustomersHandled,
    SUM(i.Total) AS TotalRevenue,
    ROUND(SUM(i.Total) / COUNT(DISTINCT c.CustomerId), 2) AS AvgRevenuePerCustomer,
    RANK() OVER (ORDER BY SUM(i.Total) DESC) AS RevenueRank
FROM Employee e
INNER JOIN Customer c ON e.EmployeeId = c.SupportRepId
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY e.EmployeeId, e.FirstName, e.LastName
ORDER BY TotalRevenue DESC;

-- Q3: Revenue trend over time
WITH MonthlyRevenue AS (
    SELECT YEAR(InvoiceDate) AS InvoiceYear,
           MONTH(InvoiceDate) AS InvoiceMonth,
           SUM(Total) AS Revenue
    FROM Invoice
    GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
)
SELECT 
    InvoiceYear, InvoiceMonth, Revenue,
    LAG(Revenue) OVER (ORDER BY InvoiceYear, InvoiceMonth) AS PreviousMonthRevenue,
    ROUND((Revenue - LAG(Revenue) OVER (ORDER BY InvoiceYear, InvoiceMonth)) * 100.0
          / LAG(Revenue) OVER (ORDER BY InvoiceYear, InvoiceMonth), 2) AS PctChange
FROM MonthlyRevenue
ORDER BY InvoiceYear, InvoiceMonth;

-- Q4: Customer spend segments
WITH CustomerSpend AS (
    SELECT CustomerId, SUM(Total) AS TotalSpent
    FROM Invoice
    GROUP BY CustomerId
)
SELECT 
    CASE WHEN TotalSpent < 35 THEN 'Low spender'
         WHEN TotalSpent BETWEEN 35 AND 42 THEN 'Medium spender'
         ELSE 'High spender' END AS SpendSegment,
    COUNT(CustomerId) AS NumCustomers,
    SUM(TotalSpent) AS SegmentRevenue,
    ROUND(SUM(TotalSpent) * 100.0 / (SELECT SUM(TotalSpent) FROM CustomerSpend), 2) AS PctOfTotalRevenue
FROM CustomerSpend
GROUP BY CASE WHEN TotalSpent < 35 THEN 'Low spender'
              WHEN TotalSpent BETWEEN 35 AND 42 THEN 'Medium spender'
              ELSE 'High spender' END
ORDER BY SegmentRevenue DESC;

-- Q5: Country-level performance
SELECT 
    BillingCountry,
    COUNT(InvoiceId) AS TotalOrders,
    SUM(Total) AS TotalRevenue,
    ROUND(AVG(Total), 2) AS AvgOrderValue
FROM Invoice
GROUP BY BillingCountry
ORDER BY TotalRevenue DESC;