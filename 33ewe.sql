USE master
GO

IF DB_ID('ShopDB') IS NOT NULL
    DROP DATABASE ShopDB;
GO

CREATE DATABASE ShopDB;
GO

USE ShopDB
GO

CREATE TABLE Employees
(
    EmployeeID int NOT NULL IDENTITY PRIMARY KEY,
    FName nvarchar(15) NOT NULL,
    LName nvarchar(15) NOT NULL,
    MName nvarchar(15) NOT NULL,
    Salary money NOT NULL,
    PriorSalary money NOT NULL,
    HireDate date NOT NULL,
    TerminationDate date NULL,
    ManagerEmpID int NULL
);
GO

CREATE TABLE Customers
(
    CustomerNo int NOT NULL IDENTITY PRIMARY KEY,
    FName nvarchar(15) NOT NULL,
    LName nvarchar(15) NOT NULL,
    MName nvarchar(15) NULL,
    Address1 nvarchar(50) NOT NULL,
    Address2 nvarchar(50) NULL,
    City nchar(10) NOT NULL,
    Phone char(12) NOT NULL UNIQUE,
    DateInSystem date NULL,
    CHECK (Phone LIKE '([0-9][0-9][0-9])[0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);
GO

CREATE TABLE Orders
(
    OrderID int NOT NULL IDENTITY PRIMARY KEY,
    OrderDate date NOT NULL,
    CustomerNo int NULL,
    EmployeeID int NULL
);
GO

ALTER TABLE Orders 
ADD FOREIGN KEY (CustomerNo) REFERENCES Customers(CustomerNo);
GO

ALTER TABLE Orders 
ADD FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID);
GO

CREATE TABLE OrderDetails
(
    OrderID int NOT NULL,
    LineItem int NOT NULL,
    ProductID char(5) NOT NULL,
    ProductDescription varchar(15),
    UnitPrice smallmoney NOT NULL,
    Qty int NOT NULL,
    TotalPrice as Qty * UnitPrice,
    PRIMARY KEY (OrderID, LineItem)
);
GO

ALTER TABLE OrderDetails 
ADD FOREIGN KEY (OrderID) REFERENCES Orders(OrderID);
GO

INSERT INTO Employees (FName, MName, LName, Salary, PriorSalary, HireDate, ManagerEmpID)
VALUES
('Èâàí', 'Èâàíîâè÷', 'Áåëåöêèé', 2000, 0, '2009-11-20', NULL),
('Ñâåòëàíà', 'Îëåãîâíà', 'Ëÿëå÷êèíà', 800, 0, '2009-11-20', 1);
GO

INSERT INTO Customers (FName, LName, MName, Address1, City, Phone, DateInSystem)
VALUES
('Âàñèëèé', 'Ëÿùåíêî', 'Ïåòðîâè÷', 'Ëóæíàÿ 15', 'Õàðüêîâ', '(092)3212211', '2009-11-20'),
('Çèãìóíä', 'Óíàêèé', 'Ôåäîðîâè÷', 'Äåãòÿðåâñêàÿ 5', 'Êèåâ', '(092)7612343', '2010-08-17');
GO

INSERT INTO Orders (OrderDate, CustomerNo, EmployeeID)
VALUES
('2009-12-28', 1, 1),
('2010-09-01', 2, 2);
GO

INSERT INTO OrderDetails (OrderID, LineItem, ProductID, ProductDescription, UnitPrice, Qty)
VALUES
(1, 1, 'LV231', 'Äæèíñû', 45, 5),
(1, 2, 'DG30', 'Ðåìåíü', 30, 5),
(2, 1, 'GC11', 'Øàïêà', 32, 10);
GO

SELECT * FROM Customers;
SELECT * FROM Employees;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;
GO