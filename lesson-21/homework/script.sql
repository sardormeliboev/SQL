-----------------------------
-- 1. Row Number by SaleDate
-----------------------------
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    ROW_NUMBER() OVER (ORDER BY SaleDate) AS RowNum
FROM ProductSales;

-----------------------------
-- 2. Rank products by total quantity sold (no skip)
-----------------------------
SELECT 
    ProductName,
    SUM(Quantity) AS TotalQty,
    DENSE_RANK() OVER (ORDER BY SUM(Quantity) DESC) AS RankByQty
FROM ProductSales
GROUP BY ProductName;

-----------------------------
-- 3. Top sale for each customer
-----------------------------
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS rn
    FROM ProductSales
) t
WHERE rn = 1;

-----------------------------
-- 4. Next sale amount
-----------------------------
SELECT 
    SaleID,
    ProductName,
    SaleAmount,
    LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSale
FROM ProductSales;

-----------------------------
-- 5. Previous sale amount
-----------------------------
SELECT 
    SaleID,
    ProductName,
    SaleAmount,
    LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevSale
FROM ProductSales;

-----------------------------
-- 6. Sales greater than previous sale
-----------------------------
SELECT *
FROM (
    SELECT *,
           LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevSale
    FROM ProductSales
) t
WHERE SaleAmount > PrevSale;

-----------------------------
-- 7. Difference from previous sale (per product)
-----------------------------
SELECT 
    ProductName,
    SaleDate,
    SaleAmount,
    SaleAmount - LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DiffFromPrev
FROM ProductSales;

-----------------------------
-- 8. Percentage change vs next sale
-----------------------------
SELECT 
    SaleID,
    ProductName,
    SaleAmount,
    LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSale,
    (LEAD(SaleAmount) OVER (ORDER BY SaleDate) - SaleAmount) * 100.0 / SaleAmount AS PercentChange
FROM ProductSales;

-----------------------------
-- 9. Ratio to previous sale (within product)
-----------------------------
SELECT 
    ProductName,
    SaleDate,
    SaleAmount,
    CAST(SaleAmount AS FLOAT) /
        LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS RatioToPrev
FROM ProductSales;

-----------------------------
-- 10. Difference from first sale of product
-----------------------------
SELECT 
    ProductName,
    SaleDate,
    SaleAmount,
    SaleAmount - FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DiffFromFirst
FROM ProductSales;

-----------------------------
-- 11. Continuously increasing sales per product
-----------------------------
SELECT *
FROM (
    SELECT *,
           LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PrevSale
    FROM ProductSales
) t
WHERE SaleAmount > PrevSale;

-----------------------------
-- 12. Running total (closing balance)
-----------------------------
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SUM(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM ProductSales;

-----------------------------
-- 13. Moving average over last 3 sales
-----------------------------
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    AVG(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg3
FROM ProductSales;

-----------------------------
-- 14. Difference from overall average
-----------------------------
SELECT 
    SaleID,
    ProductName,
    SaleAmount,
    SaleAmount - AVG(SaleAmount) OVER () AS DiffFromAvg
FROM ProductSales;

--------------------------------------------------
-- EMPLOYEES1 SECTION
--------------------------------------------------

-----------------------------
-- 15. Employees with same salary rank
-----------------------------
SELECT 
    Name,
    Department,
    Salary,
    DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees1;

-----------------------------
-- 16. Top 2 salaries per department
-----------------------------
SELECT *
FROM (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS rnk
    FROM Employees1
) t
WHERE rnk <= 2;

-----------------------------
-- 17. Lowest-paid employee per department
-----------------------------
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary ASC) AS rn
    FROM Employees1
) t
WHERE rn = 1;

-----------------------------
-- 18. Running total of salaries per department
-----------------------------
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    SUM(Salary) OVER (PARTITION BY Department ORDER BY HireDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM Employees1;

-----------------------------
-- 19. Total salary per department (without GROUP BY)
-----------------------------
SELECT 
    EmployeeID,
    Name,
    Department,
    SUM(Salary) OVER (PARTITION BY Department) AS TotalDeptSalary
FROM Employees1;

-----------------------------
-- 20. Average salary per department (without GROUP BY)
-----------------------------
SELECT 
    EmployeeID,
    Name,
    Department,
    AVG(Salary) OVER (PARTITION BY Department) AS AvgDeptSalary
FROM Employees1;

-----------------------------
-- 21. Difference from department average
-----------------------------
SELECT 
    Name,
    Department,
    Salary,
    Salary - AVG(Salary) OVER (PARTITION BY Department) AS DiffFromDeptAvg
FROM Employees1;

-----------------------------
-- 22. Moving average salary (3 employees)
-----------------------------
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    AVG(Salary) OVER (ORDER BY HireDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvg3
FROM Employees1;

-----------------------------
-- 23. Sum of salaries for last 3 hired employees
-----------------------------
SELECT 
    EmployeeID,
    Name,
    HireDate,
    SUM(Salary) OVER (ORDER BY HireDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Last3Sum
FROM Employees1;
