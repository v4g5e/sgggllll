﻿CREATE TABLE PhotoStudio_Original (
    shooting_id INT,
    client_name NVARCHAR(100),
    client_phones NVARCHAR(100),
    client_email NVARCHAR(100),
    shooting_type NVARCHAR(100),
    photographer_name NVARCHAR(100),
    photographer_specializations NVARCHAR(200),
    shooting_date DATE,
    shooting_duration_hours INT,
    services_list NVARCHAR(500),
    total_cost MONEY,
    studio_room NVARCHAR(50),
    equipment_used NVARCHAR(300)
);

INSERT INTO PhotoStudio_Original VALUES
(1, 'Иванова Мария', '+7-915-111-22-33, +7-495-444-55-66', 'ivanova@mail.ru', 'Свадебная фотосессия, Love Story', 'Петров А.С.', 'Свадебная фотография, Портретная съемка', '2024-03-25', 3, 'Фотосъемка 2 часа, Обработка 50 фото, Печать альбома', 15000.00, 'Студия А', 'Canon EOS R5, Объектив 85mm, Софтбоксы'),
(2, 'Сидоров Кирилл', '+7-916-777-88-99', 'sidorov@mail.ru', 'Бизнес-портрет', 'Козлова Е.В.', 'Портретная съемка, Предметная съемка', '2024-03-26', 1, 'Фотосъемка 1 час, Ретушь 10 фото', 5000.00, 'Студия Б', 'Sony A7III, Объектив 50mm');

CREATE TABLE PhotoStudio_1NF (
    record_id INT IDENTITY(1,1) PRIMARY KEY,
    shooting_id INT,
    client_name NVARCHAR(100),
    client_phone NVARCHAR(20),
    client_email NVARCHAR(100),
    shooting_type NVARCHAR(50),
    photographer_name NVARCHAR(100),
    photographer_specialization NVARCHAR(100),
    shooting_date DATE,
    shooting_duration_hours INT,
    service_name NVARCHAR(100),
    total_cost MONEY,
    studio_room NVARCHAR(50),
    equipment_item NVARCHAR(100)
);

INSERT INTO PhotoStudio_1NF VALUES
(1, 'Иванова Мария', '+7-915-111-22-33', 'ivanova@mail.ru', 'Свадебная фотосессия', 'Петров А.С.', 'Свадебная фотография', '2024-03-25', 3, 'Фотосъемка 2 часа', 15000.00, 'Студия А', 'Canon EOS R5'),
(1, 'Иванова Мария', '+7-495-444-55-66', 'ivanova@mail.ru', 'Love Story', 'Петров А.С.', 'Портретная съемка', '2024-03-25', 3, 'Обработка 50 фото', 15000.00, 'Студия А', 'Объектив 85mm');

CREATE TABLE Clients (
    client_id INT IDENTITY(1,1) PRIMARY KEY,
    client_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100)
);

CREATE TABLE ClientPhones (
    phone_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT NOT NULL,
    phone_number NVARCHAR(20) NOT NULL,
    FOREIGN KEY (client_id) REFERENCES Clients(client_id)
);

CREATE TABLE Photographers (
    photographer_id INT IDENTITY(1,1) PRIMARY KEY,
    photographer_name NVARCHAR(100) NOT NULL
);

CREATE TABLE Specializations (
    specialization_id INT IDENTITY(1,1) PRIMARY KEY,
    specialization_name NVARCHAR(100) NOT NULL
);

CREATE TABLE PhotographerSpecializations (
    photographer_id INT,
    specialization_id INT,
    PRIMARY KEY (photographer_id, specialization_id),
    FOREIGN KEY (photographer_id) REFERENCES Photographers(photographer_id),
    FOREIGN KEY (specialization_id) REFERENCES Specializations(specialization_id)
);

CREATE TABLE ShootingTypes (
    type_id INT IDENTITY(1,1) PRIMARY KEY,
    type_name NVARCHAR(50) NOT NULL
);

CREATE TABLE Services (
    service_id INT IDENTITY(1,1) PRIMARY KEY,
    service_name NVARCHAR(100) NOT NULL,
    base_price MONEY NOT NULL
);

CREATE TABLE Equipment (
    equipment_id INT IDENTITY(1,1) PRIMARY KEY,
    equipment_name NVARCHAR(100) NOT NULL
);

CREATE TABLE Shootings (
    shooting_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT NOT NULL,
    photographer_id INT NOT NULL,
    type_id INT NOT NULL,
    shooting_date DATE NOT NULL,
    duration_hours INT NOT NULL,
    studio_room NVARCHAR(50) NOT NULL,
    total_cost MONEY NOT NULL,
    FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    FOREIGN KEY (photographer_id) REFERENCES Photographers(photographer_id),
    FOREIGN KEY (type_id) REFERENCES ShootingTypes(type_id)
);

CREATE TABLE ShootingServices (
    shooting_id INT,
    service_id INT,
    quantity INT NOT NULL,
    PRIMARY KEY (shooting_id, service_id),
    FOREIGN KEY (shooting_id) REFERENCES Shootings(shooting_id),
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);

CREATE TABLE ShootingEquipment (
    shooting_id INT,
    equipment_id INT,
    PRIMARY KEY (shooting_id, equipment_id),
    FOREIGN KEY (shooting_id) REFERENCES Shootings(shooting_id),
    FOREIGN KEY (equipment_id) REFERENCES Equipment(equipment_id)
);

INSERT INTO Clients VALUES ('Иванова Мария', 'ivanova@mail.ru'), ('Сидоров Кирилл', 'sidorov@mail.ru');
INSERT INTO ClientPhones VALUES (1,'+7-915-111-22-33'), (1,'+7-495-444-55-66'), (2,'+7-916-777-88-99');
INSERT INTO Photographers VALUES ('Петров А.С.'), ('Козлова Е.В.');
INSERT INTO Specializations VALUES ('Свадебная фотография'), ('Портретная съемка'), ('Предметная съемка');
INSERT INTO PhotographerSpecializations VALUES (1,1), (1,2), (2,2), (2,3);
INSERT INTO ShootingTypes VALUES ('Свадебная фотосессия'), ('Love Story'), ('Бизнес-портрет');
INSERT INTO Services VALUES ('Фотосъемка', 5000.00), ('Обработка фото', 100.00), ('Печать альбома', 3000.00);
INSERT INTO Equipment VALUES ('Canon EOS R5'), ('Sony A7III'), ('Объектив 85mm'), ('Объектив 50mm'), ('Софтбоксы');
INSERT INTO Shootings VALUES (1,1,1,'2024-03-25',3,'Студия А',15000.00), (2,2,3,'2024-03-26',1,'Студия Б',5000.00);
INSERT INTO ShootingServices VALUES (1,1,2), (1,2,50), (1,3,1), (2,1,1), (2,2,10);
INSERT INTO ShootingEquipment VALUES (1,1), (1,3), (1,5), (2,2), (2,4);

SELECT c.client_name, p.photographer_name, COUNT(s.shooting_id) as shootings_count, SUM(s.total_cost) as total_revenue
FROM Clients c
JOIN Shootings s ON c.client_id = s.client_id
JOIN Photographers p ON s.photographer_id = p.photographer_id
GROUP BY c.client_id, c.client_name, p.photographer_name;