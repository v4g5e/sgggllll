SELECT * FROM SubTest1
WHERE id1 IN (SELECT id2 FROM SubTest2);
GO

-- 2. ОШИБОЧНЫЙ запрос - = вместо IN для нескольких значений
SELECT * FROM SubTest1
WHERE id1 = (SELECT id2 FROM SubTest2);
GO

-- 3. Подзапрос с условием WHERE (возвращает одно значение)
SELECT * FROM SubTest1
WHERE id1 = (SELECT id2 FROM SubTest2 WHERE name = 'four');
GO

-- 4. Подзапрос с JOIN в AdventureWorks
SELECT FirstName + ' ' + LastName as Name, BirthDate
FROM Person.Person as pc
JOIN HumanResources.Employee as he 
ON pc.BusinessEntityID = he.BusinessEntityID
WHERE BirthDate = '1945-11-17';
GO

-- 5. Подзапрос с агрегатной функцией
SELECT FirstName + ' ' + LastName as Name, BirthDate 
FROM Person.Person as pc
JOIN HumanResources.Employee as he 
ON pc.BusinessEntityID = he.BusinessEntityID
WHERE BirthDate = (SELECT MIN(BirthDate) FROM HumanResources.Employee);
GO