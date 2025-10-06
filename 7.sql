﻿﻿﻿CREATE DATABASE FitnessCenterDB;
USE FitnessCenterDB;

CREATE TABLE Members (
    MemberID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    BirthDate DATE,
    RegistrationDate DATE DEFAULT GETDATE(),
    Status NVARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE Trainers (
    TrainerID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    Specialization NVARCHAR(100),
    HireDate DATE,
    HourlyRate DECIMAL(8,2)
);

CREATE TABLE Memberships (
    MembershipID INT IDENTITY PRIMARY KEY,
    MemberID INT FOREIGN KEY REFERENCES Members(MemberID),
    MembershipType NVARCHAR(50) CHECK (MembershipType IN ('Basic', 'Premium', 'VIP', 'Student')),
    StartDate DATE,
    EndDate DATE,
    Price DECIMAL(8,2),
    AutoRenewal BIT DEFAULT 1
);

CREATE TABLE Equipment (
    EquipmentID INT IDENTITY PRIMARY KEY,
    EquipmentName NVARCHAR(100) NOT NULL,
    EquipmentType NVARCHAR(50),
    PurchaseDate DATE,
    LastMaintenance DATE,
    Status NVARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE GroupClasses (
    ClassID INT IDENTITY PRIMARY KEY,
    ClassName NVARCHAR(100) NOT NULL,
    TrainerID INT FOREIGN KEY REFERENCES Trainers(TrainerID),
    Schedule DATETIME,
    Duration INT, -- в минутах
    MaxParticipants INT,
    CurrentParticipants INT
);

CREATE TABLE ClassRegistrations (
    RegistrationID INT IDENTITY PRIMARY KEY,
    ClassID INT FOREIGN KEY REFERENCES GroupClasses(ClassID),
    MemberID INT FOREIGN KEY REFERENCES Members(MemberID),
    RegistrationDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) DEFAULT 'Registered'
);

-- 1. Тренеры с заполняемостью занятий выше средней
SELECT t.FirstName, t.LastName, 
       AVG(CAST(gc.CurrentParticipants AS FLOAT) / gc.MaxParticipants * 100) as AvgOccupancy
FROM Trainers t
JOIN GroupClasses gc ON t.TrainerID = gc.TrainerID
GROUP BY t.TrainerID, t.FirstName, t.LastName
HAVING AVG(CAST(gc.CurrentParticipants AS FLOAT) / gc.MaxParticipants * 100) > (
    SELECT AVG(CAST(CurrentParticipants AS FLOAT) / MaxParticipants * 100)
    FROM GroupClasses
    WHERE CurrentParticipants > 0
);

-- 2. Члены клуба с истекающими абонементами
SELECT m.FirstName, m.LastName, ms.EndDate, ms.MembershipType
FROM Members m
JOIN Memberships ms ON m.MemberID = ms.MemberID
WHERE ms.EndDate BETWEEN GETDATE() AND DATEADD(MONTH, 1, GETDATE())
AND ms.AutoRenewal = 0;

-- КУСРОР ДЛЯ АНАЛИЗА ПОСЕЩАЕМОСТИ
DECLARE @MemberID INT, @FullName NVARCHAR(100), @RegistrationDate DATE, @ClassesCount INT;
DECLARE member_cursor CURSOR FOR
SELECT m.MemberID, m.FirstName + ' ' + m.LastName, m.RegistrationDate, COUNT(cr.RegistrationID)
FROM Members m
LEFT JOIN ClassRegistrations cr ON m.MemberID = cr.MemberID
WHERE m.Status = 'Active'
GROUP BY m.MemberID, m.FirstName, m.LastName, m.RegistrationDate
ORDER BY COUNT(cr.RegistrationID) DESC;

OPEN member_cursor;
FETCH NEXT FROM member_cursor INTO @MemberID, @FullName, @RegistrationDate, @ClassesCount;

PRINT 'АНАЛИЗ ПОСЕЩАЕМОСТИ ЧЛЕНОВ КЛУБА';
PRINT '================================';

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @MembershipDuration INT = DATEDIFF(MONTH, @RegistrationDate, GETDATE());
    DECLARE @AvgClassesPerMonth DECIMAL(5,2) = CASE 
        WHEN @MembershipDuration > 0 THEN CAST(@ClassesCount AS FLOAT) / @MembershipDuration 
        ELSE 0 
    END;
    
    PRINT @FullName + ': ' + CAST(@ClassesCount AS NVARCHAR(3)) + ' занятий (' + 
          CAST(ROUND(@AvgClassesPerMonth, 1) AS NVARCHAR(10)) + ' в месяц)';
    
    FETCH NEXT FROM member_cursor INTO @MemberID, @FullName, @RegistrationDate, @ClassesCount;
END;

CLOSE member_cursor;
DEALLOCATE member_cursor;
GO