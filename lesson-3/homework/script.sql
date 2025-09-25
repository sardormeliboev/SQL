
# Lesson 3: Importing and Exporting Data

-- Bu fayl ichida barcha bo‘limlarga oid misollar jamlangan.

USE YourDatabase;  -- kerakli ma’lumotlar bazasini tanlang
GO


# Easy-Level Tasks


-- 1. Define and explain the purpose of BULK INSERT in SQL Server.
--    BULK INSERT — katta hajmdagi tashqi fayldagi ma’lumotlarni SQL Server jadvaliga tezkor 
--    ko‘paytirish uchun ishlatiladi. Masalan CSV yoki tekst fayldan bir martada minglab 
--    satrlarni import qilishda samarali ishlaydi.

-- 2. List four file formats that can be imported into SQL Server.
--    Misollar:
--      • CSV (.csv)
--      • Tab-delimited text (.txt)
--      • Fixed-width text file
--      • Excel (.xls, .xlsx) — Excel fayllar import qilinadi OPC / SSIS yoki OPENROWSET usullari bilan

-- 3. Create a table Products with columns: ProductID (INT, PRIMARY KEY), ProductName (VARCHAR(50)), Price (DECIMAL(10,2)).
CREATE TABLE Products
(
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10,2)
);
GO

-- 4. Insert three records into the Products table using INSERT INTO.
INSERT INTO Products (ProductID, ProductName, Price) VALUES (1, 'Pen', 1.20);
INSERT INTO Products (ProductID, ProductName, Price) VALUES (2, 'Notebook', 2.50);
INSERT INTO Products (ProductID, ProductName, Price) VALUES (3, 'Eraser', 0.75);
GO

-- 5. Explain the difference between NULL and NOT NULL.
--    • NULL: Bu qiymat mavjud emasligini bildiradi (ma’lumot yo‘q, noma’lum).  
--    • NOT NULL: Bu ustun qiymatga ega bo‘lishi shart, ya’ni NULL qiymatga ruxsat berilmaydi.

-- 6. Add a UNIQUE constraint to the ProductName column in the Products table.
ALTER TABLE Products
ADD CONSTRAINT UQ_Products_ProductName UNIQUE (ProductName);
GO

-- 7. Write a comment in a SQL query explaining its purpose.
/*
   Quyidagi SELECT so‘rovi barcha mahsulotlar va ularning narxlarini chiqaradi,
   faqat narxi 1.00 dan katta bo‘lganlarni ko‘rsatadi
*/
SELECT ProductID, ProductName, Price
FROM Products
WHERE Price > 1.00;
GO

-- 8. Add CategoryID column to the Products table.
ALTER TABLE Products
ADD CategoryID INT NULL;  -- avval NULL qilib qo‘yamiz, keyin FK bilan bog‘lash mumkin
GO

-- 9. Create a table Categories with a CategoryID as PRIMARY KEY and a CategoryName as UNIQUE.
CREATE TABLE Categories
(
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100) UNIQUE
);
GO

-- 10. Explain the purpose of the IDENTITY column in SQL Server.
--     IDENTITY ustun — avtomatik tarzda ketma-ket raqam berish uchun ishlatiladi.
--     Masalan, IDENTITY(1,1) bo‘lsa, birinchi yozuv 1, keyingi 2, keyingi 3 va hk.
--     Bu usul primary key sifatida avtomatik qiymatlarni yaratish uchun keng ishlatiladi.


# Medium-Level Tasks


-- 11. Use BULK INSERT to import data from a text file into the Products table.
--     Faraz qilaylik, fayl joyi: C:\Data\products.txt, satrlar quyidagicha: ProductID,ProductName,Price,CategoryID
BULK INSERT Products
FROM 'C:\Data\products.txt'
WITH
(
    FIELDTERMINATOR = ',',      -- ustunlar orasidagi ajratkich
    ROWTERMINATOR = '\n',       -- satr oxiri
    FIRSTROW = 2                 -- agar faylda bosh sarlavha bo‘lsa (1-qatorni o‘qimaydi)
);
GO

-- 12. Create a FOREIGN KEY in the Products table that references the Categories table.
ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID);
GO

-- 13. Explain the differences between PRIMARY KEY and UNIQUE KEY.
--    • PRIMARY KEY:
--       – Har bir jadvalda faqat bitta PRIMARY KEY bo‘lishi mumkin.
--       – PRIMARY KEY ustun (yoki ustunlar kombinatsiyasi) bo‘yicha NULL qiymatlar ruxsat etilmaydi.
--       – PRIMARY KEY ustun bo‘yicha avtomatik indeks yaratiladi (klasterlangan indeks yoki no-klasterlangan).
--    • UNIQUE KEY:
--       – Bir jadvalda bir nechta UNIQUE constraint bo‘lishi mumkin.
--       – UNIQUE ustunlarda NULL qiymatlar bo‘lishi mumkin (agar ustun NOT NULL bo‘lmagan bo‘lsa) — lekin ba’zan NULL qiymatlar noyob deb hisoblanadi.
--       – UNIQUE constraint bo‘yicha indeks ham yaratiladi, lekin bu indeks PRIMARY KEY dagi kabi majburiy emas.

-- 14. Add a CHECK constraint to the Products table ensuring Price > 0.
ALTER TABLE Products
ADD CONSTRAINT CHK_Products_Price_Positive
    CHECK (Price > 0);
GO

-- 15. Modify the Products table to add a column Stock (INT, NOT NULL).
ALTER TABLE Products
ADD Stock INT NOT NULL
    DEFAULT 0;  -- mavjud yozuvlar uchun default qiymat berish
GO

-- 16. Use the ISNULL function to replace NULL values in Price column with a 0.
SELECT ProductID,
       ProductName,
       ISNULL(Price, 0) AS PriceNoNull
FROM Products;
GO

-- 17. Describe the purpose and usage of FOREIGN KEY constraints in SQL Server.
--     FOREIGN KEY — bu ikki jadval orasidagi bog‘lanishni ta’minlaydigan cheklov.
--     U “child” jadvaldagi ustunni “parent” jadvaldagi PRIMARY KEY (yoki UNIQUE) ustuniga bog‘laydi.
--     Shu tarzda, child jadvalga noto‘g‘ri (parent jadvalda yo‘q) qiymat kiritilishiga to‘sqinlik qiladi.
--     Bundan tashqari, ON DELETE va ON UPDATE opsiyalari bilan referensial harakatlarni (masalan, CASCADE) belgilash mumkin.


 # Hard-Level Tasks


-- 18. Write a script to create a Customers table with a CHECK constraint ensuring Age >= 18.
CREATE TABLE Customers
(
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Age INT,
    CONSTRAINT CHK_Customers_Age CHECK (Age >= 18)
);
GO

-- 19. Create a table with an IDENTITY column starting at 100 and incrementing by 10.
CREATE TABLE MyTableWithIdentity
(
    ID INT IDENTITY(100, 10) PRIMARY KEY,
    SomeValue VARCHAR(50)
);
GO

-- 20. Write a query to create a composite PRIMARY KEY in a new table OrderDetails.
CREATE TABLE OrderDetails
(
    OrderID INT,
    ProductID INT,
    Quantity INT,
    CONSTRAINT PK_OrderDetails PRIMARY KEY (OrderID, ProductID)
);
GO

-- 21. Explain the use of COALESCE and ISNULL functions for handling NULL values.
--    • ISNULL(expression, replacement) — agar expression NULL bo‘lsa, replacement qaytaradi, aks holda expression qaytaradi.
--    • COALESCE(expr1, expr2, …) — birinchi NULL bo‘lmagan ifodani qaytaradi. Masalan, COALESCE(NULL, 5, 10) = 5.
--    • Farqi: COALESCE ANSI SQL, bir nechta argumentni qo‘llab‑quvvatlaydi; ISNULL faqat ikkita argument oladi. 
--      Ba’zi hollarda COALESCE qaytargan tiplari ko‘proq moslashuvchan bo‘lishi mumkin.

-- 22. Create a table Employees with both PRIMARY KEY on EmpID and UNIQUE KEY on Email.
CREATE TABLE Employees
(
    EmpID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE
);
GO

-- 23. Write a query to create a FOREIGN KEY with ON DELETE CASCADE and ON UPDATE CASCADE options.
--     Misol: agar bizda Orders va OrderItems bo‘lsa, OrderItems jadvali Orders-ga bog‘langan bo‘lsin:
CREATE TABLE Orders
(
    OrderID INT PRIMARY KEY,
    OrderDate DATETIME
);
GO

CREATE TABLE OrderItems
(
    OrderItemID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    CONSTRAINT FK_OrderItems_Orders
        FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

-- ==========================================
-- Yakuniy Eslatma:
-- Bu skript sizga barcha bo‘limlarni bir joyda ko‘rib chiqish imkonini beradi.
-- GitHub-ga joylab, kurs darslari bilan birgalikda saqlashingiz mumkin.
