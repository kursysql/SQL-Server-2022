/*
	SQL Server 2022 
	- funkcja DATE_BUCKET
	
	libera@kursysql.pl
	https://www.kursysql.pl
    
*/




USE AdventureWorks2019
GO



SELECT 'month' AS _datepart, DATE_BUCKET(MONTH, 1, SYSDATETIME()) AS _date_bucket1
UNION ALL
SELECT 'week', DATE_BUCKET(WEEK, 1, SYSDATETIME())
UNION ALL
SELECT 'day', DATE_BUCKET(DAY, 1, SYSDATETIME())



-- co drugi miesiąc/ tydzień/ dzień
-- month: 1/ I-II 2/ III-IV 3/ V-VI 4/ VII-VIII
SELECT 'month' AS _datepart, DATE_BUCKET(MONTH, 2, SYSDATETIME()) AS _date_bucket2
UNION ALL
SELECT 'week', DATE_BUCKET(WEEK, 3, SYSDATETIME())
UNION ALL
SELECT 'day', DATE_BUCKET(DAY, 2, SYSDATETIME())






-- origin inny niż domyślny 1900-01-01 (licząc od 5 sierpnia)
SELECT 'month' AS _datepart, 
	DATE_BUCKET(MONTH, 1, SYSDATETIME(), CAST('20220805' AS datetime2)) AS _date_bucket1_origin_20220805

-- początek tygodnia, licząc od 5 sierpnia
SELECT 'week' AS _datepart, 
	DATE_BUCKET(WEEK, 1, SYSDATETIME(), CAST('20220805' AS datetime2)) AS _date_bucket1_origin_20220805


-- co drugi miesiąc, licząc od lutego 2022
-- 1/ II-III 2/ IV-V 3/ VI-VII 4/ VIII-IX
SELECT 'month' AS _datepart, 
	DATE_BUCKET(MONTH, 2, SYSDATETIME(), CAST('20220201' AS datetime2)) AS _date_bucket2_origin_20220201





/*
	Grupowanie danych na podstawie przedziałów
*/


SELECT OrderDate, 'month', DATE_BUCKET(MONTH, 1, OrderDate)
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2011

SELECT DATE_BUCKET(MONTH, 1, OrderDate), count(*)
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2011
GROUP BY DATE_BUCKET(MONTH, 1, OrderDate)
ORDER BY DATE_BUCKET(MONTH, 1, OrderDate)

SELECT MONTH(OrderDate), count(*)
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2011
GROUP BY MONTH(OrderDate)
ORDER BY MONTH(OrderDate)




SELECT OrderDate, 'month', DATE_BUCKET(MONTH, 2, OrderDate)
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2011

SELECT DATE_BUCKET(MONTH, 2, OrderDate), count(*)
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2011
GROUP BY DATE_BUCKET(MONTH, 2, OrderDate)
ORDER BY DATE_BUCKET(MONTH, 2, OrderDate)



SELECT OrderDate, 'week', DATE_BUCKET(WEEK, 1, OrderDate)
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2011

SELECT DATE_BUCKET(WEEK, 1, OrderDate), count(*)
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2011
GROUP BY DATE_BUCKET(WEEK, 1, OrderDate)
ORDER BY DATE_BUCKET(WEEK, 1, OrderDate)




SELECT OrderDate, 'week', DATE_BUCKET(WEEK, 2, OrderDate)
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2011

SELECT DATE_BUCKET(WEEK, 2, OrderDate), count(*)
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2011
GROUP BY DATE_BUCKET(WEEK, 2, OrderDate)
ORDER BY DATE_BUCKET(WEEK, 2, OrderDate)




ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 120
GO


ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 160
GO
