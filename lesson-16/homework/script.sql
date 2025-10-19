/* ===========================================================
   Lesson 16: CTEs and Derived Tables
   ===========================================================
   Notes:
   - Compatible with SQL Server
   - Focus: Recursive CTEs, Aggregation, Derived Tables
   =========================================================== */


---------------------------------------------------------------
-- EASY TASKS
---------------------------------------------------------------

/* 1. Create a numbers table using a recursive query from 1 to 1000 */
WITH Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n < 1000
)
SELECT * FROM Numbers;
-- OPTION (MAXRECURSION 1000);


/* 2. Total sales per employee using a derived table */
SELECT e.EmployeeID, e.FirstName, e.LastName, s.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID
) s ON e.EmployeeID = s.EmployeeID;


/* 3. CTE to find average salary of employees */
WITH AvgSalary AS (
    SELECT AVG(Salary) AS AvgSal FROM Employees
)
SELECT AvgSal FROM AvgSalary;


/* 4. Derived table to find highest sales for each product */
SELECT p.ProductName, MaxSales.MaxSale
FROM Products p
JOIN (
    SELECT ProductID, MAX(SalesAmount) AS MaxSale
    FROM Sales
    GROUP BY ProductID
) MaxSales ON p.ProductID = MaxSales.ProductID;


/* 5. Recursive doubling numbers less than 1,000,000 */
WITH Doubles AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n * 2 FROM Doubles WHERE n * 2 < 1000000
)
SELECT * FROM Doubles;
-- OPTION (MAXRECURSION 1000);


/* 6. Employees who made more than 5 sales */
WITH EmpSales AS (
    SELECT EmployeeID, COUNT(*) AS SaleCount
    FROM Sales
    GROUP BY EmployeeID
)
SELECT e.EmployeeID, e.FirstName, e.LastName
FROM Employees e
JOIN EmpSales s ON e.EmployeeID = s.EmployeeID
WHERE s.SaleCount > 5;


/* 7. Products with sales greater than $500 */
WITH ProductSales AS (
    SELECT ProductID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY ProductID
)
SELECT p.ProductName, ps.TotalSales
FROM Products p
JOIN ProductSales ps ON p.ProductID = ps.ProductID
WHERE ps.TotalSales > 500;


/* 8. Employees with salaries above average */
WITH AvgSal AS (
    SELECT AVG(Salary) AS AvgSalary FROM Employees
)
SELECT * 
FROM Employees
WHERE Salary > (SELECT AvgSalary FROM AvgSal);



---------------------------------------------------------------
-- MEDIUM TASKS
---------------------------------------------------------------

/* 1. Top 5 employees by number of orders made */
SELECT TOP 5 e.EmployeeID, e.FirstName, e.LastName, COUNT(s.SalesID) AS OrderCount
FROM Employees e
JOIN Sales s ON e.EmployeeID = s.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY OrderCount DESC;


/* 2. Sales per product category using derived table */
SELECT p.CategoryID, SUM(s.SalesAmount) AS TotalSales
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY p.CategoryID;


/* 3. Factorial of each number (Numbers1 table) */
WITH FactorialCTE AS (
    SELECT Number, 1 AS i, CAST(1 AS BIGINT) AS Fact
    FROM Numbers1
    UNION ALL
    SELECT f.Number, f.i + 1, f.Fact * (f.i + 1)
    FROM FactorialCTE f
    WHERE f.i + 1 <= f.Number
)
SELECT Number, MAX(Fact) AS Factorial
FROM FactorialCTE
GROUP BY Number
ORDER BY Number;
-- OPTION (MAXRECURSION 1000);


/* 4. Split a string into characters using recursion */
WITH SplitCTE AS (
    SELECT Id, String, 1 AS Position, SUBSTRING(String, 1, 1) AS CharPart
    FROM Example
    UNION ALL
    SELECT Id, String, Position + 1,
           SUBSTRING(String, Position + 1, 1)
    FROM SplitCTE
    WHERE Position + 1 <= LEN(String)
)
SELECT Id, CharPart FROM SplitCTE;
-- OPTION (MAXRECURSION 1000);


/* 5. Sales difference between current month and previous month */
WITH MonthlySales AS (
    SELECT 
        YEAR(SaleDate) AS YearNum,
        MONTH(SaleDate) AS MonthNum,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY YEAR(SaleDate), MONTH(SaleDate)
)
SELECT 
    m1.YearNum, m1.MonthNum,
    m1.TotalSales AS CurrentMonth,
    m2.TotalSales AS PreviousMonth,
    m1.TotalSales - ISNULL(m2.TotalSales, 0) AS Difference
FROM MonthlySales m1
LEFT JOIN MonthlySales m2
    ON (m1.YearNum = m2.YearNum AND m1.MonthNum = m2.MonthNum + 1)
ORDER BY m1.YearNum, m1.MonthNum;


/* 6. Employees with sales over $45000 in each quarter */
SELECT e.EmployeeID, e.FirstName, e.LastName, 
       DATEPART(QUARTER, s.SaleDate) AS Quarter,
       SUM(s.SalesAmount) AS TotalSales
FROM Employees e
JOIN Sales s ON e.EmployeeID = s.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName, DATEPART(QUARTER, s.SaleDate)
HAVING SUM(s.SalesAmount) > 45000
ORDER BY e.EmployeeID, Quarter;



---------------------------------------------------------------
-- DIFFICULT TASKS
---------------------------------------------------------------

/* 1. Fibonacci numbers using recursion */
WITH Fibonacci AS (
    SELECT 1 AS n, 0 AS a, 1 AS b
    UNION ALL
    SELECT n + 1, b, a + b FROM Fibonacci WHERE n < 20
)
SELECT n, a AS FibonacciValue FROM Fibonacci;
-- OPTION (MAXRECURSION 1000);


/* 2. Strings with all same characters and length > 1 */
SELECT *
FROM FindSameCharacters
WHERE Vals IS NOT NULL
  AND LEN(Vals) > 1
  AND LEN(REPLACE(Vals, LEFT(Vals,1), '')) = 0;


/* 3. Numbers sequence 1 to n gradually increasing (Example n=5) */
DECLARE @n INT = 5;
WITH Seq AS (
    SELECT 1 AS n, CAST('1' AS VARCHAR(10)) AS Pattern
    UNION ALL
    SELECT n + 1, Pattern + CAST(n + 1 AS VARCHAR(10))
    FROM Seq
    WHERE n < @n
)
SELECT * FROM Seq;


/* 4. Employees with most sales in the last 6 months */
WITH RecentSales AS (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY EmployeeID
)
SELECT TOP 1 e.EmployeeID, e.FirstName, e.LastName, r.TotalSales
FROM Employees e
JOIN RecentSales r ON e.EmployeeID = r.EmployeeID
ORDER BY r.TotalSales DESC;


/* 5. Remove duplicate integers and single integer characters */
SELECT PawanName,
       Pawan_slug_name,
       REPLACE(
           (
             SELECT STRING_AGG(DISTINCT value, '') 
             FROM STRING_SPLIT(
                 REPLACE(REPLACE(Pawan_slug_name, '-', ''), 'Pawan', ''), ''
             )
           ), '', ''
       ) AS Cleaned
FROM RemoveDuplicateIntsFromNames;
