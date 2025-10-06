﻿CREATE DATABASE NursingHomeDB;
USE NursingHomeDB;

CREATE TABLE Residents (
    ResidentID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BirthDate DATE NOT NULL,
    RoomNumber NVARCHAR(10),
    AdmissionDate DATE,
    CareLevel NVARCHAR(20) CHECK (CareLevel IN ('Low', 'Medium', 'High', 'Special')),
    MedicalConditions NVARCHAR(500)
);

CREATE TABLE Staff (
    StaffID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Position NVARCHAR(50) CHECK (Position IN ('Nurse', 'Caregiver', 'Doctor', 'Administrator', 'Cleaner')),
    Phone NVARCHAR(20),
    HireDate DATE,
    Shift NVARCHAR(20)
);

CREATE TABLE Services (
    ServiceID INT IDENTITY PRIMARY KEY,
    ServiceName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    Cost DECIMAL(8,2),
    Duration INT -- в минутах
);

CREATE TABLE Relatives (
    RelativeID INT IDENTITY PRIMARY KEY,
    ResidentID INT FOREIGN KEY REFERENCES Residents(ResidentID),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Relationship NVARCHAR(20),
    Phone NVARCHAR(20) NOT NULL,
    VisitFrequency NVARCHAR(20)
);

CREATE TABLE MedicalRecords (
    RecordID INT IDENTITY PRIMARY KEY,
    ResidentID INT FOREIGN KEY REFERENCES Residents(ResidentID),
    StaffID INT FOREIGN KEY REFERENCES Staff(StaffID),
    ServiceID INT FOREIGN KEY REFERENCES Services(ServiceID),
    RecordDate DATETIME DEFAULT GETDATE(),
    Description NVARCHAR(1000),
    Medications NVARCHAR(500),
    NextAppointment DATE
);

-- 1. Постояльцы с наибольшим количеством медицинских процедур
SELECT r.FirstName, r.LastName, COUNT(mr.RecordID) as ProceduresCount
FROM Residents r
JOIN MedicalRecords mr ON r.ResidentID = mr.ResidentID
GROUP BY r.ResidentID, r.FirstName, r.LastName
HAVING COUNT(mr.RecordID) > (
    SELECT AVG(CAST(ProceduresCount AS FLOAT)) FROM (
        SELECT COUNT(RecordID) as ProceduresCount 
        FROM MedicalRecords 
        GROUP BY ResidentID
    ) as temp
);

-- 2. Персонал с высокой нагрузкой
SELECT FirstName, LastName, Position, COUNT(RecordID) as Workload
FROM Staff s
JOIN MedicalRecords mr ON s.StaffID = mr.StaffID
GROUP BY s.StaffID, s.FirstName, s.LastName, s.Position
HAVING COUNT(RecordID) > 10;

-- КУРСОР ДЛЯ РАСЧЕТА ВОЗРАСТА ПОСТОЯЛЬЦЕВ
DECLARE @ResidentID INT, @FullName NVARCHAR(100), @Age INT, @CareLevel NVARCHAR(20);
DECLARE residents_cursor CURSOR FOR
SELECT ResidentID, FirstName + ' ' + LastName, 
       DATEDIFF(YEAR, BirthDate, GETDATE()), CareLevel
FROM Residents;

OPEN residents_cursor;
FETCH NEXT FROM residents_cursor INTO @ResidentID, @FullName, @Age, @CareLevel;

PRINT 'ВОЗРАСТ ПОСТОЯЛЬЦЕВ ДОМА ПРЕСТАРЕЛЫХ';
PRINT '=====================================';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @FullName + ' (' + CAST(@Age AS NVARCHAR(3)) + ' лет) - Уровень ухода: ' + @CareLevel;
    FETCH NEXT FROM residents_cursor INTO @ResidentID, @FullName, @Age, @CareLevel;
END;

CLOSE residents_cursor;
DEALLOCATE residents_cursor;
GO