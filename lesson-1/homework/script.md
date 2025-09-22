# Lesson 1: Introduction to SQL Server and SSMS

##  Notes before tasks
- Tasks solved using **SQL Server**.
- Case **insensitivity** applies.
- Alias names do not affect score.
- Scoring is based on **correct output**.
- One correct solution is sufficient.

---

##  Easy

### 1. Define the following terms
- **Data** – Raw facts or figures that have little meaning on their own. Example: `23, "Ali", 90`.
- **Database** – A structured collection of data stored and managed electronically.
- **Relational Database** – A type of database that stores data in tables with relationships between them (using keys).
- **Table** – A collection of rows and columns used to organize data inside a relational database.

---

### 2. Five key features of SQL Server
1. High performance and scalability.
2. Security with authentication and encryption.
3. Data integration and ETL tools (SSIS).
4. Business intelligence support (SSRS, SSAS).
5. Backup and recovery features.

---

### 3. Authentication modes in SQL Server
1. **Windows Authentication Mode** – Uses Active Directory / Windows credentials.
2. **SQL Server Authentication Mode** – Uses SQL Server–created login (username + password).

---

##  Medium

### 4. Create a new database in SSMS
```sql
CREATE DATABASE SchoolDB;

### 5. Create a table called Students
USE SchoolDB;

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT
);

### 6. Differences between SQL Server, SSMS, and SQL

SQL Server – The database engine (RDBMS) used to store and process data.

SSMS (SQL Server Management Studio) – A graphical tool to connect, manage, and interact with SQL Server.

SQL (Structured Query Language) – A language used to communicate with relational databases (create, modify, retrieve data).

### 7. SQL Command Categories

| Category | Full Form                    | Purpose               | Example                                                  |
| -------- | ---------------------------- | --------------------- | -------------------------------------------------------- |
| **DQL**  | Data Query Language          | Retrieve data         | `SELECT * FROM Students;`                                |
| **DML**  | Data Manipulation Language   | Modify data           | `INSERT INTO Students VALUES (1, 'Ali', 20);`            |
| **DDL**  | Data Definition Language     | Define schema/objects | `CREATE TABLE Courses (CourseID INT, Name VARCHAR(50));` |
| **DCL**  | Data Control Language        | Permissions & access  | `GRANT SELECT ON Students TO User1;`                     |
| **TCL**  | Transaction Control Language | Manage transactions   | `BEGIN TRAN; COMMIT; ROLLBACK;`                          |

### 8. Insert three records into Students
INSERT INTO Students (StudentID, Name, Age)
VALUES 
(1, 'Ali', 20),
(2, 'Malika', 22),
(3, 'Javlon', 19);

### 9. Restore AdventureWorksDW2022.bak
C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup


