CREATE DATABASE InternetCafeDB;
USE InternetCafeDB;

CREATE TABLE Computers (
    ComputerID INT IDENTITY PRIMARY KEY,
    ComputerName NVARCHAR(20) NOT NULL,
    Specifications NVARCHAR(200),
    Status NVARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE Tariffs (
    TariffID INT IDENTITY PRIMARY KEY,
    TariffName NVARCHAR(50) NOT NULL,
    PricePerHour DECIMAL(6,2) NOT NULL,
    Description NVARCHAR(200)
);

CREATE TABLE Customers (
    CustomerID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    RegistrationDate DATE DEFAULT GETDATE()
);

CREATE TABLE Administrators (
    AdminID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Shift NVARCHAR(20)
);

CREATE TABLE Sessions (
    SessionID INT IDENTITY PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    ComputerID INT FOREIGN KEY REFERENCES Computers(ComputerID),
    AdminID INT FOREIGN KEY REFERENCES Administrators(AdminID),
    TariffID INT FOREIGN KEY REFERENCES Tariffs(TariffID),
    StartTime DATETIME NOT NULL,
    EndTime DATETIME,
    TotalHours DECIMAL(4,2),
    TotalCost DECIMAL(8,2),
    Status NVARCHAR(20) DEFAULT 'Active'
);

-- 1. Компьютеры с наибольшей выручкой
SELECT c.ComputerName, SUM(s.TotalCost) as TotalRevenue
FROM Computers c
JOIN Sessions s ON c.ComputerID = s.ComputerID
WHERE s.Status = 'Completed'
GROUP BY c.ComputerID, c.ComputerName
HAVING SUM(s.TotalCost) > (
    SELECT AVG(TotalRevenue) FROM (
        SELECT SUM(TotalCost) as TotalRevenue 
        FROM Sessions 
        WHERE Status = 'Completed'
        GROUP BY ComputerID
    ) as temp
);

-- 2. Активные сеансы с просроченным временем
SELECT CustomerID, ComputerID, StartTime, DATEDIFF(HOUR, StartTime, GETDATE()) as HoursUsed
FROM Sessions
WHERE Status = 'Active' AND DATEDIFF(HOUR, StartTime, GETDATE()) > 5;
GO