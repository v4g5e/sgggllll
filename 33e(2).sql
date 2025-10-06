SELECT * FROM SubTest1 AS ST1
WHERE name = (SELECT name FROM SubTest2 AS ST2 WHERE ST1.id1 = ST2.id2);
GO

-- 7. Связанный подзапрос с EXISTS (более эффективный)
SELECT * FROM SubTest1 AS ST1
WHERE EXISTS (SELECT * FROM SubTest2 ST2 WHERE ST1.id1 = ST2.id2);
GO

-- 8. Подзапрос в списке выборки (SELECT)
SELECT *, (SELECT name FROM SubTest2 AS ST2 WHERE ST1.id1 = ST2.id2) AS Name2 
FROM SubTest1 AS ST1;
GO

-- 9. Несколько подзапросов в SELECT
SELECT *,
       (SELECT id2 FROM SubTest2 AS ST2 WHERE ST1.id1 = ST2.id2) AS Id2,
       (SELECT name FROM SubTest2 AS ST2 WHERE ST1.id1 = ST2.id2) AS Name2
FROM SubTest1 AS ST1;
GO

-- 10. Комбинация подзапросов в WHERE и SELECT
SELECT *,
       (SELECT id2 FROM SubTest2 AS ST2 WHERE ST1.id1 = ST2.id2) AS Id2,
       (SELECT name FROM SubTest2 AS ST2 WHERE ST1.id1 = ST2.id2) AS Name2
FROM SubTest1 AS ST1
WHERE ST1.id1 = (SELECT id2 FROM SubTest2 AS ST2 WHERE ST1.id1 = ST2.id2);
GO
-- 11. Обычный JOIN для сравнения
SELECT Products.ProdID, [Description], Qty, TotalPrice 
FROM Products
INNER JOIN OrderDetails ON Products.ProdID = OrderDetails.ProdID;
GO

-- 12. Тот же результат через подзапросы в SELECT
SELECT (SELECT ProdID FROM Products WHERE Products.ProdID = OrderDetails.ProdID) AS ProdID,
       (SELECT [Description] FROM Products WHERE Products.ProdID = OrderDetails.ProdID) AS [Description], 
       Qty, TotalPrice 
FROM OrderDetails;
GO

-- 13. Статистика продаж по сотрудникам через JOIN
SELECT FName, LName, MName, SUM(TotalPrice) AS [Total Sold] 
FROM Employees
JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Employees.FName, Employees.LName, Employees.MName;
GO
-- 14. Создание временной таблицы
CREATE TABLE #TmpTable
(FName varchar(50),
 LName varchar(50),
 MName varchar(50),
 TotalPrice money);
GO

-- 15. Заполнение временной таблицы через подзапросы
SELECT (SELECT FName FROM Employees 
        WHERE EmployeeID = (SELECT EmployeeID FROM Orders
                           WHERE Orders.OrderID = OrderDetails.OrderID)
        ) AS FName,
       (SELECT LName FROM Employees 
        WHERE EmployeeID = (SELECT EmployeeID FROM Orders
                           WHERE Orders.OrderID = OrderDetails.OrderID)
        ) AS LName,
       (SELECT MName FROM Employees 
        WHERE EmployeeID = (SELECT EmployeeID FROM Orders
                           WHERE Orders.OrderID = OrderDetails.OrderID)
        ) AS MName,   
       TotalPrice
INTO #TmpTable 
FROM OrderDetails;
GO

-- 16. Агрегация из временной таблицы
SELECT FName, LName, MName, SUM(TotalPrice) AS [Total Sold] FROM #TmpTable
GROUP BY FName, LName, MName;
GO

-- 17. CTE (Common Table Expression) вместо временной таблицы
WITH Managers (FName, LName, MName, TotalPrice) AS
(
    SELECT (SELECT FName FROM Employees 
            WHERE EmployeeID = (SELECT EmployeeID FROM Orders
                               WHERE Orders.OrderID = OrderDetails.OrderID)
            ),
           (SELECT LName FROM Employees 
            WHERE EmployeeID = (SELECT EmployeeID FROM Orders
                               WHERE Orders.OrderID = OrderDetails.OrderID)
            ),
           (SELECT MName FROM Employees 
            WHERE EmployeeID = (SELECT EmployeeID FROM Orders
                               WHERE Orders.OrderID = OrderDetails.OrderID)
            ),   
           TotalPrice 
    FROM OrderDetails
)
SELECT FName, LName, MName, SUM(TotalPrice) AS [Total Sold] 
FROM Managers 
GROUP BY FName, LName, MName;
GO