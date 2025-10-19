---------------------------------------------
-- LESSON 19: STORED PROCEDURES & MERGE
---------------------------------------------

-------------------------------
-- PART 1: STORED PROCEDURES --
-------------------------------

-- Drop existing tables if needed
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS DepartmentBonus;

-- Create tables
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(10,2)
);

CREATE TABLE DepartmentBonus (
    Department NVARCHAR(50) PRIMARY KEY,
    BonusPercentage DECIMAL(5,2)
);

-- Sample data
INSERT INTO Employees VALUES
(1, 'John', 'Doe', 'Sales', 5000),
(2, 'Jane', 'Smith', 'Sales', 5200),
(3, 'Mike', 'Brown', 'IT', 6000),
(4, 'Anna', 'Taylor', 'HR', 4500);

INSERT INTO DepartmentBonus VALUES
('Sales', 10),
('IT', 15),
('HR', 8);

---------------------------------------------
-- Task 1: Procedure - Employee Bonus Report
---------------------------------------------
DROP PROCEDURE IF EXISTS sp_EmployeeBonus;

CREATE PROCEDURE sp_EmployeeBonus
AS
BEGIN
    CREATE TABLE #EmployeeBonus (
        EmployeeID INT,
        FullName NVARCHAR(100),
        Department NVARCHAR(50),
        Salary DECIMAL(10,2),
        BonusAmount DECIMAL(10,2)
    );

    INSERT INTO #EmployeeBonus
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS FullName,
        e.Department,
        e.Salary,
        e.Salary * d.BonusPercentage / 100 AS BonusAmount
    FROM Employees e
    JOIN DepartmentBonus d ON e.Department = d.Department;

    SELECT * FROM #EmployeeBonus;
END;
GO

-- EXEC sp_EmployeeBonus;

---------------------------------------------
-- Task 2: Procedure - Increase Salary by %
---------------------------------------------
DROP PROCEDURE IF EXISTS sp_IncreaseSalary;

CREATE PROCEDURE sp_IncreaseSalary
    @Dept NVARCHAR(50),
    @Percent DECIMAL(5,2)
AS
BEGIN
    UPDATE Employees
    SET Salary = Salary + (Salary * @Percent / 100)
    WHERE Department = @Dept;

    SELECT * FROM Employees WHERE Department = @Dept;
END;
GO

-- EXEC sp_IncreaseSalary @Dept = 'Sales', @Percent = 5;


----------------------------
-- PART 2: MERGE TASKS
----------------------------

DROP TABLE IF EXISTS Products_Current;
DROP TABLE IF EXISTS Products_New;

CREATE TABLE Products_Current (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE Products_New (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

INSERT INTO Products_Current VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 600),
(3, 'Smartphone', 800);

INSERT INTO Products_New VALUES
(2, 'Tablet Pro', 700),
(3, 'Smartphone', 850),
(4, 'Smartwatch', 300);

---------------------------------------------
-- Task 3: MERGE operation
---------------------------------------------
MERGE Products_Current AS Target
USING Products_New AS Source
ON Target.ProductID = Source.ProductID
WHEN MATCHED THEN
    UPDATE SET 
        Target.ProductName = Source.ProductName,
        Target.Price = Source.Price
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price)
    VALUES (Source.ProductID, Source.ProductName, Source.Price)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

SELECT * FROM Products_Current;
GO


---------------------------------------------
-- Task 4: Tree Node (Leetcode 608)
---------------------------------------------
DROP TABLE IF EXISTS Tree;
CREATE TABLE Tree (id INT, p_id INT);

INSERT INTO Tree (id, p_id) VALUES
(1, NULL),
(2, 1),
(3, 1),
(4, 2),
(5, 2);

SELECT 
    id,
    CASE
        WHEN p_id IS NULL THEN 'Root'
        WHEN id NOT IN (SELECT DISTINCT p_id FROM Tree WHERE p_id IS NOT NULL) THEN 'Leaf'
        ELSE 'Inner'
    END AS type
FROM Tree;
GO


---------------------------------------------
-- Task 5: Confirmation Rate (Leetcode 1934)
---------------------------------------------
DROP TABLE IF EXISTS Signups;
DROP TABLE IF EXISTS Confirmations;

CREATE TABLE Signups (user_id INT, time_stamp DATETIME);
CREATE TABLE Confirmations (user_id INT, time_stamp DATETIME, action VARCHAR(10));

INSERT INTO Signups VALUES
(3, '2020-03-21 10:16:13'),
(7, '2020-01-04 13:57:59'),
(2, '2020-07-29 23:09:44'),
(6, '2020-12-09 10:39:37');

INSERT INTO Confirmations VALUES
(3, '2021-01-06 03:30:46', 'timeout'),
(3, '2021-07-14 14:00:00', 'timeout'),
(7, '2021-06-12 11:57:29', 'confirmed'),
(7, '2021-06-13 12:58:28', 'confirmed'),
(7, '2021-06-14 13:59:27', 'confirmed'),
(2, '2021-01-22 00:00:00', 'confirmed'),
(2, '2021-02-28 23:59:59', 'timeout');

SELECT 
    s.user_id,
    COALESCE(
        CAST(SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END) * 1.0 /
             NULLIF(COUNT(c.user_id), 0) AS DECIMAL(3,2)), 0.00
    ) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c ON s.user_id = c.user_id
GROUP BY s.user_id
ORDER BY s.user_id;
GO


---------------------------------------------
-- Task 6: Employees with Lowest Salary
---------------------------------------------
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);

INSERT INTO employees VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);

SELECT *
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);
GO


---------------------------------------------
-- Task 7: Stored Procedure - Product Sales Summary
---------------------------------------------
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Sales;

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    SaleDate DATE
);

INSERT INTO Products VALUES
(1, 'Laptop Model A', 'Electronics', 1200),
(2, 'Laptop Model B', 'Electronics', 1500),
(3, 'Tablet Model X', 'Electronics', 600),
(4, 'Tablet Model Y', 'Electronics', 700),
(5, 'Smartphone Alpha', 'Electronics', 800),
(6, 'Smartphone Beta', 'Electronics', 850),
(7, 'Smartwatch Series 1', 'Wearables', 300),
(8, 'Smartwatch Series 2', 'Wearables', 350),
(9, 'Headphones Basic', 'Accessories', 150),
(10, 'Headphones Pro', 'Accessories', 250),
(11, 'Wireless Mouse', 'Accessories', 50),
(12, 'Wireless Keyboard', 'Accessories', 80),
(13, 'Desktop PC Standard', 'Computers', 1000),
(14, 'Desktop PC Gaming', 'Computers', 2000),
(15, 'Monitor 24 inch', 'Displays', 200),
(16, 'Monitor 27 inch', 'Displays', 300),
(17, 'Printer Basic', 'Office', 120),
(18, 'Printer Pro', 'Office', 400),
(19, 'Router Basic', 'Networking', 70),
(20, 'Router Pro', 'Networking', 150);

INSERT INTO Sales VALUES
(1, 1, 2, '2024-01-15'),
(2, 1, 1, '2024-02-10'),
(3, 1, 3, '2024-03-08'),
(4, 2, 1, '2024-01-22'),
(5, 3, 5, '2024-01-20'),
(6, 5, 2, '2024-02-18'),
(7, 5, 1, '2024-03-25'),
(8, 6, 4, '2024-04-02'),
(9, 7, 2, '2024-01-30'),
(10, 7, 1, '2024-02-25'),
(11, 7, 1, '2024-03-15'),
(12, 9, 8, '2024-01-18'),
(13, 9, 5, '2024-02-20'),
(14, 10, 3, '2024-03-22'),
(15, 11, 2, '2024-02-14'),
(16, 13, 1, '2024-03-10'),
(17, 14, 2, '2024-03-22'),
(18, 15, 5, '2024-02-01'),
(19, 15, 3, '2024-03-11'),
(20, 19, 4, '2024-04-01');

DROP PROCEDURE IF EXISTS GetProductSalesSummary;
GO

CREATE PROCEDURE GetProductSalesSummary
    @ProductID INT
AS
BEGIN
    SELECT 
        p.ProductName,
        SUM(s.Quantity) AS TotalQuantity,
        SUM(s.Quantity * p.Price) AS TotalSalesAmount,
        MIN(s.SaleDate) AS FirstSaleDate,
        MAX(s.SaleDate) AS LastSaleDate
    FROM Products p
    LEFT JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.ProductID = @ProductID
    GROUP BY p.ProductName;
END;
GO

-- EXEC GetProductSalesSummary @ProductID = 1;
