﻿CREATE TABLE Cleaning_Original (
    contract_id INT,
    client_name NVARCHAR(100),
    client_phones NVARCHAR(100),
    object_address NVARCHAR(200),
    object_type NVARCHAR(100),
    object_area_sqm DECIMAL(8,2),
    cleaning_types NVARCHAR(300),
    employee_names NVARCHAR(500),
    schedule_days NVARCHAR(100),
    work_hours NVARCHAR(50),
    monthly_cost MONEY,
    manager_name NVARCHAR(100)
);

INSERT INTO Cleaning_Original VALUES
(1, 'ООО ОфисГрад', '+7-495-111-22-33, +7-495-444-55-66', 'Москва, ул. Тверская, 25', 'Офисное помещение', 250.5, 'Ежедневная уборка, Генеральная уборка, Химчистка', 'Иванова М.П., Петров С.К., Сидорова А.В.', 'Пн-Пт', '18:00-21:00', 45000.00, 'Козлов Д.М.'),
(2, 'ТЦ Европейский', '+7-495-777-88-99', 'Москва, пл. Киевского Вокзала, 2', 'Торговый центр', 1500.0, 'Ежедневная уборка, Мытье полов, Уборка санузлов', 'Никитин В.С., Орлова Е.П., Васильев П.С., Морозова К.Д.', 'Ежедневно', '22:00-06:00', 120000.00, 'Козлов Д.М.');

CREATE TABLE Cleaning_1NF (
    record_id INT IDENTITY(1,1) PRIMARY KEY,
    contract_id INT,
    client_name NVARCHAR(100),
    client_phone NVARCHAR(20),
    object_address NVARCHAR(200),
    object_type NVARCHAR(100),
    object_area_sqm DECIMAL(8,2),
    cleaning_type NVARCHAR(100),
    employee_name NVARCHAR(100),
    schedule_day NVARCHAR(10),
    work_hours NVARCHAR(50),
    monthly_cost MONEY,
    manager_name NVARCHAR(100)
);

INSERT INTO Cleaning_1NF VALUES
(1, 'ООО ОфисГрад', '+7-495-111-22-33', 'Москва, ул. Тверская, 25', 'Офисное помещение', 250.5, 'Ежедневная уборка', 'Иванова М.П.', 'Пн', '18:00-21:00', 45000.00, 'Козлов Д.М.'),
(1, 'ООО ОфисГрад', '+7-495-444-55-66', 'Москва, ул. Тверская, 25', 'Офисное помещение', 250.5, 'Генеральная уборка', 'Петров С.К.', 'Вт', '18:00-21:00', 45000.00, 'Козлов Д.М.');

CREATE TABLE Clients (
    client_id INT IDENTITY(1,1) PRIMARY KEY,
    client_name NVARCHAR(100) NOT NULL
);

CREATE TABLE ClientPhones (
    phone_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT NOT NULL,
    phone_number NVARCHAR(20) NOT NULL,
    FOREIGN KEY (client_id) REFERENCES Clients(client_id)
);

CREATE TABLE Objects (
    object_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT NOT NULL,
    object_address NVARCHAR(200) NOT NULL,
    object_type NVARCHAR(100) NOT NULL,
    area_sqm DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (client_id) REFERENCES Clients(client_id)
);

CREATE TABLE CleaningTypes (
    type_id INT IDENTITY(1,1) PRIMARY KEY,
    type_name NVARCHAR(100) NOT NULL,
    price_per_sqm MONEY NOT NULL
);

CREATE TABLE Employees (
    employee_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_name NVARCHAR(100) NOT NULL
);

CREATE TABLE Contracts (
    contract_id INT IDENTITY(1,1) PRIMARY KEY,
    object_id INT NOT NULL,
    monthly_cost MONEY NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    manager_name NVARCHAR(100) NOT NULL,
    FOREIGN KEY (object_id) REFERENCES Objects(object_id)
);

CREATE TABLE ContractServices (
    contract_id INT,
    type_id INT,
    frequency NVARCHAR(50) NOT NULL,
    PRIMARY KEY (contract_id, type_id),
    FOREIGN KEY (contract_id) REFERENCES Contracts(contract_id),
    FOREIGN KEY (type_id) REFERENCES CleaningTypes(type_id)
);

CREATE TABLE WorkSchedules (
    schedule_id INT IDENTITY(1,1) PRIMARY KEY,
    contract_id INT NOT NULL,
    employee_id INT NOT NULL,
    day_of_week NVARCHAR(10) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (contract_id) REFERENCES Contracts(contract_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

INSERT INTO Clients VALUES ('ООО ОфисГрад'), ('ТЦ Европейский');
INSERT INTO ClientPhones VALUES (1,'+7-495-111-22-33'), (1,'+7-495-444-55-66'), (2,'+7-495-777-88-99');
INSERT INTO Objects VALUES (1,'Москва, ул. Тверская, 25','Офисное помещение',250.5), (2,'Москва, пл. Киевского Вокзала, 2','Торговый центр',1500.0);
INSERT INTO CleaningTypes VALUES ('Ежедневная уборка', 50.00), ('Генеральная уборка', 100.00), ('Химчистка', 150.00), ('Мытье полов', 40.00);
INSERT INTO Employees VALUES ('Иванова М.П.'), ('Петров С.К.'), ('Сидорова А.В.'), ('Никитин В.С.'), ('Орлова Е.П.');
INSERT INTO Contracts VALUES (1,45000.00,'2024-01-01','2024-12-31','Козлов Д.М.'), (2,120000.00,'2024-01-01','2024-12-31','Козлов Д.М.');
INSERT INTO ContractServices VALUES (1,1,'Ежедневно'), (1,2,'Ежемесячно'), (1,3,'Ежеквартально'), (2,1,'Ежедневно'), (2,4,'Ежедневно');
INSERT INTO WorkSchedules VALUES (1,1,'Пн','18:00','21:00'), (1,1,'Вт','18:00','21:00'), (1,2,'Ср','18:00','21:00'), (2,4,'Пн','22:00','06:00'), (2,5,'Вт','22:00','06:00');

SELECT c.client_name, o.object_address, COUNT(DISTINCT ws.employee_id) as employees_count, SUM(ct.monthly_cost) as total_revenue
FROM Clients c
JOIN Objects o ON c.client_id = o.client_id
JOIN Contracts ct ON o.object_id = ct.object_id
JOIN WorkSchedules ws ON ct.contract_id = ws.contract_id
GROUP BY c.client_id, c.client_name, o.object_address;