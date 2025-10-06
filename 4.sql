CREATE DATABASE PolyclinicDB;
USE PolyclinicDB;

CREATE TABLE Specializations (
    SpecializationID INT IDENTITY PRIMARY KEY,
    SpecializationName NVARCHAR(100) NOT NULL
);

CREATE TABLE Doctors (
    DoctorID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    SpecializationID INT FOREIGN KEY REFERENCES Specializations(SpecializationID),
    RoomNumber NVARCHAR(10),
    WorkSchedule NVARCHAR(100)
);

CREATE TABLE Patients (
    PatientID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BirthDate DATE,
    InsurancePolicy NVARCHAR(20),
    Phone NVARCHAR(20)
);

CREATE TABLE Appointments (
    AppointmentID INT IDENTITY PRIMARY KEY,
    PatientID INT FOREIGN KEY REFERENCES Patients(PatientID),
    DoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID),
    AppointmentDate DATETIME,
    Symptoms NVARCHAR(500),
    Diagnosis NVARCHAR(200),
    Recommendations NVARCHAR(500)
);

CREATE TABLE Referrals (
    ReferralID INT IDENTITY PRIMARY KEY,
    AppointmentID INT FOREIGN KEY REFERENCES Appointments(AppointmentID),
    ReferralType NVARCHAR(50), -- анализ, к специалисту и т.д.
    Description NVARCHAR(200),
    ReferralDate DATE
);

-- 1. Пациенты с наибольшим количеством посещений
SELECT p.FirstName, p.LastName, COUNT(a.AppointmentID) as VisitCount
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
GROUP BY p.PatientID, p.FirstName, p.LastName
HAVING COUNT(a.AppointmentID) > (
    SELECT AVG(CAST(VisitCount AS FLOAT)) FROM (
        SELECT COUNT(AppointmentID) as VisitCount 
        FROM Appointments 
        GROUP BY PatientID
    ) as temp
);

-- 2. Врачи без назначений на сегодня
SELECT FirstName, LastName, SpecializationName
FROM Doctors d
JOIN Specializations s ON d.SpecializationID = s.SpecializationID
WHERE NOT EXISTS (
    SELECT 1 FROM Appointments a 
    WHERE a.DoctorID = d.DoctorID 
    AND CAST(a.AppointmentDate AS DATE) = CAST(GETDATE() AS DATE)
);
GO