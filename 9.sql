CREATE DATABASE TheaterDB;
USE TheaterDB;

CREATE TABLE Plays (
    PlayID INT IDENTITY PRIMARY KEY,
    PlayName NVARCHAR(100) NOT NULL,
    Director NVARCHAR(100),
    Duration INT, -- в минутах
    Genre NVARCHAR(50),
    Description NVARCHAR(500)
);

CREATE TABLE Actors (
    ActorID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BirthDate DATE,
    Phone NVARCHAR(20)
);

CREATE TABLE Cast (
    CastID INT IDENTITY PRIMARY KEY,
    PlayID INT FOREIGN KEY REFERENCES Plays(PlayID),
    ActorID INT FOREIGN KEY REFERENCES Actors(ActorID),
    RoleName NVARCHAR(100) NOT NULL,
    IsMainRole BIT DEFAULT 0
);

CREATE TABLE Performances (
    PerformanceID INT IDENTITY PRIMARY KEY,
    PlayID INT FOREIGN KEY REFERENCES Plays(PlayID),
    PerformanceDate DATETIME NOT NULL,
    Hall NVARCHAR(50),
    TotalSeats INT,
    AvailableSeats INT
);

CREATE TABLE Tickets (
    TicketID INT IDENTITY PRIMARY KEY,
    PerformanceID INT FOREIGN KEY REFERENCES Performances(PerformanceID),
    SeatNumber NVARCHAR(10) NOT NULL,
    Price DECIMAL(8,2) NOT NULL,
    CustomerName NVARCHAR(100),
    CustomerPhone NVARCHAR(20),
    SaleDate DATETIME,
    Status NVARCHAR(20) DEFAULT 'Available'
);

-- 1. Спектакли с заполняемостью выше средней
SELECT p.PlayName, perf.PerformanceDate, 
       (perf.TotalSeats - perf.AvailableSeats) as SoldSeats,
       CAST((perf.TotalSeats - perf.AvailableSeats) AS FLOAT) / perf.TotalSeats * 100 as OccupancyRate
FROM Plays p
JOIN Performances perf ON p.PlayID = perf.PlayID
WHERE (perf.TotalSeats - perf.AvailableSeats) / CAST(perf.TotalSeats AS FLOAT) > (
    SELECT AVG(CAST((TotalSeats - AvailableSeats) AS FLOAT) / TotalSeats)
    FROM Performances
    WHERE AvailableSeats < TotalSeats
);

-- 2. Актеры, занятые в нескольких спектаклях
SELECT FirstName, LastName, COUNT(DISTINCT PlayID) as PlaysCount
FROM Actors a
JOIN Cast c ON a.ActorID = c.ActorID
GROUP BY a.ActorID, a.FirstName, a.LastName
HAVING COUNT(DISTINCT PlayID) > 1;
GO