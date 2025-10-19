--1. Combine Two Tables--
SELECT 
    p.firstName,
    p.lastName,
    a.city,
    a.state
FROM Person p
LEFT JOIN Address a
    ON p.personId = a.personId;

--2. Employees Earning More Than Their Managers--
SELECT 
    e.name AS Employee
FROM Employee e
JOIN Employee m
    ON e.managerId = m.id
WHERE e.salary > m.salary;

-3. Duplicate Emails-
SELECT 
    email AS Email
FROM Person
GROUP BY email
HAVING COUNT(*) > 1;

-4. Delete Duplicate Emails (keep lowest id)-
DELETE p
FROM Person p
JOIN Person q
    ON p.email = q.email
   AND p.id > q.id;

-5. Parents Who Have Only Girls-
SELECT DISTINCT g.ParentName
FROM girls g
WHERE g.ParentName NOT IN (SELECT ParentName FROM boys);

-6. Total Over 50 and Least Weight (TSQL2012 database)-
SELECT 
    custid,
    SUM(freight) AS total_sales_over_50,
    MIN(freight) AS least_weight
FROM Sales.Orders
WHERE freight > 50
GROUP BY custid;

-7. Carts-
SELECT 
    c1.Item AS [Item Cart 1],
    c2.Item AS [Item Cart 2]
FROM Cart1 c1
FULL OUTER JOIN Cart2 c2
    ON c1.Item = c2.Item;

-8. Customers Who Never Order-
SELECT 
    c.name AS Customers
FROM Customers c
LEFT JOIN Orders o
    ON c.id = o.customerId
WHERE o.customerId IS NULL;

-9. Students and Examinations-
SELECT 
    s.student_id,
    s.student_name,
    sub.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e
    ON s.student_id = e.student_id
   AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id, sub.subject_name;
