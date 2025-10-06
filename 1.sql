CREATE DATABASE BowlingClubDB;
USE BowlingClubDB;

CREATE TABLE Players (
    PlayerID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    RegistrationDate DATE DEFAULT GETDATE(),
    SkillLevel NVARCHAR(20) CHECK (SkillLevel IN ('Beginner', 'Intermediate', 'Advanced', 'Professional'))
);

CREATE TABLE Lanes (
    LaneID INT IDENTITY PRIMARY KEY,
    LaneNumber INT NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Available',
    Condition NVARCHAR(20) CHECK (Condition IN ('Excellent', 'Good', 'Maintenance', 'Repair'))
);

CREATE TABLE Tournaments (
    TournamentID INT IDENTITY PRIMARY KEY,
    TournamentName NVARCHAR(100) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    EntryFee DECIMAL(8,2),
    PrizePool DECIMAL(10,2)
);

CREATE TABLE Games (
    GameID INT IDENTITY PRIMARY KEY,
    PlayerID INT FOREIGN KEY REFERENCES Players(PlayerID),
    LaneID INT FOREIGN KEY REFERENCES Lanes(LaneID),
    TournamentID INT FOREIGN KEY REFERENCES Tournaments(TournamentID),
    GameDate DATETIME DEFAULT GETDATE(),
    Score INT,
    Duration INT
);

CREATE TABLE Equipment (
    EquipmentID INT IDENTITY PRIMARY KEY,
    EquipmentType NVARCHAR(50) NOT NULL,
    Size NVARCHAR(10),
    Condition NVARCHAR(20),
    LastMaintenance DATE
);

-- 1. Игроки с результатом выше среднего
SELECT FirstName, LastName, Score
FROM Players p
JOIN Games g ON p.PlayerID = g.PlayerID
WHERE g.Score > (
    SELECT AVG(Score) FROM Games WHERE Score > 0
);

-- 2. Дорожки с наибольшим количеством игр
SELECT LaneNumber, COUNT(GameID) as GamesCount
FROM Lanes l
JOIN Games g ON l.LaneID = g.LaneID
GROUP BY l.LaneID, l.LaneNumber
HAVING COUNT(GameID) > (
    SELECT AVG(CAST(GamesCount AS FLOAT)) FROM (
        SELECT COUNT(GameID) as GamesCount 
        FROM Games 
        GROUP BY LaneID
    ) as temp
);

-- КУРСОР ДЛЯ РАСЧЕТА РЕЙТИНГА ИГРОКОВ
DECLARE @PlayerID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @AvgScore FLOAT;
DECLARE player_cursor CURSOR FOR
SELECT p.PlayerID, p.FirstName, p.LastName, AVG(CAST(g.Score AS FLOAT))
FROM Players p
JOIN Games g ON p.PlayerID = g.PlayerID
WHERE g.Score > 0
GROUP BY p.PlayerID, p.FirstName, p.LastName
ORDER BY AVG(CAST(g.Score AS FLOAT)) DESC;

OPEN player_cursor;
FETCH NEXT FROM player_cursor INTO @PlayerID, @FirstName, @LastName, @AvgScore;

PRINT 'РЕЙТИНГ ИГРОКОВ БОУЛИНГ-КЛУБА';
PRINT '==============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @LastName + ' ' + @FirstName + ': ' + CAST(ROUND(@AvgScore, 1) AS NVARCHAR(10)) + ' очков';
    FETCH NEXT FROM player_cursor INTO @PlayerID, @FirstName, @LastName, @AvgScore;
END;

CLOSE player_cursor;
DEALLOCATE player_cursor;
GO