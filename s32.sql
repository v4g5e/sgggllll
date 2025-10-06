﻿CREATE TABLE Taxi_Original (
    order_id INT,
    order_datetime DATETIME,
    customer_name NVARCHAR(100),
    customer_phones NVARCHAR(100),
    pickup_address NVARCHAR(200),
    destination_address NVARCHAR(200),
    driver_name NVARCHAR(100),
    driver_phone NVARCHAR(20),
    car_model NVARCHAR(50),
    car_number NVARCHAR(15),
    tariff_name NVARCHAR(50),
    tariff_rate MONEY,
    distance_km DECIMAL(5,2),
    trip_duration_min INT,
    order_cost MONEY,
    payment_method NVARCHAR(20),
    order_status NVARCHAR(20)
);

INSERT INTO Taxi_Original VALUES
(1001, '2024-03-25 08:30:00', 'Иванов А.С.', '+7-915-123-45-67, +7-495-111-22-33', 'Москва, ул. Тверская, 15', 'Москва, Шереметьево аэропорт', 'Петров Д.М.', '+7-916-444-55-66', 'Kia Rio', 'А123ВС777', 'Эконом', 12.50, 25.5, 45, 318.75, 'Карта', 'Завершен'),
(1002, '2024-03-25 09:15:00', 'Сидорова М.К.', '+7-916-987-65-43', 'Москва, пр. Мира, 25', 'Москва, Киевский вокзал', 'Козлов С.П.', '+7-917-333-44-55', 'Hyundai Solaris', 'У456ОР777', 'Комфорт', 18.00, 8.2, 20, 147.60, 'Наличные', 'Завершен');

CREATE TABLE Taxi_1NF (
    record_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    order_datetime DATETIME,
    customer_name NVARCHAR(100),
    customer_phone NVARCHAR(20),
    pickup_address NVARCHAR(200),
    destination_address NVARCHAR(200),
    driver_name NVARCHAR(100),
    driver_phone NVARCHAR(20),
    car_model NVARCHAR(50),
    car_number NVARCHAR(15),
    tariff_name NVARCHAR(50),
    tariff_rate MONEY,
    distance_km DECIMAL(5,2),
    trip_duration_min INT,
    order_cost MONEY,
    payment_method NVARCHAR(20),
    order_status NVARCHAR(20)
);

INSERT INTO Taxi_1NF VALUES
(1001, '2024-03-25 08:30:00', 'Иванов А.С.', '+7-915-123-45-67', 'Москва, ул. Тверская, 15', 'Москва, Шереметьево аэропорт', 'Петров Д.М.', '+7-916-444-55-66', 'Kia Rio', 'А123ВС777', 'Эконом', 12.50, 25.5, 45, 318.75, 'Карта', 'Завершен'),
(1001, '2024-03-25 08:30:00', 'Иванов А.С.', '+7-495-111-22-33', 'Москва, ул. Тверская, 15', 'Москва, Шереметьево аэропорт', 'Петров Д.М.', '+7-916-444-55-66', 'Kia Rio', 'А123ВС777', 'Эконом', 12.50, 25.5, 45, 318.75, 'Карта', 'Завершен');

CREATE TABLE Customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_name NVARCHAR(100) NOT NULL
);

CREATE TABLE CustomerPhones (
    phone_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    phone_number NVARCHAR(20) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Drivers (
    driver_id INT IDENTITY(1,1) PRIMARY KEY,
    driver_name NVARCHAR(100) NOT NULL,
    driver_phone NVARCHAR(20) NOT NULL
);

CREATE TABLE Cars (
    car_id INT IDENTITY(1,1) PRIMARY KEY,
    car_model NVARCHAR(50) NOT NULL,
    car_number NVARCHAR(15) NOT NULL UNIQUE,
    driver_id INT NOT NULL,
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id)
);

CREATE TABLE Tariffs (
    tariff_id INT IDENTITY(1,1) PRIMARY KEY,
    tariff_name NVARCHAR(50) NOT NULL,
    tariff_rate MONEY NOT NULL
);

CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    driver_id INT NOT NULL,
    tariff_id INT NOT NULL,
    order_datetime DATETIME NOT NULL,
    pickup_address NVARCHAR(200) NOT NULL,
    destination_address NVARCHAR(200) NOT NULL,
    distance_km DECIMAL(5,2) NOT NULL,
    trip_duration_min INT NOT NULL,
    order_cost MONEY NOT NULL,
    payment_method NVARCHAR(20) NOT NULL,
    order_status NVARCHAR(20) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id),
    FOREIGN KEY (tariff_id) REFERENCES Tariffs(tariff_id)
);

INSERT INTO Customers VALUES ('Иванов А.С.'), ('Сидорова М.К.');
INSERT INTO CustomerPhones VALUES (1,'+7-915-123-45-67'), (1,'+7-495-111-22-33'), (2,'+7-916-987-65-43');
INSERT INTO Drivers VALUES ('Петров Д.М.', '+7-916-444-55-66'), ('Козлов С.П.', '+7-917-333-44-55');
INSERT INTO Cars VALUES ('Kia Rio', 'А123ВС777', 1), ('Hyundai Solaris', 'У456ОР777', 2);
INSERT INTO Tariffs VALUES ('Эконом', 12.50), ('Комфорт', 18.00), ('Бизнес', 25.00);
INSERT INTO Orders VALUES (1,1,1,'2024-03-25 08:30:00','Москва, ул. Тверская, 15','Москва, Шереметьево аэропорт',25.5,45,318.75,'Карта','Завершен'),
(2,2,2,'2024-03-25 09:15:00','Москва, пр. Мира, 25','Москва, Киевский вокзал',8.2,20,147.60,'Наличные','Завершен');

SELECT c.customer_name, cp.phone_number, COUNT(o.order_id) as total_orders, SUM(o.order_cost) as total_spent
FROM Customers c
JOIN CustomerPhones cp ON c.customer_id = cp.customer_id
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, cp.phone_number;