DECLARE contact_cursor CURSOR
FOR SELECT * FROM Person.Person;
OPEN contact_cursor;
CLOSE contact_cursor;
DEALLOCATE contact_cursor;
GO

-- 19. Курсор с SCROLL и FETCH NEXT
DECLARE contact_cursor CURSOR SCROLL
FOR SELECT FirstName, LastName FROM Person.Person;
OPEN contact_cursor;

DECLARE @FirstName nvarchar(50), @LastName nvarchar(50);
FETCH NEXT FROM contact_cursor INTO @FirstName, @LastName;
PRINT @FirstName + ' ' + @LastName;
GO

-- 20. Различные варианты FETCH
DECLARE contact_cursor CURSOR SCROLL
FOR SELECT FirstName, LastName FROM Person.Person;
OPEN contact_cursor;

DECLARE @FirstName nvarchar(50), @LastName nvarchar(50);

-- FETCH NEXT
FETCH NEXT FROM contact_cursor INTO @FirstName, @LastName;
PRINT 'NEXT: ' + @FirstName + ' ' + @LastName;

-- FETCH PRIOR
FETCH PRIOR FROM contact_cursor INTO @FirstName, @LastName;
PRINT 'PRIOR: ' + @FirstName + ' ' + @LastName;

-- FETCH LAST
FETCH LAST FROM contact_cursor INTO @FirstName, @LastName;
PRINT 'LAST: ' + @FirstName + ' ' + @LastName;

-- FETCH FIRST
FETCH FIRST FROM contact_cursor INTO @FirstName, @LastName;
PRINT 'FIRST: ' + @FirstName + ' ' + @LastName;

-- FETCH ABSOLUTE
FETCH ABSOLUTE 5 FROM contact_cursor INTO @FirstName, @LastName;
PRINT 'ABSOLUTE 5: ' + @FirstName + ' ' + @LastName;

-- FETCH RELATIVE
FETCH RELATIVE 5 FROM contact_cursor INTO @FirstName, @LastName;
PRINT 'RELATIVE 5: ' + @FirstName + ' ' + @LastName;

CLOSE contact_cursor;
DEALLOCATE contact_cursor;
GO

-- 21. Курсор с LOCAL (автоматическое удаление)
DECLARE contact_cursor CURSOR LOCAL
FOR SELECT FirstName, LastName FROM Person.Person;
OPEN contact_cursor;

DECLARE @FirstName nvarchar(50), @LastName nvarchar(50);
FETCH NEXT FROM contact_cursor INTO @FirstName, @LastName;
PRINT @FirstName + ' ' + @LastName;
GO
-- Курсор автоматически удаляется после GO
-- 22. Найти товары, которые никогда не продавались
SELECT * FROM Products
WHERE ProdID NOT IN (SELECT DISTINCT ProdID FROM OrderDetails WHERE ProdID IS NOT NULL);
GO

-- 23. Найти сотрудников без заказов
SELECT * FROM Employees
WHERE EmployeeID NOT IN (SELECT DISTINCT EmployeeID FROM Orders WHERE EmployeeID IS NOT NULL);
GO

-- 24. Топ-3 самых дорогих товара в каждой категории (через подзапрос)
SELECT * FROM Products p1
WHERE ProdID IN (
    SELECT TOP 3 ProdID FROM Products p2 
    WHERE p2.CategoryID = p1.CategoryID 
    ORDER BY UnitPrice DESC
)
ORDER BY CategoryID, UnitPrice DESC;
GO

-- 25. Клиенты с покупками выше среднего чека
SELECT * FROM Customers c
WHERE CustomerNo IN (
    SELECT CustomerNo FROM Orders o
    WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM Orders)
);
GO