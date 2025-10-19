SELECT 
    LEFT(Name, CHARINDEX(',', Name) - 1) AS Name,
    LTRIM(RIGHT(Name, LEN(Name) - CHARINDEX(',', Name))) AS Surname
FROM TestMultipleColumns;


SELECT *
FROM TestPercent
WHERE Text LIKE '%[%]%';


SELECT 
    value AS Part
FROM STRING_SPLIT((SELECT TOP 1 Str FROM Splitter), '.');


SELECT *
FROM testDots
WHERE LEN(Vals) - LEN(REPLACE(Vals, '.', '')) > 2;


SELECT 
    Text,
    LEN(Text) - LEN(REPLACE(Text, ' ', '')) AS SpaceCount
FROM CountSpaces;


SELECT e.name AS Employee
FROM Employee e
JOIN Employee m ON e.managerId = m.id
WHERE e.salary > m.salary;


SELECT 
    EmployeeID,
    Name,
    HireDate,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsOfService
FROM Employees
WHERE DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 10 AND 15;


SELECT w1.Id
FROM Weather w1
JOIN Weather w2 ON w1.RecordDate = DATEADD(DAY, 1, w2.RecordDate)
WHERE w1.Temperature > w2.Temperature;


SELECT player_id, MIN(event_date) AS first_login
FROM Activity
GROUP BY player_id;


SELECT 
    value AS ThirdItem
FROM STRING_SPLIT((SELECT TOP 1 Fruits FROM Fruits), ',')
WHERE ordinal = 3;  -- SQL Server 2022 yoki STRING_SPLIT WITH ORDINALS


WITH Split AS (
    SELECT value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM STRING_SPLIT((SELECT TOP 1 Fruits FROM Fruits), ',')
)
SELECT value AS ThirdItem
FROM Split
WHERE rn = 3;


SELECT 
    EmployeeID,
    Name,
    HireDate,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS Years,
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 1 THEN 'New Hire'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 1 AND 5 THEN 'Junior'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 6 AND 10 THEN 'Mid-Level'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 11 AND 20 THEN 'Senior'
        ELSE 'Veteran'
    END AS EmploymentStage
FROM Employees;


SELECT 
    Text,
    LEFT(Text, PATINDEX('%[^0-9]%', Text + 'X') - 1) AS StartingInteger
FROM GetIntegers
WHERE Text LIKE '[0-9]%';


SELECT 
    SUBSTRING(Value, 3, 1) + SUBSTRING(Value, 2, 1) + RIGHT(Value, LEN(Value) - 2) AS Swapped
FROM MultipleVals;


DECLARE @str VARCHAR(100) = 'sdgfhsdgfhs@121313131';

WITH Numbers AS (
    SELECT TOP (LEN(@str)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects
)
SELECT SUBSTRING(@str, n, 1) AS Character
FROM Numbers;


SELECT player_id, MIN(device_id) AS first_device
FROM Activity
GROUP BY player_id;


DECLARE @text VARCHAR(50) = 'rtcfvty34redt';

SELECT 
    LEFT(@text, PATINDEX('%[0-9]%', @text) - 1) AS Letters,
    SUBSTRING(@text, PATINDEX('%[0-9]%', @text), LEN(@text)) AS Numbers;


