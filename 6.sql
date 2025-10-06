CREATE DATABASE OnlineShopDB;
USE OnlineShopDB;

CREATE TABLE Categories (
    CategoryID INT IDENTITY PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    ParentCategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID)
);

CREATE TABLE Products (
    ProductID INT IDENTITY PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID),
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT DEFAULT 0,
    Description NVARCHAR(500)
);

CREATE TABLE Customers (
    CustomerID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(20),
    RegistrationDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE Orders (
    OrderID INT IDENTITY PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2),
    Status NVARCHAR(20) DEFAULT 'Pending',
    ShippingAddress NVARCHAR(200)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT IDENTITY PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL
);

-- 1. Покупатели с суммой заказов выше среднего
SELECT c.FirstName, c.LastName, SUM(o.TotalAmount) as TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING SUM(o.TotalAmount) > (
    SELECT AVG(TotalSpent) FROM (
        SELECT SUM(TotalAmount) as TotalSpent 
        FROM Orders 
        GROUP BY CustomerID
    ) as temp
);

-- 2. Товары, которые никогда не заказывались
SELECT ProductName FROM Products p
WHERE NOT EXISTS (
    SELECT 1 FROM OrderDetails od WHERE od.ProductID = p.ProductID
);
GO