CREATE DATABASE LibraryDB;
USE LibraryDB;

CREATE TABLE Authors (
    AuthorID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    BirthYear INT
);

CREATE TABLE Categories (
    CategoryID INT IDENTITY PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL
);

CREATE TABLE Books (
    BookID INT IDENTITY PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    AuthorID INT FOREIGN KEY REFERENCES Authors(AuthorID),
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID),
    ISBN NVARCHAR(20),
    PublicationYear INT,
    TotalCopies INT,
    AvailableCopies INT
);

CREATE TABLE Readers (
    ReaderID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    RegistrationDate DATE
);

CREATE TABLE BookLoans (
    LoanID INT IDENTITY PRIMARY KEY,
    BookID INT FOREIGN KEY REFERENCES Books(BookID),
    ReaderID INT FOREIGN KEY REFERENCES Readers(ReaderID),
    LoanDate DATE NOT NULL,
    ReturnDate DATE,
    DueDate DATE NOT NULL
);

-- 1. Книги, которые никогда не брались (NOT EXISTS)
SELECT Title FROM Books b
WHERE NOT EXISTS (
    SELECT 1 FROM BookLoans bl WHERE bl.BookID = b.BookID
);

-- 2. Читатели с просроченными книгами
SELECT FirstName, LastName, Title, DueDate
FROM Readers r
JOIN BookLoans bl ON r.ReaderID = bl.ReaderID
JOIN Books b ON bl.BookID = b.BookID
WHERE bl.ReturnDate IS NULL AND bl.DueDate < GETDATE();

-- КУРСОР ДЛЯ ОБНОВЛЕНИЯ СТАТУСА КНИГ
DECLARE @BookID INT, @AvailableCopies INT;
DECLARE book_cursor CURSOR FOR
SELECT b.BookID, b.TotalCopies - COUNT(bl.LoanID)
FROM Books b
LEFT JOIN BookLoans bl ON b.BookID = bl.BookID AND bl.ReturnDate IS NULL
GROUP BY b.BookID, b.TotalCopies;

OPEN book_cursor;
FETCH NEXT FROM book_cursor INTO @BookID, @AvailableCopies;
WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Books SET AvailableCopies = @AvailableCopies WHERE BookID = @BookID;
    FETCH NEXT FROM book_cursor INTO @BookID, @AvailableCopies;
END
CLOSE book_cursor;
DEALLOCATE book_cursor;
GO