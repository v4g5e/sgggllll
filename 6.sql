﻿﻿CREATE DATABASE DeliveryServiceDB;
USE DeliveryServiceDB;

CREATE TABLE Warehouses (
    WarehouseID INT IDENTITY PRIMARY KEY,
    WarehouseName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(200) NOT NULL,
    Phone NVARCHAR(20),
    Capacity INT
);

CREATE TABLE Couriers (
    CourierID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    VehicleType NVARCHAR(50),
    Status NVARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE Customers (
    CustomerID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    Address NVARCHAR(200) NOT NULL,
    Email NVARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT IDENTITY PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    CourierID INT FOREIGN KEY REFERENCES Couriers(CourierID),
    WarehouseID INT FOREIGN KEY REFERENCES Warehouses(WarehouseID),
    OrderDate DATETIME DEFAULT GETDATE(),
    DeliveryAddress NVARCHAR(200) NOT NULL,
    TotalWeight DECIMAL(8,2),
    DeliveryFee DECIMAL(8,2),
    Status NVARCHAR(20) DEFAULT 'Pending',
    EstimatedDelivery DATETIME,
    ActualDelivery DATETIME
);

CREATE TABLE Routes (
    RouteID INT IDENTITY PRIMARY KEY,
    CourierID INT FOREIGN KEY REFERENCES Couriers(CourierID),
    RouteDate DATE DEFAULT GETDATE(),
    StartTime TIME,
    EndTime TIME,
    TotalDistance DECIMAL(8,2),
    OrdersCompleted INT
);

-- 1. Курьеры с количеством доставок выше среднего
SELECT c.FirstName, c.LastName, COUNT(o.OrderID) as DeliveriesCount
FROM Couriers c
JOIN Orders o ON c.CourierID = o.CourierID
WHERE o.Status = 'Delivered'
GROUP BY c.CourierID, c.FirstName, c.LastName
HAVING COUNT(o.OrderID) > (
    SELECT AVG(CAST(DeliveriesCount AS FLOAT)) FROM (
        SELECT COUNT(OrderID) as DeliveriesCount 
        FROM Orders 
        WHERE Status = 'Delivered'
        GROUP BY CourierID
    ) as temp
);

-- 2. Заказы с просроченной доставкой
SELECT o.OrderID, c.FirstName, c.LastName, o.EstimatedDelivery
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.Status = 'In Transit' AND o.EstimatedDelivery < GETDATE();

-- КУРСОР ДЛЯ ОПТИМИЗАЦИИ МАРШРУТОВ
DECLARE @CourierID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @PendingOrders INT;
DECLARE courier_cursor CURSOR FOR
SELECT c.CourierID, c.FirstName, c.LastName, COUNT(o.OrderID)
FROM Couriers c
LEFT JOIN Orders o ON c.CourierID = o.CourierID AND o.Status = 'Pending'
WHERE c.Status = 'Available'
GROUP BY c.CourierID, c.FirstName, c.LastName
ORDER BY COUNT(o.OrderID) DESC;

OPEN courier_cursor;
FETCH NEXT FROM courier_cursor INTO @CourierID, @FirstName, @LastName, @PendingOrders;

PRINT 'РАСПРЕДЕЛЕНИЕ ЗАКАЗОВ ПО КУРЬЕРАМ';
PRINT '================================';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @LastName + ' ' + @FirstName + ': ' + CAST(@PendingOrders AS NVARCHAR(3)) + ' ожидающих заказов';
    FETCH NEXT FROM courier_cursor INTO @CourierID, @FirstName, @LastName, @PendingOrders;
END;

CLOSE courier_cursor;
DEALLOCATE courier_cursor;
GO