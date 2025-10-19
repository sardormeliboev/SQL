/* ===========================================================
   Lesson 7: Homework - SQL Practice with Aggregates and GROUP BY
   =========================================================== */

-- 🟢 EASY LEVEL (1–10)

-- 1. Minimum price of a product
SELECT MIN(Price) AS MinPrice FROM Products;

-- 2. Maximum salary from Employees
SELECT MAX(Salary) AS MaxSalary FROM Employees;

-- 3. Count rows in Customers
SELECT COUNT(*) AS CustomerCount FROM Customers;

-- 4. Count unique product categories
SELECT COUNT(DISTINCT Category) AS UniqueCategories FROM Products;

-- 5. Total sales amount for product id = 7
SELECT SUM(SaleAmount) AS TotalSales
FROM Sales
WHERE ProductID = 7;

-- 6. Average age of employees
SELECT AVG(Age) AS AvgAge FROM Employees;

-- 7. Count employees in each department
SELECT DepartmentName, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentName;

-- 8. Min and Max Price by Category
SELECT Category, MIN(Price) AS MinPrice, MAX(Price) AS MaxPrice
FROM Products
GROUP BY Category;

-- 9. Total sales per Customer
SELECT CustomerID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID;

-- 10. Departments having more than 5 employees
SELECT DepartmentName, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentName
HAVING COUNT(*) > 5;


-- 🟠 MEDIUM LEVEL (11–19)

-- 11. Total and average sales per product category
SELECT p.Category,
       SUM(s.SaleAmount) AS TotalSales,
       AVG(s.SaleAmount) AS AvgSales
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY p.Category;

-- 12. Count employees from HR department
SELECT COUNT(*) AS HREmployees
FROM Employees
WHERE DepartmentName = 'HR';

-- 13. Highest and lowest salary by department
SELECT DepartmentName,
       MAX(Salary) AS MaxSalary,
       MIN(Salary) AS MinSalary
FROM Employees
GROUP BY DepartmentName;

-- 14. Average salary per department
SELECT DepartmentName, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentName;

-- 15. AVG salary and COUNT of employees in each department
SELECT DepartmentName,
       AVG(Salary) AS AvgSalary,
       COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentName;

-- 16. Product categories with average price > 400
SELECT Category, AVG(Price) AS AvgPrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 400;

-- 17. Total sales per year
SELECT YEAR(SaleDate) AS SaleYear, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY YEAR(SaleDate)
ORDER BY SaleYear;

-- 18. Customers who placed at least 3 orders
SELECT CustomerID, COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*) >= 3;

-- 19. Departments with average salary > 60000
SELECT DepartmentName, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentName
HAVING AVG(Salary) > 60000;


-- 🔴 HARD LEVEL (20–26)

-- 20. Average price per category, filter avg > 150
SELECT Category, AVG(Price) AS AvgPrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 150;

-- 21. Total sales per Customer > 1500
SELECT CustomerID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID
HAVING SUM(SaleAmount) > 1500;

-- 22. Total & average salary per department, avg > 65000
SELECT DepartmentName,
       SUM(Salary) AS TotalSalary,
       AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentName
HAVING AVG(Salary) > 65000;

-- 23. Total amount for orders (freight > 50) per customer + least purchases
SELECT CustomerID,
       SUM(TotalDue) AS TotalAmountOver50,
       MIN(TotalDue) AS LeastPurchase
FROM Sales.Orders
WHERE Freight > 50
GROUP BY CustomerID;

-- 25. Total sales & unique products sold per month/year (min 2 products)
SELECT YEAR(OrderDate) AS OrderYear,
       MONTH(OrderDate) AS OrderMonth,
       SUM(TotalAmount) AS TotalSales,
       COUNT(DISTINCT ProductID) AS UniqueProducts
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
HAVING COUNT(DISTINCT ProductID) >= 2
ORDER BY OrderYear, OrderMonth;

-- 26. MIN and MAX order quantity per year
SELECT YEAR(OrderDate) AS OrderYear,
       MIN(Quantity) AS MinQty,
       MAX(Quantity) AS MaxQty
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;

