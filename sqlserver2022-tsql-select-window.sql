/*
	SQL Server 2022 
	- funkcja SELECT... WINDOW
	
	libera@kursysql.pl
	https://www.kursysql.pl
    
*/



ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 160
GO


USE AdventureWorks2019
GO

-- ?? jaki klient? jakie numery zamówień?
-- GROUP BY 
SELECT OrderDate
	,SUM(TotalDue)
FROM Sales.SalesOrderHeader
GROUP BY OrderDate
ORDER BY OrderDate



-- PARTYCJA: data (dzień) sprzedaży
SELECT OrderDate, CustomerID, SalesOrderNumber, TotalDue
	,SUM(TotalDue) OVER (PARTITION BY OrderDate) AS TotalDueDate
FROM Sales.SalesOrderHeader
WHERE OrderDate > '20110531'
ORDER BY OrderDate ASC


SELECT CustomerID, SalesOrderNumber, OrderDate, CurrencyRateID, TotalDue
	,SUM(TotalDue) OVER (PARTITION BY OrderDate) AS TotalDueDateSUM
	,AVG(TotalDue) OVER (PARTITION BY OrderDate) AS TotalDueDateAVG
	,MIN(TotalDue) OVER (PARTITION BY OrderDate) AS TotalDueDateMIN
	,MAX(TotalDue) OVER (PARTITION BY OrderDate) AS TotalDueDateMAX
	,COUNT(*) OVER (PARTITION BY OrderDate) AS TotalDueDateCOUNT
	,COUNT(CurrencyRateID) OVER (PARTITION BY OrderDate) AS TotalDueDateCOUNT_CurrencyRateID
FROM Sales.SalesOrderHeader
WHERE OrderDate > '20110531'
ORDER BY OrderDate ASC


-- SQL Server 2022

SELECT CustomerID, SalesOrderNumber, OrderDate, CurrencyRateID, TotalDue
	,SUM(TotalDue) OVER win AS TotalDueDateSUM
	,AVG(TotalDue) OVER win AS TotalDueDateAVG
	,MIN(TotalDue) OVER win AS TotalDueDateMIN
	,MAX(TotalDue) OVER win AS TotalDueDateMAX
	,COUNT(*) OVER win AS TotalDueDateCOUNT
	,COUNT(CurrencyRateID) OVER win AS TotalDueDateCOUNT_CurrencyRateID
FROM Sales.SalesOrderHeader
WHERE OrderDate > '20110531'
WINDOW win AS (PARTITION BY OrderDate)
ORDER BY OrderDate ASC


-- funkcje szeregujące
SELECT CustomerID, SalesOrderNumber, OrderDate, CurrencyRateID, TotalDue
	,RANK() OVER (PARTITION BY OrderDate ORDER BY TotalDue DESC) AS TotalDueRANK
	,DENSE_RANK() OVER (PARTITION BY OrderDate ORDER BY TotalDue DESC) AS TotalDueDENSE_RANK
	,ROW_NUMBER() OVER (PARTITION BY OrderDate ORDER BY TotalDue DESC) AS TotalDueROW_NUMBER
FROM Sales.SalesOrderHeader
WHERE OrderDate > '20110531'
ORDER BY CustomerID

SELECT CustomerID, SalesOrderNumber, OrderDate, CurrencyRateID, TotalDue
	,RANK() OVER win AS TotalDueRANK
	,DENSE_RANK() OVER win AS TotalDueDENSE_RANK
	,ROW_NUMBER() OVER win AS TotalDueROW_NUMBER	
FROM Sales.SalesOrderHeader
WHERE OrderDate > '20110531'
WINDOW win AS (PARTITION BY OrderDate ORDER BY TotalDue DESC)
ORDER BY CustomerID







SELECT CustomerID, SalesOrderNumber, OrderDate, CurrencyRateID, TotalDue
	,SUM(TotalDue) OVER win1 AS TotalDueDateSUM
	,SUM(TotalDue) OVER win2 AS TotalDueDateRunningSUMDates
	,SUM(TotalDue) OVER win3 AS TotalDueDateRunningSUM
FROM Sales.SalesOrderHeader
WHERE OrderDate > '20110531'
WINDOW win1 AS (PARTITION BY OrderDate),
	win2 AS (ORDER BY SalesOrderNumber),
	win3 AS (win2 PARTITION BY OrderDate)
ORDER BY OrderDate ASC





-- Poziom zgodności min 160 
ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 150
GO


SELECT CustomerID, SalesOrderNumber, OrderDate, CurrencyRateID, TotalDue
	,RANK() OVER win AS TotalDueRANK
	,DENSE_RANK() OVER win AS TotalDueDENSE_RANK
	,ROW_NUMBER() OVER win AS TotalDueROW_NUMBER	
FROM Sales.SalesOrderHeader
WHERE OrderDate > '20110531'
WINDOW win AS (PARTITION BY OrderDate ORDER BY TotalDue DESC)
ORDER BY CustomerID




ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 160
GO
