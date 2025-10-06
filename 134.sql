﻿USE ShopDB;
GO

-- 1. Показать статистику по количеству проданых едениц товара в порядке убывания
SELECT 
    p.ProdID,
    p.Description AS ProductName,
    SUM(od.Qty) AS TotalUnitsSold
FROM Products p
INNER JOIN OrderDetails od ON p.ProdID = od.ProdID
GROUP BY p.ProdID, p.Description
ORDER BY TotalUnitsSold DESC;
GO

-- 2. Вывести общую суму продаж по каждому из товаров
SELECT 
    p.ProdID,
    p.Description AS ProductName,
    SUM(od.TotalPrice) AS TotalSalesAmount,
    SUM(od.Qty) AS TotalUnitsSold,
    AVG(od.UnitPrice) AS AverageUnitPrice
FROM Products p
INNER JOIN OrderDetails od ON p.ProdID = od.ProdID
GROUP BY p.ProdID, p.Description
ORDER BY TotalSalesAmount DESC;
GO

-- 3. Вывести общее количество продаж по каждому из сотрудников
SELECT 
    e.EmployeeID,
    e.FName + ' ' + e.MName + ' ' + e.LName AS EmployeeFullName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(od.TotalPrice) AS TotalSalesAmount,
    SUM(od.Qty) AS TotalUnitsSold
FROM Employees e
LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.FName, e.MName, e.LName
ORDER BY TotalSalesAmount DESC;
GO

-- 4. Вывести количество продаж по городам
SELECT 
    c.City,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    COUNT(DISTINCT c.CustomerNo) AS UniqueCustomers,
    SUM(od.TotalPrice) AS TotalSalesAmount,
    SUM(od.Qty) AS TotalUnitsSold
FROM Customers c
LEFT JOIN Orders o ON c.CustomerNo = o.CustomerNo
LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.City
ORDER BY TotalSalesAmount DESC;
GO

-- 5. Показать даты покупок по каждому из покупателей
SELECT 
    c.CustomerNo,
    c.FName + ' ' + ISNULL(c.MName + ' ', '') + c.LName AS CustomerFullName,
    c.City,
    o.OrderID,
    o.OrderDate,
    o.TotalAmount,
    COUNT(od.LineItem) AS NumberOfItems,
    SUM(od.Qty) AS TotalItemsQuantity
FROM Customers c
INNER JOIN Orders o ON c.CustomerNo = o.CustomerNo
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY 
    c.CustomerNo, 
    c.FName, 
    c.MName, 
    c.LName, 
    c.City,
    o.OrderID, 
    o.OrderDate, 
    o.TotalAmount
ORDER BY c.CustomerNo, o.OrderDate DESC;
GO

-- 6. Вывести кто из продавцов каких покупателей обслуживает
SELECT 
    e.EmployeeID,
    e.FName + ' ' + e.MName + ' ' + e.LName AS EmployeeFullName,
    c.CustomerNo,
    c.FName + ' ' + ISNULL(c.MName + ' ', '') + c.LName AS CustomerFullName,
    c.City AS CustomerCity,
    COUNT(o.OrderID) AS NumberOfOrders,
    SUM(o.TotalAmount) AS TotalSalesAmount,
    MIN(o.OrderDate) AS FirstOrderDate,
    MAX(o.OrderDate) AS LastOrderDate
FROM Employees e
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
INNER JOIN Customers c ON o.CustomerNo = c.CustomerNo
GROUP BY 
    e.EmployeeID, 
    e.FName, 
    e.MName, 
    e.LName,
    c.CustomerNo, 
    c.FName, 
    c.MName, 
    c.LName, 
    c.City
ORDER BY e.EmployeeID, TotalSalesAmount DESC;
GO
-- 7. Детальная статистика по продажам с дополнительной аналитикой
SELECT 
    -- Информация о товаре
    p.ProdID,
    p.Description AS ProductName,
    
    -- Информация о продавце
    e.EmployeeID,
    e.FName + ' ' + e.MName + ' ' + e.LName AS EmployeeName,
    
    -- Информация о покупателе
    c.CustomerNo,
    c.FName + ' ' + ISNULL(c.MName + ' ', '') + c.LName AS CustomerName,
    c.City,
    
    -- Информация о заказе
    o.OrderID,
    o.OrderDate,
    
    -- Статистика продаж
    od.Qty AS Quantity,
    od.UnitPrice,
    od.TotalPrice,
    
    -- Аналитические показатели
    CASE 
        WHEN od.Qty > 10 THEN 'Large Order'
        WHEN od.Qty > 5 THEN 'Medium Order' 
        ELSE 'Small Order'
    END AS OrderSizeCategory
    
FROM OrderDetails od
INNER JOIN Products p ON od.ProdID = p.ProdID
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
INNER JOIN Customers c ON o.CustomerNo = c.CustomerNo
ORDER BY o.OrderDate DESC, od.TotalPrice DESC;
GO

-- 8. Топ-3 самых продаваемых товара по количеству
SELECT TOP 3
    p.ProdID,
    p.Description AS ProductName,
    SUM(od.Qty) AS TotalUnitsSold,
    SUM(od.TotalPrice) AS TotalRevenue,
    COUNT(DISTINCT o.OrderID) AS NumberOfOrders
FROM Products p
INNER JOIN OrderDetails od ON p.ProdID = od.ProdID
INNER JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY p.ProdID, p.Description
ORDER BY TotalUnitsSold DESC;
GO

-- 9. Продавцы с показателями эффективности
SELECT 
    e.EmployeeID,
    e.FName + ' ' + e.MName + ' ' + e.LName AS EmployeeName,
    e.Salary,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    COUNT(DISTINCT c.CustomerNo) AS UniqueCustomers,
    SUM(od.TotalPrice) AS TotalSales,
    AVG(od.TotalPrice) AS AverageOrderValue,
    -- Эффективность (продажи на рубль зарплаты)
    CASE 
        WHEN e.Salary > 0 THEN SUM(od.TotalPrice) / e.Salary 
        ELSE 0 
    END AS SalesToSalaryRatio
FROM Employees e
LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
LEFT JOIN Customers c ON o.CustomerNo = c.CustomerNo
GROUP BY e.EmployeeID, e.FName, e.MName, e.LName, e.Salary
ORDER BY TotalSales DESC;
GO

-- 10. Клиенты с их покупательской активностью
SELECT 
    c.CustomerNo,
    c.FName + ' ' + ISNULL(c.MName + ' ', '') + c.LName AS CustomerName,
    c.City,
    c.Phone,
    c.DateInSystem AS RegistrationDate,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(o.TotalAmount) AS TotalSpent,
    AVG(o.TotalAmount) AS AverageOrderValue,
    DATEDIFF(DAY, MIN(o.OrderDate), MAX(o.OrderDate)) AS CustomerLifetimeDays,
    CASE 
        WHEN COUNT(o.OrderID) >= 3 THEN 'Loyal Customer'
        WHEN COUNT(o.OrderID) = 2 THEN 'Regular Customer' 
        ELSE 'New Customer'
    END AS CustomerType
FROM Customers c
LEFT JOIN Orders o ON c.CustomerNo = o.CustomerNo
GROUP BY 
    c.CustomerNo, 
    c.FName, 
    c.MName, 
    c.LName, 
    c.City, 
    c.Phone, 
    c.DateInSystem
ORDER BY TotalSpent DESC;
GO