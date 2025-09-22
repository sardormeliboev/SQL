#1. Create a table Employees with columns: EmpID INT, Name (VARCHAR(50)), and Salary (DECIMAL(10,2)).
# SQL Practice Tasks (Basic, Intermediate, Advanced)

##  Notes
- All queries tested on **SQL Server**.
- Case-insensitivity applies.
- Output correctness is key.
- One valid solution is enough.

---

##  Basic-Level Tasks (10)

### 1. Create Employees table
```sql
CREATE TABLE Employees (
    EmpID INT,
    Name VARCHAR(50),
    Salary DECIMAL(10,2)
);

#2. Insert three records into the Employees table using different INSERT INTO approaches (single-row insert and multiple-row insert).
  -- Single row insert
INSERT INTO Employees (EmpID, Name, Salary)
VALUES (1, 'Ali', 6000.00);

-- Another single row insert
INSERT INTO Employees
VALUES (2, 'Malika', 5500.00);

-- Multiple row insert
INSERT INTO Employees (EmpID, Name, Salary)
VALUES 
(3, 'Javlon', 4800.00),
(4, 'Dilshod', 7200.00);
# 3.Update the Salary of an employee to 7000 where EmpID = 1.
UPDATE Employees
SET Salary = 7000
WHERE EmpID = 1;

# 4.Delete a record from the Employees table where EmpID = 2.
DELETE FROM Employees
WHERE EmpID = 2;

#5. Give a brief definition for difference between DELETE, TRUNCATE, and DROP.
  5. Difference between DELETE, TRUNCATE, DROP

DELETE – removes selected rows; structure remains; can use WHERE.

TRUNCATE – removes all rows quickly; structure remains; cannot use WHERE.

DROP – removes the entire table structure and data permanently.
  # 6. Modify the Name column in the Employees table to VARCHAR(100).
ALTER TABLE Employees
ALTER COLUMN Name VARCHAR(100);

#7.Add a new column Department (VARCHAR(50)) to the Employees table.
ALTER TABLE Employees
ADD Department VARCHAR(50);

#8. Change the data type of the Salary column to FLOAT.
ALTER TABLE Employees
ALTER COLUMN Salary FLOAT;

#9.Create another table Departments with columns DepartmentID (INT, PRIMARY KEY) and DepartmentName (VARCHAR(50)).
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

# 10. Remove all records (keep structure)
  TRUNCATE TABLE Employees;

1. Insert records into Departments (INSERT INTO SELECT)
INSERT INTO Departments (DepartmentID, DepartmentName)
SELECT 1, 'HR' UNION ALL
SELECT 2, 'Finance' UNION ALL
SELECT 3, 'IT' UNION ALL
SELECT 4, 'Marketing' UNION ALL
SELECT 5, 'Sales';

#2. Update Department where Salary > 5000
UPDATE Employees
SET Department = 'Management'
WHERE Salary > 5000;

#3. Remove all employees (keep structure)
TRUNCATE TABLE Employees;

# 4. Drop Department column
ALTER TABLE Employees
DROP COLUMN Department;

#5. Rename Employees to StaffMembers
EXEC sp_rename 'Employees', 'StaffMembers';

# 6. Drop Departments table
DROP TABLE Departments;

# 1. Create Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Brand VARCHAR(50)
);

#2. Add CHECK constraint
ALTER TABLE Products
ADD CONSTRAINT chk_price CHECK (Price > 0);

# 3. Add StockQuantity with default
ALTER TABLE Products
ADD StockQuantity INT DEFAULT 50;

#4. Rename Category to ProductCategory
EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN';

#5. Insert 5 records

INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, Brand, StockQuantity)
VALUES 
(1, 'Laptop', 'Electronics', 1200.00, 'Dell', 30),
(2, 'Phone', 'Electronics', 800.00, 'Samsung', 50),
(3, 'Shoes', 'Clothing', 90.00, 'Nike', 100),
(4, 'Book', 'Education', 25.00, 'Pearson', 200),
(5, 'Watch', 'Accessories', 150.00, 'Casio', 60);

#6. Create backup table using SELECT INTO
SELECT * INTO Products_Backup
FROM Products;

#7. Rename Products to Inventory
EXEC sp_rename 'Products', 'Inventory';
#8. Change Price datatype to FLOAT
ALTER TABLE Inventory
ALTER COLUMN Price FLOAT;

#9. Add IDENTITY column ProductCode

ALTER TABLE Inventory
ADD ProductCode INT IDENTITY(1000, 5);


