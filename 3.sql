CREATE DATABASE HospitalDB;
USE HospitalDB;

CREATE TABLE Departments (
    DepartmentID INT IDENTITY PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL,
    HeadDoctorID INT
);

CREATE TABLE Doctors (
    DoctorID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Specialization NVARCHAR(100),
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID),
    Phone NVARCHAR(20)
);

CREATE TABLE Wards (
    WardID INT IDENTITY PRIMARY KEY,
    WardNumber NVARCHAR(10) NOT NULL,
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID),
    BedsCount INT,
    OccupiedBeds INT
);

CREATE TABLE Patients (
    PatientID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BirthDate DATE,
    Address NVARCHAR(200),
    Phone NVARCHAR(20)
);

CREATE TABLE Hospitalizations (
    HospitalizationID INT IDENTITY PRIMARY KEY,
    PatientID INT FOREIGN KEY REFERENCES Patients(PatientID),
    DoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID),
    WardID INT FOREIGN KEY REFERENCES Wards(WardID),
    Diagnosis NVARCHAR(200),
    AdmissionDate DATE,
    DischargeDate DATE,
    Status NVARCHAR(20)
);

-- 1. Врачи с количеством пациентов выше среднего
SELECT d.FirstName, d.LastName, COUNT(h.PatientID) as PatientCount
FROM Doctors d
JOIN Hospitalizations h ON d.DoctorID = h.DoctorID
GROUP BY d.DoctorID, d.FirstName, d.LastName
HAVING COUNT(h.PatientID) > (
    SELECT AVG(PatientCount) FROM (
        SELECT COUNT(PatientID) as PatientCount 
        FROM Hospitalizations 
        GROUP BY DoctorID
    ) as temp
);

-- 2. Палаты с свободными местами
SELECT WardNumber, BedsCount - OccupiedBeds as FreeBeds
FROM Wards
WHERE BedsCount - OccupiedBeds > 0;
GO