- ЭТАП 1: Исходная денормализованная таблица
CREATE TABLE Theater_Original (
    performance_id INT,
    performance_title NVARCHAR(100),
    performance_genres NVARCHAR(100),
    performance_duration INT,
    director_name NVARCHAR(100),
    actors_list NVARCHAR(500),
    hall_name NVARCHAR(50),
    hall_capacity INT,
    show_date DATE,
    show_time TIME,
    ticket_id INT,
    seat_sector NVARCHAR(20),
    seat_row INT,
    seat_number INT,
    ticket_price MONEY,
    visitor_id INT,
    visitor_name NVARCHAR(100),
    visitor_phone NVARCHAR(50),
    visitor_email NVARCHAR(100),
    cashier_name NVARCHAR(100)
);

INSERT INTO Theater_Original VALUES
(1, 'Лебединое озеро', 'Балет, Классика', 120, 'Петров А.В.', 'Иванова М.П., Сидоров К.Л., Козлова А.С.', 'Большой зал', 300, '2024-04-10', '19:00', 101, 'Партер', 5, 12, 2500.00, 1001, 'Смирнов И.И.', '+7-915-111-11-11', 'smirnov@mail.ru', 'Никитина О.П.'),
(1, 'Лебединое озеро', 'Балет, Классика', 120, 'Петров А.В.', 'Иванова М.П., Сидоров К.Л., Козлова А.С.', 'Большой зал', 300, '2024-04-10', '19:00', 102, 'Бельэтаж', 3, 5, 1800.00, 1002, 'Орлова М.К.', '+7-916-222-22-22', 'orlova@mail.ru', 'Никитина О.П.');

-- ЭТАП 2: 1НФ
CREATE TABLE Theater_1NF (
    record_id INT IDENTITY(1,1) PRIMARY KEY,
    performance_id INT,
    performance_title NVARCHAR(100),
    performance_genre NVARCHAR(50),
    performance_duration INT,
    director_name NVARCHAR(100),
    actor_name NVARCHAR(100),
    hall_name NVARCHAR(50),
    hall_capacity INT,
    show_date DATE,
    show_time TIME,
    ticket_id INT,
    seat_sector NVARCHAR(20),
    seat_row INT,
    seat_number INT,
    ticket_price MONEY,
    visitor_id INT,
    visitor_name NVARCHAR(100),
    visitor_phone NVARCHAR(20),
    visitor_email NVARCHAR(100),
    cashier_name NVARCHAR(100)
);

INSERT INTO Theater_1NF VALUES
(1, 'Лебединое озеро', 'Балет', 120, 'Петров А.В.', 'Иванова М.П.', 'Большой зал', 300, '2024-04-10', '19:00', 101, 'Партер', 5, 12, 2500.00, 1001, 'Смирнов И.И.', '+7-915-111-11-11', 'smirnov@mail.ru', 'Никитина О.П.'),
(1, 'Лебединое озеро', 'Классика', 120, 'Петров А.В.', 'Иванова М.П.', 'Большой зал', 300, '2024-04-10', '19:00', 101, 'Партер', 5, 12, 2500.00, 1001, 'Смирнов И.И.', '+7-915-111-11-11', 'smirnov@mail.ru', 'Никитина О.П.');

-- ЭТАП 4: 3НФ
CREATE TABLE Performances (
    performance_id INT IDENTITY(1,1) PRIMARY KEY,
    performance_title NVARCHAR(100) NOT NULL,
    performance_duration INT NOT NULL,
    director_name NVARCHAR(100) NOT NULL
);

CREATE TABLE Genres (
    genre_id INT IDENTITY(1,1) PRIMARY KEY,
    genre_name NVARCHAR(50) NOT NULL
);

CREATE TABLE PerformanceGenres (
    performance_id INT,
    genre_id INT,
    PRIMARY KEY (performance_id, genre_id),
    FOREIGN KEY (performance_id) REFERENCES Performances(performance_id),
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id)
);

CREATE TABLE Actors (
    actor_id INT IDENTITY(1,1) PRIMARY KEY,
    actor_name NVARCHAR(100) NOT NULL
);

CREATE TABLE PerformanceActors (
    performance_id INT,
    actor_id INT,
    role_name NVARCHAR(100),
    PRIMARY KEY (performance_id, actor_id),
    FOREIGN KEY (performance_id) REFERENCES Performances(performance_id),
    FOREIGN KEY (actor_id) REFERENCES Actors(actor_id)
);

CREATE TABLE Halls (
    hall_id INT IDENTITY(1,1) PRIMARY KEY,
    hall_name NVARCHAR(50) NOT NULL,
    hall_capacity INT NOT NULL
);

CREATE TABLE Shows (
    show_id INT IDENTITY(1,1) PRIMARY KEY,
    performance_id INT NOT NULL,
    hall_id INT NOT NULL,
    show_date DATE NOT NULL,
    show_time TIME NOT NULL,
    FOREIGN KEY (performance_id) REFERENCES Performances(performance_id),
    FOREIGN KEY (hall_id) REFERENCES Halls(hall_id)
);

CREATE TABLE Visitors (
    visitor_id INT IDENTITY(1,1) PRIMARY KEY,
    visitor_name NVARCHAR(100) NOT NULL,
    visitor_email NVARCHAR(100)
);

CREATE TABLE VisitorPhones (
    phone_id INT IDENTITY(1,1) PRIMARY KEY,
    visitor_id INT NOT NULL,
    phone_number NVARCHAR(20) NOT NULL,
    FOREIGN KEY (visitor_id) REFERENCES Visitors(visitor_id)
);

CREATE TABLE Cashiers (
    cashier_id INT IDENTITY(1,1) PRIMARY KEY,
    cashier_name NVARCHAR(100) NOT NULL
);

CREATE TABLE Tickets (
    ticket_id INT IDENTITY(1,1) PRIMARY KEY,
    show_id INT NOT NULL,
    seat_sector NVARCHAR(20) NOT NULL,
    seat_row INT NOT NULL,
    seat_number INT NOT NULL,
    ticket_price MONEY NOT NULL,
    visitor_id INT NOT NULL,
    cashier_id INT NOT NULL,
    FOREIGN KEY (show_id) REFERENCES Shows(show_id),
    FOREIGN KEY (visitor_id) REFERENCES Visitors(visitor_id),
    FOREIGN KEY (cashier_id) REFERENCES Cashiers(cashier_id)
);

-- Заполнение данными
INSERT INTO Performances VALUES ('Лебединое озеро', 120, 'Петров А.В.'), ('Щелкунчик', 110, 'Сидорова М.К.');
INSERT INTO Genres VALUES ('Балет'), ('Классика'), ('Драма');
INSERT INTO PerformanceGenres VALUES (1,1), (1,2), (2,1), (2,2);
INSERT INTO Actors VALUES ('Иванова М.П.'), ('Сидоров К.Л.'), ('Козлова А.С.');
INSERT INTO PerformanceActors VALUES (1,1, 'Одетта'), (1,2, 'Принц'), (2,3, 'Мари');
INSERT INTO Halls VALUES ('Большой зал', 300), ('Малый зал', 150);
INSERT INTO Shows VALUES (1,1,'2024-04-10','19:00'), (2,2,'2024-04-12','18:30');
INSERT INTO Visitors VALUES ('Смирнов И.И.', 'smirnov@mail.ru'), ('Орлова М.К.', 'orlova@mail.ru');
INSERT INTO VisitorPhones VALUES (1,'+7-915-111-11-11'), (2,'+7-916-222-22-22');
INSERT INTO Cashiers VALUES ('Никитина О.П.'), ('Васильев П.С.');
INSERT INTO Tickets VALUES (1,'Партер',5,12,2500.00,1,1), (1,'Бельэтаж',3,5,1800.00,2,1);

-- Контрольные запросы
SELECT p.performance_title, STRING_AGG(g.genre_name, ', ') as genres, COUNT(t.ticket_id) as tickets_sold
FROM Performances p
JOIN PerformanceGenres pg ON p.performance_id = pg.performance_id
JOIN Genres g ON pg.genre_id = g.genre_id
JOIN Shows s ON p.performance_id = s.performance_id
JOIN Tickets t ON s.show_id = t.show_id
GROUP BY p.performance_id, p.performance_title;