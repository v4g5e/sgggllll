CREATE DATABASE CinemaDB;
USE CinemaDB;

CREATE TABLE Movies (
    MovieID INT IDENTITY PRIMARY KEY,
    Title NVARCHAR(100) NOT NULL,
    Genre NVARCHAR(50),
    Duration INT, -- в минутах
    Rating DECIMAL(3,1),
    Director NVARCHAR(100),
    ReleaseYear INT
);

CREATE TABLE Halls (
    HallID INT IDENTITY PRIMARY KEY,
    HallName NVARCHAR(50) NOT NULL,
    Capacity INT,
    ScreenType NVARCHAR(20) CHECK (ScreenType IN ('2D', '3D', 'IMAX', 'VIP'))
);

CREATE TABLE Screenings (
    ScreeningID INT IDENTITY PRIMARY KEY,
    MovieID INT FOREIGN KEY REFERENCES Movies(MovieID),
    HallID INT FOREIGN KEY REFERENCES Halls(HallID),
    ScreeningTime DATETIME NOT NULL,
    TicketPrice DECIMAL(8,2),
    AvailableSeats INT
);

CREATE TABLE Customers (
    CustomerID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    BirthDate DATE
);

CREATE TABLE Tickets (
    TicketID INT IDENTITY PRIMARY KEY,
    ScreeningID INT FOREIGN KEY REFERENCES Screenings(ScreeningID),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    SeatNumber NVARCHAR(10) NOT NULL,
    PurchaseDate DATETIME DEFAULT GETDATE(),
    Price DECIMAL(8,2),
    Discount DECIMAL(5,2) DEFAULT 0
);

-- 1. Фильмы с заполняемостью выше средней
SELECT m.Title, s.ScreeningTime, 
       (h.Capacity - s.AvailableSeats) as SoldSeats,
       CAST((h.Capacity - s.AvailableSeats) AS FLOAT) / h.Capacity * 100 as OccupancyRate
FROM Movies m
JOIN Screenings s ON m.MovieID = s.MovieID
JOIN Halls h ON s.HallID = h.HallID
WHERE CAST((h.Capacity - s.AvailableSeats) AS FLOAT) / h.Capacity > (
    SELECT AVG(CAST((h2.Capacity - s2.AvailableSeats) AS FLOAT) / h2.Capacity)
    FROM Screenings s2
    JOIN Halls h2 ON s2.HallID = h2.HallID
    WHERE s2.AvailableSeats < h2.Capacity
);

-- 2. Постоянные клиенты (более 3 посещений)
SELECT FirstName, LastName, COUNT(TicketID) as VisitsCount
FROM Customers c
JOIN Tickets t ON c.CustomerID = t.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING COUNT(TicketID) > 3;

-- КУРСОР ДЛЯ ОБНОВЛЕНИЯ СВОБОДНЫХ МЕСТ
DECLARE @ScreeningID INT, @SoldSeats INT, @Capacity INT;
DECLARE screening_cursor CURSOR FOR
SELECT s.ScreeningID, COUNT(t.TicketID), h.Capacity
FROM Screenings s
JOIN Halls h ON s.HallID = h.HallID
LEFT JOIN Tickets t ON s.ScreeningID = t.ScreeningID
GROUP BY s.ScreeningID, h.Capacity;

OPEN screening_cursor;
FETCH NEXT FROM screening_cursor INTO @ScreeningID, @SoldSeats, @Capacity;

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Screenings 
    SET AvailableSeats = @Capacity - @SoldSeats 
    WHERE ScreeningID = @ScreeningID;
    
    FETCH NEXT FROM screening_cursor INTO @ScreeningID, @SoldSeats, @Capacity;
END;

CLOSE screening_cursor;
DEALLOCATE screening_cursor;
GO