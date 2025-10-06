CREATE DATABASE MuseumDB;
USE MuseumDB;

CREATE TABLE Halls (
    HallID INT IDENTITY PRIMARY KEY,
    HallName NVARCHAR(100) NOT NULL,
    Floor INT,
    Theme NVARCHAR(100)
);

CREATE TABLE Exhibits (
    ExhibitID INT IDENTITY PRIMARY KEY,
    ExhibitName NVARCHAR(100) NOT NULL,
    HallID INT FOREIGN KEY REFERENCES Halls(HallID),
    CreationYear INT,
    Author NVARCHAR(100),
    Description NVARCHAR(500),
    Value DECIMAL(12,2)
);

CREATE TABLE Exhibitions (
    ExhibitionID INT IDENTITY PRIMARY KEY,
    ExhibitionName NVARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Curator NVARCHAR(100),
    Description NVARCHAR(500)
);

CREATE TABLE Visitors (
    VisitorID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    VisitDate DATE DEFAULT GETDATE()
);

CREATE TABLE Tickets (
    TicketID INT IDENTITY PRIMARY KEY,
    VisitorID INT FOREIGN KEY REFERENCES Visitors(VisitorID),
    ExhibitionID INT FOREIGN KEY REFERENCES Exhibitions(ExhibitionID),
    TicketType NVARCHAR(20), -- взрослый, детский, льготный
    Price DECIMAL(8,2),
    PurchaseDate DATETIME DEFAULT GETDATE()
);

-- 1. Выставки с посещаемостью выше средней
SELECT e.ExhibitionName, COUNT(t.TicketID) as VisitorsCount
FROM Exhibitions e
JOIN Tickets t ON e.ExhibitionID = t.ExhibitionID
GROUP BY e.ExhibitionID, e.ExhibitionName
HAVING COUNT(t.TicketID) > (
    SELECT AVG(CAST(VisitorsCount AS FLOAT)) FROM (
        SELECT COUNT(TicketID) as VisitorsCount 
        FROM Tickets 
        GROUP BY ExhibitionID
    ) as temp
);

-- 2. Залы с самыми ценными экспонатами
SELECT h.HallName, COUNT(e.ExhibitID) as ExhibitsCount,
       AVG(e.Value) as AvgValue, MAX(e.Value) as MaxValue
FROM Halls h
JOIN Exhibits e ON h.HallID = e.HallID
GROUP BY h.HallID, h.HallName
HAVING AVG(e.Value) > 10000;
GO