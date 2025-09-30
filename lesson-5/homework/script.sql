```sql
-- ==============================
-- Database Homework Solutions
-- ==============================

-- DROP TABLES if exist (for re-run safety)
IF OBJECT_ID('Sales', 'U') IS NOT NULL DROP TABLE Sales;
IF OBJECT_ID('Orders', 'U') IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('Employees', 'U') IS NOT NULL DROP TABLE Employees;
IF OBJECT_ID('Products_Discounted', 'U') IS NOT NULL DROP TABLE Products_Discounted;
IF OBJECT_ID('Products', 'U') IS NOT NULL DROP TABLE Products;
IF OBJECT_ID('Customers', 'U') IS NOT NULL DROP TABLE Customers;

-- ==============================
-- 1. Create Tables
-- ==============================

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Country NVARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Products_Discounted (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(50),
    DiscountRate DECIMAL(5,2),
    StockQuantity INT
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Age INT,
    Department NVARCHAR(50),
    Salary DECIMAL(10,2)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Quantity INT
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    CustomerID INT,
    SaleAmount DECIMAL(10,2)
);

-- ==============================
-- 2. Insert Sample Data
-- ==============================

INSERT INTO Customers VALUES 
(1, 'John', 'Doe', 'USA'),
(2, 'Alice', 'Smith', 'UK'),
(3, 'Bob', 'Brown', 'Canada');

INSERT INTO Products VALUES 
(1, 'Laptop', 1200.00),
(2, 'Phone', 800.00),
(3, 'Tablet', 600.00);

INSERT INTO Products_Discounted VALUES 
(1, 'Laptop', 0.10, 150),
(2, 'Phone', 0.15, 80),
(4, 'Monitor', 0.05, 200);

INSERT INTO Employees VALUES 
(1, 'Mike', 'Johnson', 30, 'HR', 55000.00),
(2, 'Sara', 'Williams', 22, 'IT', 45000.00),
(3, 'Tom', 'Lee', 28, 'Finance', 70000.00);

INSERT INTO Orders VALUES 
(1, 1, 2, 1),
(2, 2, 1, 3),
(3, 3, 3, 2);

INSERT INTO Sales VALUES 
(1, 1, 400.00),
(2, 2, 150.00),
(3, 3, 600.00);

-- ==============================
-- EASY LEVEL TASKS
-- ==============================

-- Task 1: Alias for column
SELECT ProductName AS Name
FROM Products;

-- Task 2: Alias for table
SELECT * 
FROM Customers AS Client;

-- Task 3: UNION Products + Products_Discounted
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted;

-- Task 4: INTERSECT Products + Products_Discounted
SELECT ProductName FROM Products
INTERSECT
SELECT ProductName FROM Products_Discounted;

-- Task 5: DISTINCT customers
SELECT DISTINCT FirstName + ' ' + LastName AS CustomerName, Country
FROM Customers;

-- Task 6: CASE conditional column
SELECT ProductName,
       Price,
       CASE WHEN Price > 1000 THEN 'High'
            ELSE 'Low'
       END AS PriceCategory
FROM Products;

-- Task 7: IIF condition
SELECT ProductName,
       StockQuantity,
       IIF(StockQuantity > 100, 'Yes', 'No') AS InStockOver100
FROM Products_Discounted;

-- ==============================
-- MEDIUM LEVEL TASKS
-- ==============================

-- Task 8: UNION Products + Products_Discounted
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted;

-- Task 9: EXCEPT Products not in Products_Discounted
SELECT ProductName FROM Products
EXCEPT
SELECT ProductName FROM Products_Discounted;

-- Task 10: IIF for price
SELECT ProductName,
       Price,
       IIF(Price > 1000, 'Expensive', 'Affordable') AS PriceTag
FROM Products;

-- Task 11: Employees filter
SELECT *
FROM Employees
WHERE Age < 25 OR Salary > 60000;

-- Task 12: Update salary with condition
UPDATE Employees
SET Salary = Salary * 1.10
WHERE Department = 'HR' OR EmployeeID = 5;

-- ==============================
-- HARD LEVEL TASKS
-- ==============================

-- Task 13: CASE SaleAmount tiers
SELECT SaleID,
       SaleAmount,
       CASE WHEN SaleAmount > 500 THEN 'Top Tier'
            WHEN SaleAmount BETWEEN 200 AND 500 THEN 'Mid Tier'
            ELSE 'Low Tier'
       END AS Tier
FROM Sales;

-- Task 14: Customers with Orders but not in Sales
SELECT CustomerID 
FROM Orders
EXCEPT
SELECT CustomerID 
FROM Sales;

-- Task 15: CASE for discount (Orders)
SELECT CustomerID,
       Quantity,
       CASE WHEN Quantity = 1 THEN '3%'
            WHEN Quantity BETWEEN 2 AND 3 THEN '5%'
            ELSE '7%'
       END AS DiscountPercentage
FROM Orders;
```
