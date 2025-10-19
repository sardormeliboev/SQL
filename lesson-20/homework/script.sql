/* =============================================================
   Lesson 20: Practice — Subqueries & EXISTS
   Platform: SQL Server
   ============================================================= */

/* -------------------------------
   1. Create Sales Table and Data
--------------------------------*/
CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);

INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES
('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),
('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),
('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),
('David', 'Laptop', 1, 1300.00, '2024-03-05'),
('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),
('Frank', 'Headphones', 2, 100.00, '2024-04-08'),
('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'),
('Hannah', 'Tablet', 2, 480.00, '2024-05-05'),
('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'),
('Jack', 'Smartphone', 1, 820.00, '2024-06-01');

/* =============================================================
   1. Find customers who purchased at least one item in March 2024
   ============================================================= */
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.CustomerName = s1.CustomerName
      AND MONTH(s2.SaleDate) = 3
      AND YEAR(s2.SaleDate) = 2024
);

/* =============================================================
   2. Product with the highest total sales revenue
   ============================================================= */
SELECT TOP 1 Product, SUM(Quantity * Price) AS TotalRevenue
FROM #Sales
GROUP BY Product
ORDER BY TotalRevenue DESC;

/* =============================================================
   3. Second highest sale amount (Quantity * Price)
   ============================================================= */
SELECT TOP 1 (Quantity * Price) AS SaleAmount
FROM #Sales
WHERE (Quantity * Price) < (SELECT MAX(Quantity * Price) FROM #Sales)
ORDER BY (Quantity * Price) DESC;

/* =============================================================
   4. Total quantity of products sold per month
   ============================================================= */
SELECT DISTINCT MONTH(SaleDate) AS SaleMonth,
       (SELECT SUM(Quantity) FROM #Sales s2 WHERE MONTH(s2.SaleDate) = MONTH(s1.SaleDate)) AS TotalQuantity
FROM #Sales s1
ORDER BY SaleMonth;

/* =============================================================
   5. Customers who bought same products as another customer
   ============================================================= */
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1 FROM #Sales s2
    WHERE s2.Product = s1.Product
      AND s2.CustomerName <> s1.CustomerName
);

/* =============================================================
   6. Count fruits per person and pivot
   ============================================================= */
CREATE TABLE #Fruits(Name VARCHAR(50), Fruit VARCHAR(50));
INSERT INTO #Fruits VALUES
('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Apple'),
('Francesko', 'Orange'), ('Francesko', 'Banana'), ('Francesko', 'Orange'),
('Li', 'Apple'), ('Li', 'Orange'), ('Li', 'Apple'), ('Li', 'Banana'),
('Mario', 'Apple'), ('Mario', 'Apple'), ('Mario', 'Apple'),
('Mario', 'Banana'), ('Mario', 'Banana'), ('Mario', 'Orange');

SELECT Name,
       SUM(CASE WHEN Fruit='Apple' THEN 1 ELSE 0 END) AS Apple,
       SUM(CASE WHEN Fruit='Orange' THEN 1 ELSE 0 END) AS Orange,
       SUM(CASE WHEN Fruit='Banana' THEN 1 ELSE 0 END) AS Banana
FROM #Fruits
GROUP BY Name;

/* =============================================================
   7. Older people in the family with younger ones
   ============================================================= */
CREATE TABLE #Family(ParentId INT, ChildID INT);
INSERT INTO #Family VALUES (1,2),(2,3),(3,4);

SELECT f1.ParentId AS PID, f2.ChildID AS CHID
FROM #Family f1
JOIN #Family f2
ON f2.ParentID IN (
    SELECT ChildID FROM #Family f3 WHERE f3.ParentID = f1.ParentID
)
UNION
SELECT ParentID, ChildID FROM #Family
ORDER BY PID, CHID;

/* =============================================================
   8. Customers who had delivery to CA, show their TX orders
   ============================================================= */
CREATE TABLE #Orders(
CustomerID INT, OrderID INT, DeliveryState VARCHAR(100), Amount MONEY,
PRIMARY KEY (CustomerID, OrderID)
);

INSERT INTO #Orders VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);

SELECT *
FROM #Orders o
WHERE DeliveryState = 'TX'
AND EXISTS (SELECT 1 FROM #Orders o2 WHERE o2.CustomerID = o.CustomerID AND o2.DeliveryState = 'CA');

/* =============================================================
   9. Insert missing names in residents table
   ============================================================= */
CREATE TABLE #residents(resid INT IDENTITY, fullname VARCHAR(50), address VARCHAR(100));
INSERT INTO #residents VALUES
('Dragan', 'city=Bratislava country=Slovakia name=Dragan age=45'),
('Diogo', 'city=Lisboa country=Portugal age=26'),
('Celine', 'city=Marseille country=France name=Celine age=21'),
('Theo', 'city=Milan country=Italy age=28'),
('Rajabboy', 'city=Tashkent country=Uzbekistan age=22');

UPDATE #residents
SET fullname = SUBSTRING(address, CHARINDEX('name=', address) + 5, CHARINDEX(' age', address) - CHARINDEX('name=', address) - 5)
WHERE fullname NOT LIKE '%[A-Za-z]%';

/* =============================================================
   10. Route from Tashkent to Khorezm (cheapest & most expensive)
   ============================================================= */
CREATE TABLE #Routes (
RouteID INT, DepartureCity VARCHAR(30), ArrivalCity VARCHAR(30), Cost MONEY,
PRIMARY KEY (DepartureCity, ArrivalCity)
);

INSERT INTO #Routes VALUES
(1,'Tashkent','Samarkand',100),
(2,'Samarkand','Bukhoro',200),
(3,'Bukhoro','Khorezm',300),
(4,'Samarkand','Khorezm',400),
(5,'Tashkent','Jizzakh',100),
(6,'Jizzakh','Samarkand',50);

SELECT 'Tashkent - Samarkand - Khorezm' AS Route, (100 + 400) AS Cost
UNION
SELECT 'Tashkent - Jizzakh - Samarkand - Bukhoro - Khorezm',
(100 + 50 + 200 + 300);

/* =============================================================
   11. Rank products by order of insertion
   ============================================================= */
CREATE TABLE #RankingPuzzle(ID INT, Vals VARCHAR(10));
INSERT INTO #RankingPuzzle VALUES
(1,'Product'),(2,'a'),(3,'a'),(4,'a'),(5,'a'),
(6,'Product'),(7,'b'),(8,'b'),(9,'Product'),(10,'c');

SELECT *, DENSE_RANK() OVER (ORDER BY ID) AS RankOrder FROM #RankingPuzzle;

/* =============================================================
   12. Employees with sales above department average
   ============================================================= */
CREATE TABLE #EmployeeSales (
EmployeeID INT PRIMARY KEY IDENTITY(1,1),
EmployeeName VARCHAR(100),
Department VARCHAR(50),
SalesAmount DECIMAL(10,2),
SalesMonth INT,
SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
('Alice', 'Electronics', 5000, 1, 2024),
('Bob', 'Electronics', 7000, 1, 2024),
('Charlie', 'Furniture', 3000, 1, 2024),
('David', 'Furniture', 4500, 1, 2024),
('Eve', 'Clothing', 6000, 1, 2024),
('Frank', 'Electronics', 8000, 2, 2024),
('Grace', 'Furniture', 3200, 2, 2024),
('Hannah', 'Clothing', 7200, 2, 2024),
('Isaac', 'Electronics', 9100, 3, 2024),
('Jack', 'Furniture', 5300, 3, 2024),
('Kevin', 'Clothing', 6800, 3, 2024),
('Laura', 'Electronics', 6500, 4, 2024),
('Mia', 'Furniture', 4000, 4, 2024),
('Nathan', 'Clothing', 7800, 4, 2024);

SELECT e.*
FROM #EmployeeSales e
WHERE e.SalesAmount > (
    SELECT AVG(SalesAmount)
    FROM #EmployeeSales
    WHERE Department = e.Department
);

/* =============================================================
   13. Employees who had the highest sales in any month
   ============================================================= */
SELECT DISTINCT e1.EmployeeName
FROM #EmployeeSales e1
WHERE EXISTS (
    SELECT 1 FROM #EmployeeSales e2
    WHERE e2.SalesMonth = e1.SalesMonth
      AND e2.SalesYear = e1.SalesYear
      AND e1.SalesAmount = (
            SELECT MAX(SalesAmount)
            FROM #EmployeeSales e3
            WHERE e3.SalesMonth = e1.SalesMonth AND e3.SalesYear = e1.SalesYear
      )
);

/* =============================================================
   14. Employees who made sales in every month
   ============================================================= */
SELECT DISTINCT e1.EmployeeName
FROM #EmployeeSales e1
WHERE NOT EXISTS (
    SELECT DISTINCT SalesMonth FROM #EmployeeSales
    EXCEPT
    SELECT SalesMonth FROM #EmployeeSales e2 WHERE e2.EmployeeName = e1.EmployeeName
);

/* =============================================================
   15–23. Products & Orders Queries
   ============================================================= */
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    Name VARCHAR(50),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);

INSERT INTO Products VALUES
(1,'Laptop','Electronics',1200,15),
(2,'Smartphone','Electronics',800,30),
(3,'Tablet','Electronics',500,25),
(4,'Headphones','Accessories',150,50),
(5,'Keyboard','Accessories',100,40),
(6,'Monitor','Electronics',300,20),
(7,'Mouse','Accessories',50,60),
(8,'Chair','Furniture',200,10),
(9,'Desk','Furniture',400,5),
(10,'Printer','Office Supplies',250,12),
(11,'Scanner','Office Supplies',180,8),
(12,'Notebook','Stationery',10,100),
(13,'Pen','Stationery',2,500),
(14,'Backpack','Accessories',80,30),
(15,'Lamp','Furniture',60,25);

CREATE TABLE Orders (
OrderID INT PRIMARY KEY,
ProductID INT,
Quantity INT,
OrderDate DATE,
FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Orders VALUES
(1,1,2,'2024-03-01'),(2,3,5,'2024-03-05'),(3,2,3,'2024-03-07'),
(4,5,4,'2024-03-10'),(5,8,1,'2024-03-12'),(6,10,2,'2024-03-15'),
(7,12,10,'2024-03-18'),(8,7,6,'2024-03-20'),(9,6,2,'2024-03-22'),
(10,4,3,'2024-03-25'),(11,9,2,'2024-03-28'),(12,11,1,'2024-03-30'),
(13,14,4,'2024-04-02'),(14,15,5,'2024-04-05'),(15,13,20,'2024-04-08');

/* 15. Products more expensive than average */
SELECT * FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

/* 16. Products with stock < highest stock */
SELECT * FROM Products
WHERE Stock < (SELECT MAX(Stock) FROM Products);

/* 17. Products in same category as Laptop */
SELECT * FROM Products
WHERE Category = (SELECT Category FROM Products WHERE Name='Laptop');

/* 18. Price greater than lowest in Electronics */
SELECT * FROM Products
WHERE Price > (
    SELECT MIN(Price) FROM Products WHERE Category='Electronics'
);

/* 19. Price > average of category */
SELECT * FROM Products p
WHERE Price > (
    SELECT AVG(Price) FROM Products WHERE Category = p.Category
);

/* 20. Products ordered at least once */
SELECT DISTINCT p.Name FROM Products p
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.ProductID = p.ProductID);

/* 21. Products ordered more than avg quantity */
SELECT p.Name FROM Products p
JOIN Orders o ON o.ProductID = p.ProductID
GROUP BY p.Name
HAVING SUM(o.Quantity) > (
    SELECT AVG(Quantity) FROM Orders
);

/* 22. Products never ordered */
SELECT Name FROM Products p
WHERE NOT EXISTS (SELECT 1 FROM Orders o WHERE o.ProductID = p.ProductID);

/* 23. Product with highest total quantity ordered */
SELECT TOP 1 p.Name, SUM(o.Quantity) AS TotalQty
FROM Products p
JOIN Orders o ON o.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalQty DESC;
