﻿CREATE DATABASE KindergartenDB;
USE KindergartenDB;

CREATE TABLE Groups (
    GroupID INT IDENTITY PRIMARY KEY,
    GroupName NVARCHAR(20) NOT NULL,
    AgeCategory NVARCHAR(20),
    Capacity INT,
    RoomNumber NVARCHAR(10)
);

CREATE TABLE Teachers (
    TeacherID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    Qualification NVARCHAR(100),
    HireDate DATE
);

CREATE TABLE Children (
    ChildID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BirthDate DATE NOT NULL,
    GroupID INT FOREIGN KEY REFERENCES Groups(GroupID),
    AdmissionDate DATE,
    MedicalInfo NVARCHAR(500)
);

CREATE TABLE Parents (
    ParentID INT IDENTITY PRIMARY KEY,
    ChildID INT FOREIGN KEY REFERENCES Children(ChildID),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100),
    Relationship NVARCHAR(20)
);

CREATE TABLE Activities (
    ActivityID INT IDENTITY PRIMARY KEY,
    ActivityName NVARCHAR(100) NOT NULL,
    TeacherID INT FOREIGN KEY REFERENCES Teachers(TeacherID),
    GroupID INT FOREIGN KEY REFERENCES Groups(GroupID),
    ActivityDate DATE,
    StartTime TIME,
    EndTime TIME,
    Description NVARCHAR(500)
);

-- 1. Группы с количеством детей выше среднего
SELECT GroupName, COUNT(ChildID) as ChildrenCount
FROM Groups g
JOIN Children c ON g.GroupID = c.GroupID
GROUP BY g.GroupID, g.GroupName
HAVING COUNT(ChildID) > (
    SELECT AVG(CAST(ChildrenCount AS FLOAT)) FROM (
        SELECT COUNT(ChildID) as ChildrenCount 
        FROM Children 
        GROUP BY GroupID
    ) as temp
);

-- 2. Воспитатели с наибольшим количеством занятий
SELECT FirstName, LastName, COUNT(ActivityID) as ActivitiesCount
FROM Teachers t
JOIN Activities a ON t.TeacherID = a.TeacherID
GROUP BY t.TeacherID, t.FirstName, t.LastName
ORDER BY ActivitiesCount DESC;

-- КУРСОР ДЛЯ РАСЧЕТА ВОЗРАСТА ДЕТЕЙ
DECLARE @ChildID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @BirthDate DATE, @Age INT;
DECLARE children_cursor CURSOR FOR
SELECT ChildID, FirstName, LastName, BirthDate, 
       DATEDIFF(MONTH, BirthDate, GETDATE()) / 12 as Age
FROM Children;

OPEN children_cursor;
FETCH NEXT FROM children_cursor INTO @ChildID, @FirstName, @LastName, @BirthDate, @Age;

PRINT 'ВОЗРАСТ ДЕТЕЙ В ДЕТСКОМ САДУ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @LastName + ' ' + @FirstName + ': ' + CAST(@Age AS NVARCHAR(3)) + ' лет';
    FETCH NEXT FROM children_cursor INTO @ChildID, @FirstName, @LastName, @BirthDate, @Age;
END;

CLOSE children_cursor;
DEALLOCATE children_cursor;
GO