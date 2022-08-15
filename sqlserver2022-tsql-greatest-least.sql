/*
	SQL Server 2022 
	- funkcja GREATEST
	- funkcja LEAST
	
	libera@kursysql.pl
	https://www.kursysql.pl
    
*/


SELECT GREATEST(1, 5) AS greatest_1_5, GREATEST(6, 2) AS greatest_6_2

SELECT LEAST(1, 5) AS least_1_5, LEAST(6, 2) AS least_6_2


-- Przed SQL Server 2022
SELECT GREATEST(1, 5)

SELECT IIF(1>5, 1, 5)

SELECT CASE WHEN 1>5 THEN  1 ELSE 5 END

SELECT GREATEST(1, 5, 15)

SELECT CASE 
	WHEN 1>5 THEN 
		CASE WHEN 1>15 THEN 1 ELSE 15 END
	WHEN 5>15 THEN 
		CASE WHEN 5>15 THEN 5 ELSE 15 END
	ELSE 15 END





-- Wynikowy typ danych (i skala) są determinowane przez argument najwyższego typu z listy pierwszeństwa typów
-- https://docs.microsoft.com/en-us/sql/t-sql/data-types/data-type-precedence-transact-sql
SELECT GREATEST(1.2, 5.05, 1.0225) 

SELECT GREATEST(1.2, 5.05, 1.0225, 1, 2, 5, 6) 

SELECT LEAST(1.2, 5.05, 1, 10.5678, -67) 



-- Można używać zmiennych
DECLARE @a decimal(5,1) = 1.2
DECLARE @b decimal(5,2) = 5.05
DECLARE @c decimal(5,4) = 1.0225
DECLARE @d int = 1
DECLARE @e int = 2
DECLARE @f int = 5
DECLARE @g int = 6

SELECT @a as a, @b AS b, @c AS c, @d AS d, @e AS e, @f AS f, @g AS g
SELECT GREATEST(@a, @b, @c, @d, @e, @f, @g)





-- wartości NULL są pomijane podczas porównywania
SELECT GREATEST(1.2, 5.05, NULL, 1.0225) 

SELECT LEAST(1.2, 5.05, NULL, 1.0225) 







-- dowolny poziom zgodności bazy
ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 120
GO


USE AdventureWorks2019
GO


SELECT * FROM Sales.SalesOrderHeader


SELECT 
	SalesOrderID,
	OrderDate,
	DueDate,
	ShipDate,
	LEAST(OrderDate, DueDate, ShipDate) AS EarliestDate,
	GREATEST(OrderDate, DueDate, ShipDate) AS LatestDate
FROM Sales.SalesOrderHeader
WHERE LEAST(OrderDate, DueDate, ShipDate) BETWEEN '20110601' AND '20110603'







