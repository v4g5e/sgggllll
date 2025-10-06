﻿CREATE DATABASE RealEstateDB;
USE RealEstateDB;

CREATE TABLE Properties (
    PropertyID INT IDENTITY PRIMARY KEY,
    Address NVARCHAR(200) NOT NULL,
    PropertyType NVARCHAR(50) CHECK (PropertyType IN ('Apartment', 'House', 'Commercial', 'Land')),
    Price DECIMAL(12,2),
    Area DECIMAL(8,2),
    Bedrooms INT,
    Bathrooms INT,
    Status NVARCHAR(20) DEFAULT 'Available' CHECK (Status IN ('Available', 'Sold', 'Rented', 'Under Contract'))
);

CREATE TABLE Agents (
    AgentID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    CommissionRate DECIMAL(5,2),
    HireDate DATE
);

CREATE TABLE Clients (
    ClientID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    ClientType NVARCHAR(20) CHECK (ClientType IN ('Buyer', 'Seller', 'Tenant', 'Landlord'))
);

CREATE TABLE Viewings (
    ViewingID INT IDENTITY PRIMARY KEY,
    PropertyID INT FOREIGN KEY REFERENCES Properties(PropertyID),
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    AgentID INT FOREIGN KEY REFERENCES Agents(AgentID),
    ViewingDate DATETIME,
    ClientFeedback NVARCHAR(500)
);

CREATE TABLE Deals (
    DealID INT IDENTITY PRIMARY KEY,
    PropertyID INT FOREIGN KEY REFERENCES Properties(PropertyID),
    BuyerClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    SellerClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    AgentID INT FOREIGN KEY REFERENCES Agents(AgentID),
    DealDate DATE,
    FinalPrice DECIMAL(12,2),
    Commission DECIMAL(10,2),
    Status NVARCHAR(20) DEFAULT 'Completed'
);

-- 1. Агенты с объемом продаж выше среднего
SELECT a.FirstName, a.LastName, SUM(d.FinalPrice) as TotalSales
FROM Agents a
JOIN Deals d ON a.AgentID = d.AgentID
WHERE d.Status = 'Completed'
GROUP BY a.AgentID, a.FirstName, a.LastName
HAVING SUM(d.FinalPrice) > (
    SELECT AVG(TotalSales) FROM (
        SELECT SUM(FinalPrice) as TotalSales 
        FROM Deals 
        WHERE Status = 'Completed'
        GROUP BY AgentID
    ) as temp
);

-- 2. Объекты без просмотров в течение месяца
SELECT Address, Price, Status
FROM Properties p
WHERE Status = 'Available' AND NOT EXISTS (
    SELECT 1 FROM Viewings v 
    WHERE v.PropertyID = p.PropertyID 
    AND v.ViewingDate > DATEADD(MONTH, -1, GETDATE())
);

-- КУРСОР ДЛЯ РАСЧЕТА КОМИССИЙ АГЕНТОВ
DECLARE @AgentID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @Commission DECIMAL(12,2);
DECLARE agent_cursor CURSOR FOR
SELECT a.AgentID, a.FirstName, a.LastName, SUM(d.Commission)
FROM Agents a
JOIN Deals d ON a.AgentID = d.AgentID
WHERE d.Status = 'Completed' AND YEAR(d.DealDate) = YEAR(GETDATE())
GROUP BY a.AgentID, a.FirstName, a.LastName
ORDER BY SUM(d.Commission) DESC;

OPEN agent_cursor;
FETCH NEXT FROM agent_cursor INTO @AgentID, @FirstName, @LastName, @Commission;

PRINT 'КОМИССИИ АГЕНТОВ ЗА ТЕКУЩИЙ ГОД';
PRINT '===============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @LastName + ' ' + @FirstName + ': ' + FORMAT(@Commission, 'C', 'ru-RU');
    FETCH NEXT FROM agent_cursor INTO @AgentID, @FirstName, @LastName, @Commission;
END;

CLOSE agent_cursor;
DEALLOCATE agent_cursor;
GO