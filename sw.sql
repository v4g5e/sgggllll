CREATE TABLE Delivery_Original (
    order_id INT,
    customer_name NVARCHAR(100),
    customer_phones NVARCHAR(100),
    pickup_address NVARCHAR(200),
    delivery_address NVARCHAR(200),
    recipient_name NVARCHAR(100),
    recipient_phone NVARCHAR(20),
    package_types NVARCHAR(200),
    package_weight_kg DECIMAL(5,2),
    courier_name NVARCHAR(100),
    courier_phone NVARCHAR(20),
    vehicle_type NVARCHAR(50),
    order_datetime DATETIME,
    delivery_datetime DATETIME,
    delivery_cost MONEY,
    status NVARCHAR(50)
);

INSERT INTO Delivery_Original VALUES
(1001, 'Иванов А.П.', '+7-915-123-45-67', 'Москва, ул. Тверская, 15', 'Москва, ул. Ленина, 25', 'Петрова М.И.', '+7-916-444-55-66', 'Документы, Канцелярия', 2.5, 'Сидоров Д.К.', '+7-917-777-88-99', 'Легковой автомобиль', '2024-03-25 10:00:00', '2024-03-25 11:30:00', 450.00, 'Доставлен'),
(1002, 'ООО Ромашка', '+7-495-111-22-33', 'Москва, пр. Мира, 10', 'Москва, ул. Гагарина, 5', 'Козлов С.П.', '+7-918-999-00-11', 'Оборудование', 15.8, 'Никитин В.С.', '+7-919-333-44-55', 'Грузовой фургон', '2024-03-25 09:00:00', '2024-03-25 12:00:00', 1200.00, 'Доставлен');

CREATE TABLE Delivery_1NF (
    record_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    customer_name NVARCHAR(100),
    customer_phone NVARCHAR(20),
    pickup_address NVARCHAR(200),
    delivery_address NVARCHAR(200),
    recipient_name NVARCHAR(100),
    recipient_phone NVARCHAR(20),
    package_type NVARCHAR(50),
    package_weight_kg DECIMAL(5,2),
    courier_name NVARCHAR(100),
    courier_phone NVARCHAR(20),
    vehicle_type NVARCHAR(50),
    order_datetime DATETIME,
    delivery_datetime DATETIME,
    delivery_cost MONEY,
    status NVARCHAR(50)
);

INSERT INTO Delivery_1NF VALUES
(1001, 'Иванов А.П.', '+7-915-123-45-67', 'Москва, ул. Тверская, 15', 'Москва, ул. Ленина, 25', 'Петрова М.И.', '+7-916-444-55-66', 'Документы', 2.5, 'Сидоров Д.К.', '+7-917-777-88-99', 'Легковой автомобиль', '2024-03-25 10:00:00', '2024-03-25 11:30:00', 450.00, 'Доставлен'),
(1001, 'Иванов А.П.', '+7-915-123-45-67', 'Москва, ул. Тверская, 15', 'Москва, ул. Ленина, 25', 'Петрова М.И.', '+7-916-444-55-66', 'Канцелярия', 2.5, 'Сидоров Д.К.', '+7-917-777-88-99', 'Легковой автомобиль', '2024-03-25 10:00:00', '2024-03-25 11:30:00', 450.00, 'Доставлен');

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

CREATE TABLE Couriers (
    courier_id INT IDENTITY(1,1) PRIMARY KEY,
    courier_name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20) NOT NULL
);

CREATE TABLE Vehicles (
    vehicle_id INT IDENTITY(1,1) PRIMARY KEY,
    vehicle_type NVARCHAR(50) NOT NULL,
    max_weight_kg DECIMAL(5,2) NOT NULL
);

CREATE TABLE CourierVehicles (
    courier_id INT,
    vehicle_id INT,
    PRIMARY KEY (courier_id, vehicle_id),
    FOREIGN KEY (courier_id) REFERENCES Couriers(courier_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);

CREATE TABLE PackageTypes (
    type_id INT IDENTITY(1,1) PRIMARY KEY,
    type_name NVARCHAR(50) NOT NULL
);

CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    courier_id INT NOT NULL,
    pickup_address NVARCHAR(200) NOT NULL,
    delivery_address NVARCHAR(200) NOT NULL,
    recipient_name NVARCHAR(100) NOT NULL,
    recipient_phone NVARCHAR(20) NOT NULL,
    order_datetime DATETIME NOT NULL,
    delivery_datetime DATETIME,
    delivery_cost MONEY NOT NULL,
    status NVARCHAR(50) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (courier_id) REFERENCES Couriers(courier_id)
);

CREATE TABLE OrderPackages (
    order_id INT,
    type_id INT,
    weight_kg DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (order_id, type_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (type_id) REFERENCES PackageTypes(type_id)
);

INSERT INTO Customers VALUES ('Иванов А.П.'), ('ООО Ромашка');
INSERT INTO CustomerPhones VALUES (1,'+7-915-123-45-67'), (2,'+7-495-111-22-33');
INSERT INTO Couriers VALUES ('Сидоров Д.К.', '+7-917-777-88-99'), ('Никитин В.С.', '+7-919-333-44-55');
INSERT INTO Vehicles VALUES ('Легковой автомобиль', 50.00), ('Грузовой фургон', 500.00);
INSERT INTO CourierVehicles VALUES (1,1), (2,2);
INSERT INTO PackageTypes VALUES ('Документы'), ('Канцелярия'), ('Оборудование'), ('Продукты');
INSERT INTO Orders VALUES (1,1,'Москва, ул. Тверская, 15','Москва, ул. Ленина, 25','Петрова М.И.','+7-916-444-55-66','2024-03-25 10:00:00','2024-03-25 11:30:00',450.00,'Доставлен'),
(2,2,'Москва, пр. Мира, 10','Москва, ул. Гагарина, 5','Козлов С.П.','+7-918-999-00-11','2024-03-25 09:00:00','2024-03-25 12:00:00',1200.00,'Доставлен');
INSERT INTO OrderPackages VALUES (1,1,1.5), (1,2,1.0), (2,3,15.8);

SELECT c.customer_name, COUNT(o.order_id) as orders_count, SUM(o.delivery_cost) as total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;