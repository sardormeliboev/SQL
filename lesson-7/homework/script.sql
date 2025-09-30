# Lesson-7: Homework (SQL Practice)

This homework is designed for practicing SQL queries.
All tasks are solved in **SQL Server**.

---

## 📌 Table Creation & Sample Data

```sql
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);

INSERT INTO Employees (EmpID, Name, Department, Salary, HireDate)
VALUES
(1, 'Alice', 'HR', 5000, '2020-01-15'),
(2, 'Bob', 'IT', 7000, '2019-03-20'),
(3, 'Charlie', 'Finance', 6000, '2021-07-10'),
(4, 'Diana', 'IT', 8000, '2018-11-05'),
(5, 'Eve', 'HR', 5500, '2022-04-12'),
(6, 'Frank', 'Finance', 7500, '2019-09-30'),
(7, 'Grace', 'IT', 7200, '2021-02-18'),
(8, 'Henry', 'Finance', 5800, '2020-06-25');
```

---

## 🟢 Easy Level

### 1. Select all employees from the IT department

```sql
SELECT * 
FROM Employees
WHERE Department = 'IT';
```

### 2. Find employees with salary greater than 6000

```sql
SELECT Name, Salary
FROM Employees
WHERE Salary > 6000;
```

### 3. Order employees by HireDate (earliest first)

```sql
SELECT *
FROM Employees
ORDER BY HireDate ASC;
```

---

## 🟡 Medium Level

### 4. Find the average salary in each department

```sql
SELECT Department, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY Department;
```

### 5. Find employees hired after 2020

```sql
SELECT Name, HireDate
FROM Employees
WHERE HireDate > '2020-01-01';
```

### 6. Count how many employees are in each department

```sql
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department;
```

---

## 🔴 Hard Level

### 7. Find the employee(s) with the highest salary

```sql
SELECT Name, Salary
FROM Employees
WHERE Salary = (SELECT MAX(Salary) FROM Employees);
```

### 8. Find departments where the average salary is more than 6500

```sql
SELECT Department
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > 6500;
```

### 9. Find the second highest salary

```sql
SELECT MAX(Salary) AS SecondHighestSalary
FROM Employees
WHERE Salary < (SELECT MAX(Salary) FROM Employees);
```

### 10. Show employees whose salary is above the average salary of all employees

```sql
SELECT Name, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);
```

---

✅ End of Lesson-7 Homework
