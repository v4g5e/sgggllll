CREATE TABLE Cinema_Original (
    session_id INT,
    film_title NVARCHAR(100),
    film_genres NVARCHAR(100),        -- ÍÀÐÓØÅÍÈÅ 1ÍÔ: íåñêîëüêî æàíðîâ
    film_duration INT,
    film_rating NVARCHAR(10),
    hall_number INT,
    hall_type NVARCHAR(20),
    hall_capacity INT,
    session_date DATE,
    session_time TIME,
    ticket_id INT,
    seat_row INT,
    seat_number INT,
    ticket_price MONEY,
    visitor_id INT,
    visitor_name NVARCHAR(100),
    visitor_phone NVARCHAR(50),       -- ÍÀÐÓØÅÍÈÅ 1ÍÔ: ìîæåò ñîäåðæàòü íåñêîëüêî íîìåðîâ
    visitor_email NVARCHAR(100),
    cashier_name NVARCHAR(100),
    cashier_shift NVARCHAR(20)
);

-- Ïðèìåð äàííûõ ñ íàðóøåíèÿìè 1ÍÔ
INSERT INTO Cinema_Original VALUES
(1, 'Àâàòàð: Ïóòü âîäû', 'Ôàíòàñòèêà, Ïðèêëþ÷åíèÿ', 192, '12+', 1, 'Standard', 150, '2024-03-25', '10:00', 101, 5, 12, 450.00, 1001, 'Èâàíîâ Èâàí', '+7-915-111-11-11, +7-495-123-45-67', 'ivanov@mail.ru', 'Ïåòðîâà Àííà', 'Óòðåííÿÿ'),
(1, 'Àâàòàð: Ïóòü âîäû', 'Ôàíòàñòèêà, Ïðèêëþ÷åíèÿ', 192, '12+', 1, 'Standard', 150, '2024-03-25', '10:00', 102, 5, 13, 450.00, 1002, 'Ñèäîðîâà Ìàðèÿ', '+7-916-222-22-22', 'sidorova@mail.ru', 'Ïåòðîâà Àííà', 'Óòðåííÿÿ'),
(2, 'Îïïåíãåéìåð', 'Äðàìà, Áèîãðàôèÿ', 180, '16+', 2, 'VIP', 80, '2024-03-25', '14:30', 201, 3, 5, 800.00, 1003, 'Êîçëîâ Ïåòð', '+7-917-333-33-33', 'kozlov@mail.ru', 'Ñìèðíîâ Äìèòðèé', 'Äíåâíàÿ');
-- ==========================================
-- ÝÒÀÏ 2: ÏÐÈÂÅÄÅÍÈÅ Ê 1ÍÔ
-- ==========================================

-- Òàáëèöà â 1ÍÔ ñ ðàçäåëåíèåì ñîñòàâíûõ çíà÷åíèé
CREATE TABLE Cinema_1NF (
    record_id INT IDENTITY(1,1) PRIMARY KEY,
    session_id INT,
    film_title NVARCHAR(100),
    film_genre NVARCHAR(50),          -- ÎÄÈÍ æàíð â çàïèñè
    film_duration INT,
    film_rating NVARCHAR(10),
    hall_number INT,
    hall_type NVARCHAR(20),
    hall_capacity INT,
    session_date DATE,
    session_time TIME,
    ticket_id INT,
    seat_row INT,
    seat_number INT,
    ticket_price MONEY,
    visitor_id INT,
    visitor_name NVARCHAR(100),
    visitor_phone NVARCHAR(20),       -- ÎÄÈÍ íîìåð òåëåôîíà
    visitor_email NVARCHAR(100),
    cashier_name NVARCHAR(100),
    cashier_shift NVARCHAR(20)
);

-- Äàííûå â 1ÍÔ (êàæäàÿ êîìáèíàöèÿ æàíð-òåëåôîí = îòäåëüíàÿ çàïèñü)
INSERT INTO Cinema_1NF VALUES
(1, 'Àâàòàð: Ïóòü âîäû', 'Ôàíòàñòèêà', 192, '12+', 1, 'Standard', 150, '2024-03-25', '10:00', 101, 5, 12, 450.00, 1001, 'Èâàíîâ Èâàí', '+7-915-111-11-11', 'ivanov@mail.ru', 'Ïåòðîâà Àííà', 'Óòðåííÿÿ'),
(1, 'Àâàòàð: Ïóòü âîäû', 'Ïðèêëþ÷åíèÿ', 192, '12+', 1, 'Standard', 150, '2024-03-25', '10:00', 101, 5, 12, 450.00, 1001, 'Èâàíîâ Èâàí', '+7-495-123-45-67', 'ivanov@mail.ru', 'Ïåòðîâà Àííà', 'Óòðåííÿÿ'),
(1, 'Àâàòàð: Ïóòü âîäû', 'Ôàíòàñòèêà', 192, '12+', 1, 'Standard', 150, '2024-03-25', '10:00', 102, 5, 13, 450.00, 1002, 'Ñèäîðîâà Ìàðèÿ', '+7-916-222-22-22', 'sidorova@mail.ru', 'Ïåòðîâà Àííà', 'Óòðåííÿÿ'),
(1, 'Àâàòàð: Ïóòü âîäû', 'Ïðèêëþ÷åíèÿ', 192, '12+', 1, 'Standard', 150, '2024-03-25', '10:00', 102, 5, 13, 450.00, 1002, 'Ñèäîðîâà Ìàðèÿ', '+7-916-222-22-22', 'sidorova@mail.ru', 'Ïåòðîâà Àííà', 'Óòðåííÿÿ'),
(2, 'Îïïåíãåéìåð', 'Äðàìà', 180, '16+', 2, 'VIP', 80, '2024-03-25', '14:30', 201, 3, 5, 800.00, 1003, 'Êîçëîâ Ïåòð', '+7-917-333-33-33', 'kozlov@mail.ru', 'Ñìèðíîâ Äìèòðèé', 'Äíåâíàÿ'),
(2, 'Îïïåíãåéìåð', 'Áèîãðàôèÿ', 180, '16+', 2, 'VIP', 80, '2024-03-25', '14:30', 201, 3, 5, 800.00, 1003, 'Êîçëîâ Ïåòð', '+7-917-333-33-33', 'kozlov@mail.ru', 'Ñìèðíîâ Äìèòðèé', 'Äíåâíàÿ');
-- ==========================================
-- ÝÒÀÏ 3: ÔÓÍÊÖÈÎÍÀËÜÍÛÅ ÇÀÂÈÑÈÌÎÑÒÈ
-- ==========================================

/*
ÂÛßÂËÅÍÍÛÅ ÔÓÍÊÖÈÎÍÀËÜÍÛÅ ÇÀÂÈÑÈÌÎÑÒÈ:

1. film_title ? film_duration, film_rating
2. hall_number ? hall_type, hall_capacity
3. session_id ? film_title, hall_number, session_date, session_time
4. ticket_id ? session_id, seat_row, seat_number, ticket_price, visitor_id
5. visitor_id ? visitor_name, visitor_email
6. visitor_phone ? visitor_id (êàæäûé òåëåôîí ïðèíàäëåæèò îäíîìó ïîñåòèòåëþ)
7. cashier_name ? cashier_shift

×ÀÑÒÈ×ÍÛÅ ÇÀÂÈÑÈÌÎÑÒÈ (íàðóøåíèÿ 2ÍÔ):
- Åñëè PK = (ticket_id, film_genre, visitor_phone), òî:
  - ticket_id ? session_id, seat_row, seat_number, ticket_price (çàâèñèò òîëüêî îò ÷àñòè êëþ÷à)
  - film_title ? film_duration, film_rating (çàâèñèò òîëüêî îò ÷àñòè êëþ÷à)
  - visitor_id ? visitor_name, email (çàâèñèò òîëüêî îò ÷àñòè êëþ÷à)

ÒÐÀÍÇÈÒÈÂÍÛÅ ÇÀÂÈÑÈÌÎÑÒÈ (íàðóøåíèÿ 3ÍÔ):
- hall_number ? hall_type, hall_capacity (÷åðåç session_id)
- film_title ? film_duration, film_rating (÷åðåç session_id)
- visitor_phone ? visitor_name, email (÷åðåç visitor_id)


-- 1. Ñïðàâî÷íèê ôèëüìîâ
CREATE TABLE Films (
    film_id INT IDENTITY(1,1) PRIMARY KEY,
    film_title NVARCHAR(100) NOT NULL,
    film_duration INT NOT NULL,
    film_rating NVARCHAR(10) NOT NULL CHECK (film_rating IN ('0+', '6+', '12+', '16+', '18+'))
);

-- 2. Ñïðàâî÷íèê æàíðîâ
CREATE TABLE Genres (
    genre_id INT IDENTITY(1,1) PRIMARY KEY,
    genre_name NVARCHAR(50) NOT NULL
);

-- 3. Ñâÿçü ôèëüìîâ è æàíðîâ (ìíîãèå êî ìíîãèì)
CREATE TABLE FilmGenres (
    film_id INT,
    genre_id INT,
    PRIMARY KEY (film_id, genre_id),
    FOREIGN KEY (film_id) REFERENCES Films(film_id),
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id)
);

-- 4. Ñïðàâî÷íèê çàëîâ
CREATE TABLE Halls (
    hall_id INT IDENTITY(1,1) PRIMARY KEY,
    hall_number INT NOT NULL UNIQUE,
    hall_type NVARCHAR(20) NOT NULL,
    hall_capacity INT NOT NULL CHECK (hall_capacity > 0)
);

-- 5. Òàáëèöà ñåàíñîâ
CREATE TABLE Sessions (
    session_id INT IDENTITY(1,1) PRIMARY KEY,
    film_id INT NOT NULL,
    hall_id INT NOT NULL,
    session_date DATE NOT NULL,
    session_time TIME NOT NULL,
    base_ticket_price MONEY NOT NULL CHECK (base_ticket_price >= 0),
    FOREIGN KEY (film_id) REFERENCES Films(film_id),
    FOREIGN KEY (hall_id) REFERENCES Halls(hall_id)
);

-- 6. Ñïðàâî÷íèê ïîñåòèòåëåé
CREATE TABLE Visitors (
    visitor_id INT IDENTITY(1,1) PRIMARY KEY,
    visitor_name NVARCHAR(100) NOT NULL,
    visitor_email NVARCHAR(100) NULL
);

-- 7. Òåëåôîíû ïîñåòèòåëåé (îäèí êî ìíîãèì)
CREATE TABLE VisitorPhones (
    phone_id INT IDENTITY(1,1) PRIMARY KEY,
    visitor_id INT NOT NULL,
    phone_number NVARCHAR(20) NOT NULL,
    FOREIGN KEY (visitor_id) REFERENCES Visitors(visitor_id)
);

-- 8. Ñïðàâî÷íèê êàññèðîâ
CREATE TABLE Cashiers (
    cashier_id INT IDENTITY(1,1) PRIMARY KEY,
    cashier_name NVARCHAR(100) NOT NULL,
    cashier_shift NVARCHAR(20) NOT NULL CHECK (cashier_shift IN ('Óòðåííÿÿ', 'Äíåâíàÿ', 'Âå÷åðíÿÿ'))
);

-- 9. Îñíîâíàÿ òàáëèöà áèëåòîâ (áåç èçáûòî÷íîñòè)
CREATE TABLE Tickets (
    ticket_id INT IDENTITY(1,1) PRIMARY KEY,
    session_id INT NOT NULL,
    seat_row INT NOT NULL CHECK (seat_row > 0),
    seat_number INT NOT NULL CHECK (seat_number > 0),
    ticket_price MONEY NOT NULL CHECK (ticket_price >= 0),
    visitor_id INT NOT NULL,
    cashier_id INT NOT NULL,
    purchase_datetime DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (session_id) REFERENCES Sessions(session_id),
    FOREIGN KEY (visitor_id) REFERENCES Visitors(visitor_id),
    FOREIGN KEY (cashier_id) REFERENCES Cashiers(cashier_id),
    CONSTRAINT UQ_Seat_Per_Session UNIQUE (session_id, seat_row, seat_number)
);


-- Çàïîëíåíèå ñïðàâî÷íèêîâ
INSERT INTO Films (film_title, film_duration, film_rating) VALUES 
('Àâàòàð: Ïóòü âîäû', 192, '12+'),
('Îïïåíãåéìåð', 180, '16+'),
('×åëîâåê-ïàóê: ×åðåç âñåëåííûå', 140, '6+'),
('Äæîí Óèê 4', 169, '18+');

INSERT INTO Genres (genre_name) VALUES 
('Ôàíòàñòèêà'),
('Ïðèêëþ÷åíèÿ'),
('Äðàìà'),
('Áèîãðàôèÿ'),
('Ìóëüòôèëüì'),
('Áîåâèê');

INSERT INTO FilmGenres (film_id, genre_id) VALUES 
(1, 1), (1, 2),  -- Àâàòàð: Ôàíòàñòèêà, Ïðèêëþ÷åíèÿ
(2, 3), (2, 4),  -- Îïïåíãåéìåð: Äðàìà, Áèîãðàôèÿ
(3, 5), (3, 1),  -- ×åëîâåê-ïàóê: Ìóëüòôèëüì, Ôàíòàñòèêà
(4, 6);          -- Äæîí Óèê: Áîåâèê

INSERT INTO Halls (hall_number, hall_type, hall_capacity) VALUES 
(1, 'Standard', 150),
(2, 'VIP', 80),
(3, 'IMAX', 120),
(4, 'Standard', 100);

INSERT INTO Sessions (film_id, hall_id, session_date, session_time, base_ticket_price) VALUES 
(1, 3, '2024-03-25', '10:00', 450.00),
(2, 1, '2024-03-25', '14:30', 350.00),
(3, 2, '2024-03-25', '18:00', 600.00),
(4, 1, '2024-03-25', '21:15', 400.00);

INSERT INTO Visitors (visitor_name, visitor_email) VALUES 
('Èâàíîâ Èâàí', 'ivanov@mail.ru'),
('Ñèäîðîâà Ìàðèÿ', 'sidorova@mail.ru'),
('Êîçëîâ Ïåòð', 'kozlov@mail.ru'),
('Íèêèòèíà Àííà', 'nikitina@mail.ru'),
('Ìîðîçîâ Äìèòðèé', 'morozov@mail.ru');

INSERT INTO VisitorPhones (visitor_id, phone_number) VALUES 
(1, '+7-915-111-11-11'),
(1, '+7-495-123-45-67'),
(2, '+7-916-222-22-22'),
(3, '+7-917-333-33-33'),
(4, '+7-918-444-44-44'),
(5, '+7-919-555-55-55');

INSERT INTO Cashiers (cashier_name, cashier_shift) VALUES 
('Ïåòðîâà Àííà', 'Óòðåííÿÿ'),
('Ñìèðíîâ Äìèòðèé', 'Äíåâíàÿ'),
('Êóçíåöîâà Îëüãà', 'Âå÷åðíÿÿ'),
('Âàñèëüåâ Ñåðãåé', 'Óòðåííÿÿ');

INSERT INTO Tickets (session_id, seat_row, seat_number, ticket_price, visitor_id, cashier_id) VALUES 
(1, 5, 12, 450.00, 1, 1),
(1, 5, 13, 450.00, 2, 1),
(2, 3, 5, 800.00, 3, 2),
(3, 7, 8, 600.00, 4, 3),
(4, 10, 15, 400.00, 5, 4);

-- ==========================================
-- ÊÎÍÒÐÎËÜÍÛÅ ÇÀÏÐÎÑÛ
-- ==========================================

-- 1. Âîññòàíîâëåíèå èñõîäíîãî ïðåäñòàâëåíèÿ
SELECT 
    s.session_id,
    f.film_title,
    STRING_AGG(g.genre_name, ', ') AS film_genres,
    f.film_duration,
    f.film_rating,
    h.hall_number,
    h.hall_type,
    h.hall_capacity,
    s.session_date,
    s.session_time,
    t.ticket_id,
    t.seat_row,
    t.seat_number,
    t.ticket_price,
    v.visitor_id,
    v.visitor_name,
    STRING_AGG(vp.phone_number, ', ') AS visitor_phones,
    v.visitor_email,
    c.cashier_name,
    c.cashier_shift
FROM Tickets t
    JOIN Sessions s ON t.session_id = s.session_id
    JOIN Films f ON s.film_id = f.film_id
    JOIN FilmGenres fg ON f.film_id = fg.film_id
    JOIN Genres g ON fg.genre_id = g.genre_id
    JOIN Halls h ON s.hall_id = h.hall_id
    JOIN Visitors v ON t.visitor_id = v.visitor_id
    JOIN VisitorPhones vp ON v.visitor_id = vp.visitor_id
    JOIN Cashiers c ON t.cashier_id = c.cashier_id
GROUP BY 
    s.session_id, f.film_title, f.film_duration, f.film_rating,
    h.hall_number, h.hall_type, h.hall_capacity, s.session_date, s.session_time,
    t.ticket_id, t.seat_row, t.seat_number, t.ticket_price,
    v.visitor_id, v.visitor_name, v.visitor_email,
    c.cashier_name, c.cashier_shift;

-- 2. Ñòàòèñòèêà ïî ïðîäàæàì áèëåòîâ ïî ôèëüìàì
SELECT 
    f.film_title,
    COUNT(t.ticket_id) AS tickets_sold,
    SUM(t.ticket_price) AS total_revenue,
    AVG(t.ticket_price) AS avg_ticket_price
FROM Films f
    JOIN Sessions s ON f.film_id = s.film_id
    JOIN Tickets t ON s.session_id = t.session_id
GROUP BY f.film_id, f.film_title
ORDER BY total_revenue DESC;

-- 3. Çàíÿòîñòü ìåñò ïî ñåàíñàì
SELECT 
    s.session_id,
    f.film_title,
    s.session_date,
    s.session_time,
    h.hall_number,
    COUNT(t.ticket_id) AS sold_tickets,
    h.hall_capacity - COUNT(t.ticket_id) AS free_seats,
    CAST(COUNT(t.ticket_id) * 100.0 / h.hall_capacity AS DECIMAL(5,2)) AS occupancy_percent
FROM Sessions s
    JOIN Films f ON s.film_id = f.film_id
    JOIN Halls h ON s.hall_id = h.hall_id
    LEFT JOIN Tickets t ON s.session_id = t.session_id
GROUP BY s.session_id, f.film_title, s.session_date, s.session_time, h.hall_number, h.hall_capacity
ORDER BY s.session_date, s.session_time;

-- 4. Ïîñåòèòåëè ñ ïîêóïêàìè äîðîæå 500 ðóáëåé
SELECT 
    v.visitor_name,
    v.visitor_email,
    STRING_AGG(vp.phone_number, ', ') AS phones,
    COUNT(t.ticket_id) AS tickets_bought,
    SUM(t.ticket_price) AS total_spent
FROM Visitors v
    JOIN VisitorPhones vp ON v.visitor_id = vp.visitor_id
    JOIN Tickets t ON v.visitor_id = t.visitor_id
GROUP BY v.visitor_id, v.visitor_name, v.visitor_email
HAVING SUM(t.ticket_price) > 500
ORDER BY total_spent DESC;