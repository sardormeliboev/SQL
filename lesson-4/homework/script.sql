-- 1. Select the top 5 employees from the Employees table
SELECT TOP 5 * FROM Employees;

-- 2. Select unique Category values from the Products table
SELECT DISTINCT Category FROM Products;

-- 3. Show products with Price > 100
SELECT * FROM Products WHERE Price > 100;

-- 4. Customers whose FirstName start with 'A'
SELECT * FROM Customers WHERE FirstName LIKE 'A%';

-- 5. Order Products table by Price ASC
SELECT * FROM Products ORDER BY Price ASC;

-- 6. Employees with Salary >= 60000 and Department = 'HR'
SELECT * FROM Employees WHERE Salary >= 60000 AND DepartmentName = 'HR';

-- 7. Replace NULL Email with 'noemail@example.com' in Employees
SELECT ISNULL(Email, 'noemail@example.com') AS Email FROM Employees;

-- 8. Products with Price BETWEEN 50 AND 100
SELECT * FROM Products WHERE Price BETWEEN 50 AND 100;

-- 9. SELECT DISTINCT on Category and ProductName
SELECT DISTINCT Category, ProductName FROM Products;

-- 10. DISTINCT on Category and ProductName ordered by ProductName DESC
SELECT DISTINCT Category, ProductName FROM Products ORDER BY ProductName DESC;

-- 11. Top 10 products by Price DESC
SELECT TOP 10 * FROM Products ORDER BY Price DESC;

-- 12. COALESCE FirstName or LastName
SELECT COALESCE(FirstName, LastName) AS Name FROM Employees;

-- 13. DISTINCT Category and Price from Products
SELECT DISTINCT Category, Price FROM Products;

-- 14. Employees with Age BETWEEN 30 AND 40 OR Department = 'Marketing'
SELECT * FROM Employees WHERE (Age BETWEEN 30 AND 40) OR DepartmentName = 'Marketing';

-- 15. Rows 11 to 20 from Employees ordered by Salary DESC
SELECT * FROM Employees ORDER BY Salary DESC OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;

-- 16. Products with Price <= 1000 and StockQuantity > 50 ordered by Stock
SELECT * FROM Products WHERE Price <= 1000 AND StockQuantity > 50 ORDER BY StockQuantity ASC;

-- 17. ProductName contains letter 'e'
SELECT * FROM Products WHERE ProductName LIKE '%e%';

-- 18. Employees in 'HR', 'IT', or 'Finance'
SELECT * FROM Employees WHERE DepartmentName IN ('HR', 'IT', 'Finance');

-- 19. Customers ordered by City ASC and PostalCode DESC
SELECT * FROM Customers ORDER BY City ASC, PostalCode DESC;


-- 20. Top 5 products with highest sales (based on SaleAmount)
SELECT TOP 5 p.ProductID, p.ProductName, SUM(s.SaleAmount) AS TotalSales
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalSales DESC;

-- 21. Combine FirstName and LastName as FullName in Employees
SELECT CONCAT(ISNULL(FirstName, ''), ' ', ISNULL(LastName, '')) AS FullName FROM Employees;

-- 22. DISTINCT Category, ProductName, and Price > 50
SELECT DISTINCT Category, ProductName, Price FROM Products WHERE Price > 50;

-- 23. Products where Price < 10% of average price
SELECT * FROM Products WHERE Price < 0.1 * (SELECT AVG(Price) FROM Products);

-- 24. Employees Age < 30 and in 'HR' or 'IT'
SELECT * FROM Employees WHERE Age < 30 AND DepartmentName IN ('HR', 'IT');

-- 25. Customers whose Email contains '@gmail.com'
SELECT * FROM Customers WHERE Email LIKE '%@gmail.com%';

-- 26. Employees with salary greater than all in 'Sales' department
SELECT * FROM Employees
WHERE Salary > ALL (
  SELECT Salary FROM Employees WHERE DepartmentName = 'Sales'
);

-- 27. Orders placed in the last 180 days (based on current date)
SELECT * FROM Orders
WHERE OrderDate BETWEEN DATEADD(DAY, -180, GETDATE()) AND GETDATE();
