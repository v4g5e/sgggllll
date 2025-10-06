﻿CREATE TABLE Library_Original (
    book_id INT,
    book_title NVARCHAR(200),
    authors NVARCHAR(500),
    genres NVARCHAR(200),
    publisher_name NVARCHAR(100),
    publish_year INT,
    isbn NVARCHAR(20),
    reader_id INT,
    reader_name NVARCHAR(100),
    reader_phones NVARCHAR(100),
    reader_address NVARCHAR(200),
    issue_date DATE,
    return_date DATE,
    librarian_name NVARCHAR(100)
);

INSERT INTO Library_Original VALUES
(1, 'Война и мир', 'Толстой Л.Н.', 'Роман, Классика', 'АСТ', 2020, '978-5-17-123456-7', 101, 'Иванов И.И.', '+7-915-111-11-11, +7-495-123-45-67', 'Москва, ул. Ленина, 5', '2024-01-15', '2024-02-15', 'Петрова А.В.'),
(2, 'Мастер и Маргарита', 'Булгаков М.А.', 'Фантастика, Классика', 'Эксмо', 2019, '978-5-04-098765-4', 102, 'Петров П.П.', '+7-916-222-22-22', 'Санкт-Петербург, Невский пр., 20', '2024-01-20', '2024-02-20', 'Сидорова М.К.');

CREATE TABLE Library_1NF (
    record_id INT IDENTITY(1,1) PRIMARY KEY,
    book_id INT,
    book_title NVARCHAR(200),
    author NVARCHAR(100),
    genre NVARCHAR(50),
    publisher_name NVARCHAR(100),
    publish_year INT,
    isbn NVARCHAR(20),
    reader_id INT,
    reader_name NVARCHAR(100),
    reader_phone NVARCHAR(20),
    reader_address NVARCHAR(200),
    issue_date DATE,
    return_date DATE,
    librarian_name NVARCHAR(100)
);

INSERT INTO Library_1NF VALUES
(1, 'Война и мир', 'Толстой Л.Н.', 'Роман', 'АСТ', 2020, '978-5-17-123456-7', 101, 'Иванов И.И.', '+7-915-111-11-11', 'Москва, ул. Ленина, 5', '2024-01-15', '2024-02-15', 'Петрова А.В.'),
(1, 'Война и мир', 'Толстой Л.Н.', 'Классика', 'АСТ', 2020, '978-5-17-123456-7', 101, 'Иванов И.И.', '+7-495-123-45-67', 'Москва, ул. Ленина, 5', '2024-01-15', '2024-02-15', 'Петрова А.В.');

CREATE TABLE Books (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    book_title NVARCHAR(200) NOT NULL,
    publisher_name NVARCHAR(100) NOT NULL,
    publish_year INT NOT NULL,
    isbn NVARCHAR(20) UNIQUE
);

CREATE TABLE Authors (
    author_id INT IDENTITY(1,1) PRIMARY KEY,
    author_name NVARCHAR(100) NOT NULL
);

CREATE TABLE BookAuthors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

CREATE TABLE Genres (
    genre_id INT IDENTITY(1,1) PRIMARY KEY,
    genre_name NVARCHAR(50) NOT NULL
);

CREATE TABLE BookGenres (
    book_id INT,
    genre_id INT,
    PRIMARY KEY (book_id, genre_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id)
);

CREATE TABLE Readers (
    reader_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_name NVARCHAR(100) NOT NULL,
    address NVARCHAR(200) NOT NULL
);

CREATE TABLE ReaderPhones (
    phone_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    phone_number NVARCHAR(20) NOT NULL,
    FOREIGN KEY (reader_id) REFERENCES Readers(reader_id)
);

CREATE TABLE Librarians (
    librarian_id INT IDENTITY(1,1) PRIMARY KEY,
    librarian_name NVARCHAR(100) NOT NULL
);

CREATE TABLE BookIssues (
    issue_id INT IDENTITY(1,1) PRIMARY KEY,
    book_id INT NOT NULL,
    reader_id INT NOT NULL,
    librarian_id INT NOT NULL,
    issue_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (reader_id) REFERENCES Readers(reader_id),
    FOREIGN KEY (librarian_id) REFERENCES Librarians(librarian_id)
);

INSERT INTO Books VALUES ('Война и мир', 'АСТ', 2020, '978-5-17-123456-7'), ('Мастер и Маргарита', 'Эксмо', 2019, '978-5-04-098765-4');
INSERT INTO Authors VALUES ('Толстой Л.Н.'), ('Булгаков М.А.');
INSERT INTO BookAuthors VALUES (1,1), (2,2);
INSERT INTO Genres VALUES ('Роман'), ('Классика'), ('Фантастика');
INSERT INTO BookGenres VALUES (1,1), (1,2), (2,3), (2,2);
INSERT INTO Readers VALUES ('Иванов И.И.', 'Москва, ул. Ленина, 5'), ('Петров П.П.', 'Санкт-Петербург, Невский пр., 20');
INSERT INTO ReaderPhones VALUES (1,'+7-915-111-11-11'), (1,'+7-495-123-45-67'), (2,'+7-916-222-22-22');
INSERT INTO Librarians VALUES ('Петрова А.В.'), ('Сидорова М.К.');
INSERT INTO BookIssues VALUES (1,1,1,'2024-01-15','2024-02-15'), (2,2,2,'2024-01-20','2024-02-20');

SELECT b.book_title, STRING_AGG(a.author_name, ', ') as authors, COUNT(bi.issue_id) as total_issues
FROM Books b
JOIN BookAuthors ba ON b.book_id = ba.book_id
JOIN Authors a ON ba.author_id = a.author_id
JOIN BookIssues bi ON b.book_id = bi.book_id
GROUP BY b.book_id, b.book_title;