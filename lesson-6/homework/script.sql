```sql
-- ======================================
-- Lesson-6: Practice Solutions (SQL Server)
-- ======================================

-- ======================================
-- Puzzle 1: Finding Distinct Values
-- ======================================

CREATE TABLE InputTbl (
    col1 VARCHAR(10),
    col2 VARCHAR(10)
);

INSERT INTO InputTbl (col1, col2) VALUES 
('a', 'b'),
('a', 'b'),
('b', 'a'),
('c', 'd'),
('c', 'd'),
('m', 'n'),
('n', 'm');

-- Solution 1: Using DISTINCT with LEAST/GREATEST simulation
SELECT DISTINCT
       CASE WHEN col1 < col2 THEN col1 ELSE col2 END AS col1,
       CASE WHEN col1 < col2 THEN col2 ELSE col1 END AS col2
FROM InputTbl;

-- Solution 2: Using GROUP BY
SELECT 
       CASE WHEN col1 < col2 THEN col1 ELSE col2 END AS col1,
       CASE WHEN col1 < col2 THEN col2 ELSE col1 END AS col2
FROM InputTbl
GROUP BY CASE WHEN col1 < col2 THEN col1 ELSE col2 END,
         CASE WHEN col1 < col2 THEN col2 ELSE col1 END;

-- ======================================
-- Puzzle 2: Removing Rows with All Zeroes
-- ======================================

CREATE TABLE TestMultipleZero (
    A INT NULL,
    B INT NULL,
    C INT NULL,
    D INT NULL
);

INSERT INTO TestMultipleZero(A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),  -- should be removed
    (1,1,1,0);

-- Solution: Exclude rows where all columns = 0
SELECT *
FROM TestMultipleZero
WHERE COALESCE(A,0) + COALESCE(B,0) + COALESCE(C,0) + COALESCE(D,0) > 0;

-- ======================================
-- Puzzle 3: Find those with odd ids
-- ======================================

CREATE TABLE section1(id int, name varchar(20));

INSERT INTO section1 VALUES 
(1, 'Been'),
(2, 'Roma'),
(3, 'Steven'),
(4, 'Paulo'),
(5, 'Genryh'),
(6, 'Bruno'),
(7, 'Fred'),
(8, 'Andro');

-- Solution
SELECT *
FROM section1
WHERE id % 2 = 1;

-- ======================================
-- Puzzle 4: Person with the smallest id
-- ======================================

SELECT TOP 1 *
FROM section1
ORDER BY id ASC;

-- ======================================
-- Puzzle 5: Person with the highest id
-- ======================================

SELECT TOP 1 *
FROM section1
ORDER BY id DESC;

-- ======================================
-- Puzzle 6: People whose name starts with b
-- ======================================

SELECT *
FROM section1
WHERE name LIKE 'b%';

-- ======================================
-- Puzzle 7: Rows where code contains underscore "_"
-- ======================================

CREATE TABLE ProductCodes (
    Code VARCHAR(20)
);

INSERT INTO ProductCodes (Code) VALUES
('X-123'),
('X_456'),
('X#789'),
('X-001'),
('X%202'),
('X_ABC'),
('X#DEF'),
('X-999');

-- Solution
SELECT *
FROM ProductCodes
WHERE Code LIKE '%[_]%';

