CREATE DATABASE SchoolDB;
USE SchoolDB;

CREATE TABLE Classes (
    ClassID INT IDENTITY PRIMARY KEY,
    ClassName NVARCHAR(20) NOT NULL,
    ClassTeacherID INT,
    RoomNumber NVARCHAR(10)
);

CREATE TABLE Subjects (
    SubjectID INT IDENTITY PRIMARY KEY,
    SubjectName NVARCHAR(50) NOT NULL,
    HoursPerWeek INT
);

CREATE TABLE Teachers (
    TeacherID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    HireDate DATE,
    SubjectID INT
);

CREATE TABLE Students (
    StudentID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BirthDate DATE,
    ClassID INT FOREIGN KEY REFERENCES Classes(ClassID),
    Address NVARCHAR(200)
);

CREATE TABLE Schedule (
    ScheduleID INT IDENTITY PRIMARY KEY,
    ClassID INT FOREIGN KEY REFERENCES Classes(ClassID),
    SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID),
    TeacherID INT FOREIGN KEY REFERENCES Teachers(TeacherID),
    DayOfWeek INT CHECK (DayOfWeek BETWEEN 1 AND 7),
    LessonNumber INT,
    Room NVARCHAR(10)
);

CREATE TABLE Grades (
    GradeID INT IDENTITY PRIMARY KEY,
    StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
    SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID),
    Grade INT CHECK (Grade BETWEEN 1 AND 12),
    GradeDate DATE,
    Semester INT
);

-- Заполнение тестовыми данными
INSERT INTO Classes VALUES ('10-А', 1, '201'), ('10-Б', 2, '202'), ('11-А', 3, '301');
INSERT INTO Subjects VALUES ('Математика', 5), ('Физика', 4), ('Химия', 3), ('Литература', 4);
INSERT INTO Teachers VALUES ('Иван', 'Петров', '+79001112233', '2010-09-01', 1);
INSERT INTO Students VALUES ('Анна', 'Сидорова', '2006-05-15', 1, 'ул. Ленина 10');

-- 1. Скалярный подзапрос: ученики с оценкой выше среднего по математике
SELECT FirstName, LastName, Grade
FROM Students s
JOIN Grades g ON s.StudentID = g.StudentID
WHERE g.SubjectID = 1 AND g.Grade > (
    SELECT AVG(Grade) FROM Grades WHERE SubjectID = 1
);

-- 2. EXISTS: учителя, которые ведут занятия в 10-А классе
SELECT FirstName, LastName FROM Teachers t
WHERE EXISTS (
    SELECT 1 FROM Schedule s 
    WHERE s.TeacherID = t.TeacherID AND s.ClassID = 1
);

-- Курсор для расчета среднего балла по классам
DECLARE @ClassID INT, @ClassName NVARCHAR(20), @AvgGrade FLOAT;
DECLARE class_cursor CURSOR FOR
SELECT c.ClassID, c.ClassName, AVG(CAST(g.Grade AS FLOAT))
FROM Classes c
JOIN Students s ON c.ClassID = s.ClassID
JOIN Grades g ON s.StudentID = g.StudentID
GROUP BY c.ClassID, c.ClassName;

OPEN class_cursor;
FETCH NEXT FROM class_cursor INTO @ClassID, @ClassName, @AvgGrade;
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Класс: ' + @ClassName + ', Средний балл: ' + CAST(@AvgGrade AS NVARCHAR(10));
    FETCH NEXT FROM class_cursor INTO @ClassID, @ClassName, @AvgGrade;
END
CLOSE class_cursor;
DEALLOCATE class_cursor;
GO