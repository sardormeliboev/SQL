/* ============================================================
   Lesson 18: View, Temp Table, Variable, Functions
   ============================================================ */

--------------------------------------------------------------
-- 1. Create Temporary Table: MonthlySales
--------------------------------------------------------------
DROP TABLE IF EXISTS #MonthlySales;

SELECT 
    s.ProductID,
    SUM(s.Quantity) AS TotalQuantity,
    SUM(s.Quantity * p.Price) AS TotalRevenue
INTO #MonthlySales
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
WHERE MONTH(s.SaleDate) = MONTH(GETDATE())
  AND YEAR(s.SaleDate) = YEAR(GETDATE())
GROUP BY s.ProductID;

SELECT * FROM #MonthlySales;


--------------------------------------------------------------
-- 2. Create View: vw_ProductSalesSummary
--------------------------------------------------------------
DROP VIEW IF EXISTS vw_ProductSalesSummary;
GO
CREATE VIEW vw_ProductSalesSummary AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.Category,
    SUM(s.Quantity) AS TotalQuantitySold
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category;
GO

SELECT * FROM vw_ProductSalesSummary;


--------------------------------------------------------------
-- 3. Function: fn_GetTotalRevenueForProduct(@ProductID)
--------------------------------------------------------------
DROP FUNCTION IF EXISTS fn_GetTotalRevenueForProduct;
GO
CREATE FUNCTION fn_GetTotalRevenueForProduct(@ProductID INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Revenue DECIMAL(18,2);
    SELECT @Revenue = SUM(s.Quantity * p.Price)
    FROM Sales s
    JOIN Products p ON s.ProductID = p.ProductID
    WHERE s.ProductID = @ProductID;

    RETURN ISNULL(@Revenue, 0);
END;
GO

SELECT dbo.fn_GetTotalRevenueForProduct(1) AS TotalRevenue;


--------------------------------------------------------------
-- 4. Function: fn_GetSalesByCategory(@Category)
--------------------------------------------------------------
DROP FUNCTION IF EXISTS fn_GetSalesByCategory;
GO
CREATE FUNCTION fn_GetSalesByCategory(@Category VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.ProductName,
        SUM(s.Quantity) AS TotalQuantity,
        SUM(s.Quantity * p.Price) AS TotalRevenue
    FROM Products p
    LEFT JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.Category = @Category
    GROUP BY p.ProductName
);
GO

SELECT * FROM dbo.fn_GetSalesByCategory('Electronics');


--------------------------------------------------------------
-- 5. Function: fn_IsPrime(@Number)
--------------------------------------------------------------
DROP FUNCTION IF EXISTS dbo.fn_IsPrime;
GO
CREATE FUNCTION dbo.fn_IsPrime(@Number INT)
RETURNS VARCHAR(10)
AS
BEGIN
    IF @Number < 2 RETURN 'No';

    DECLARE @i INT = 2;
    WHILE @i <= SQRT(@Number)
    BEGIN
        IF @Number % @i = 0
            RETURN 'No';
        SET @i += 1;
    END
    RETURN 'Yes';
END;
GO

SELECT dbo.fn_IsPrime(7) AS Result;  -- Example output: Yes


--------------------------------------------------------------
-- 6. Function: fn_GetNumbersBetween(@Start, @End)
--------------------------------------------------------------
DROP FUNCTION IF EXISTS dbo.fn_GetNumbersBetween;
GO
CREATE FUNCTION dbo.fn_GetNumbersBetween(@Start INT, @End INT)
RETURNS @Numbers TABLE (Number INT)
AS
BEGIN
    DECLARE @i INT = @Start;
    WHILE @i <= @End
    BEGIN
        INSERT INTO @Numbers VALUES (@i);
        SET @i += 1;
    END
    RETURN;
END;
GO

SELECT * FROM dbo.fn_GetNumbersBetween(3, 8);


--------------------------------------------------------------
-- 7. Nth Highest Distinct Salary
--------------------------------------------------------------
CREATE TABLE Employee (id INT, salary INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES (1,100),(2,200),(3,300);
DECLARE @N INT = 2;

SELECT 
    CASE 
        WHEN COUNT(DISTINCT salary) < @N THEN NULL
        ELSE (
            SELECT DISTINCT salary
            FROM Employee
            ORDER BY salary DESC
            OFFSET (@N - 1) ROWS FETCH NEXT 1 ROWS ONLY
        )
    END AS HighestNSalary;


--------------------------------------------------------------
-- 8. Find person with most friends
--------------------------------------------------------------
CREATE TABLE RequestAccepted (requester_id INT, accepter_id INT, accept_date DATE);
TRUNCATE TABLE RequestAccepted;
INSERT INTO RequestAccepted VALUES
(1,2,'2016-06-03'),(1,3,'2016-06-08'),
(2,3,'2016-06-08'),(3,4,'2016-06-09');

SELECT TOP 1 id, COUNT(*) AS num
FROM (
    SELECT requester_id AS id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id FROM RequestAccepted
) AS AllFriends
GROUP BY id
ORDER BY COUNT(*) DESC;


--------------------------------------------------------------
-- 9. View: vw_CustomerOrderSummary
--------------------------------------------------------------
DROP VIEW IF EXISTS vw_CustomerOrderSummary;
GO
CREATE VIEW vw_CustomerOrderSummary AS
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.amount) AS total_amount,
    MAX(o.order_date) AS last_order_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;
GO

SELECT * FROM vw_CustomerOrderSummary;


--------------------------------------------------------------
-- 10. Fill Missing Gaps
--------------------------------------------------------------
DROP TABLE IF EXISTS Gaps;
CREATE TABLE Gaps (RowNumber INT PRIMARY KEY, Workflow VARCHAR(100));
INSERT INTO Gaps VALUES
(1,'Alpha'),(2,NULL),(3,NULL),(4,NULL),
(5,'Bravo'),(6,NULL),(7,NULL),(8,NULL),(9,NULL),
(10,'Charlie'),(11,NULL),(12,NULL);

WITH Filled AS (
    SELECT 
        RowNumber,
        Workflow,
        MAX(Workflow) OVER (ORDER BY RowNumber ROWS UNBOUNDED PRECEDING) AS FilledWorkflow
    FROM Gaps
)
SELECT RowNumber, FilledWorkflow AS Workflow
FROM Filled;
