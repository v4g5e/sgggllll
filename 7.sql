CREATE DATABASE TaxiDB;
USE TaxiDB;

CREATE TABLE Drivers (
    DriverID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    LicenseNumber NVARCHAR(20),
    HireDate DATE
);

CREATE TABLE Cars (
    CarID INT IDENTITY PRIMARY KEY,
    Model NVARCHAR(50) NOT NULL,
    LicensePlate NVARCHAR(15) UNIQUE NOT NULL,
    Color NVARCHAR(20),
    Year INT,
    DriverID INT FOREIGN KEY REFERENCES Drivers(DriverID)
);

CREATE TABLE Tariffs (
    TariffID INT IDENTITY PRIMARY KEY,
    TariffName NVARCHAR(50) NOT NULL,
    BasePrice DECIMAL(8,2),
    PricePerKm DECIMAL(6,2),
    MinimumPrice DECIMAL(8,2)
);

CREATE TABLE Customers (
    CustomerID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE Rides (
    RideID INT IDENTITY PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    DriverID INT FOREIGN KEY REFERENCES Drivers(DriverID),
    CarID INT FOREIGN KEY REFERENCES Cars(CarID),
    TariffID INT FOREIGN KEY REFERENCES Tariffs(TariffID),
    PickupAddress NVARCHAR(200) NOT NULL,
    DestinationAddress NVARCHAR(200) NOT NULL,
    Distance DECIMAL(6,2),
    StartTime DATETIME,
    EndTime DATETIME,
    TotalPrice DECIMAL(8,2),
    Status NVARCHAR(20) DEFAULT 'Completed'
);

-- 1. Водители с заработком выше среднего
SELECT d.FirstName, d.LastName, SUM(r.TotalPrice) as TotalEarnings
FROM Drivers d
JOIN Rides r ON d.DriverID = r.DriverID
WHERE r.Status = 'Completed'
GROUP BY d.DriverID, d.FirstName, d.LastName
HAVING SUM(r.TotalPrice) > (
    SELECT AVG(TotalEarnings) FROM (
        SELECT SUM(TotalPrice) as TotalEarnings 
        FROM Rides 
        WHERE Status = 'Completed'
        GROUP BY DriverID
    ) as temp
);

-- 2. Клиенты с наибольшим количеством поездок
SELECT FirstName, LastName, COUNT(RideID) as RideCount
FROM Customers c
JOIN Rides r ON c.CustomerID = r.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY RideCount DESC;
GO