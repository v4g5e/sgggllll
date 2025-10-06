CREATE DATABASE PharmacyDB;
USE PharmacyDB;

CREATE TABLE Suppliers (
    SupplierID INT IDENTITY PRIMARY KEY,
    CompanyName NVARCHAR(100) NOT NULL,
    ContactPerson NVARCHAR(100),
    Phone NVARCHAR(20)
);

CREATE TABLE Medications (
    MedicationID INT IDENTITY PRIMARY KEY,
    MedicationName NVARCHAR(100) NOT NULL,
    SupplierID INT FOREIGN KEY REFERENCES Suppliers(SupplierID),
    Category NVARCHAR(50),
    Price DECIMAL(10,2),
    StockQuantity INT,
    RequiresPrescription BIT
);

CREATE TABLE Customers (
    CustomerID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    Discount DECIMAL(5,2) DEFAULT 0
);

CREATE TABLE Prescriptions (
    PrescriptionID INT IDENTITY PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    DoctorName NVARCHAR(100),
    IssueDate DATE,
    ExpiryDate DATE
);

CREATE TABLE Sales (
    SaleID INT IDENTITY PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    MedicationID INT FOREIGN KEY REFERENCES Medications(MedicationID),
    Quantity INT,
    SaleDate DATETIME,
    TotalAmount DECIMAL(10,2),
    PrescriptionID INT FOREIGN KEY REFERENCES Prescriptions(PrescriptionID)
);

-- 1. Лекарства с продажами выше среднего
SELECT MedicationName, SUM(s.Quantity) as TotalSold
FROM Medications m
JOIN Sales s ON m.MedicationID = s.MedicationID
GROUP BY m.MedicationID, m.MedicationName
HAVING SUM(s.Quantity) > (
    SELECT AVG(CAST(TotalSold AS FLOAT)) FROM (
        SELECT SUM(Quantity) as TotalSold 
        FROM Sales 
        GROUP BY MedicationID
    ) as temp
);

-- 2. Поставщики, у которых заканчиваются лекарства
SELECT CompanyName, MedicationName, StockQuantity
FROM Suppliers s
JOIN Medications m ON s.SupplierID = m.SupplierID
WHERE m.StockQuantity < 10;
GO