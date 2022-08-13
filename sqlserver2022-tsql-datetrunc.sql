/*
	SQL Server 2022 
	- funkcja DATETRUNC
	
	libera@kursysql.pl
	https://www.kursysql.pl
    
*/


USE AdventureWorks2019
GO

/*
	Funkcja DATETRUNC()
*/

SELECT DATETRUNC(minute, GETDATE())


-- przed SQL Server 2022
SELECT DATEADD(MINUTE, DATEDIFF(minute, 0, GETDATE()), 0)








-- zaokrąglenie daty zwracanej przez funkcję GETDATE (typ danych datetime) do minuty
SELECT 
	GETDATE() AS input_date, 
	DATETRUNC(minute, GETDATE()) AS result_datetrunc, 
	SQL_VARIANT_PROPERTY(DATETRUNC(minute, GETDATE()),'BaseType') AS result_basetype

-- zaokrąglenie daty zwracanej przez funkcję SYSDATETIME (typ danych datetime2) do minuty 
SELECT 
	SYSDATETIME() AS input_date, 
	DATETRUNC(minute, SYSDATETIME()) AS result_datetrunc, 
	SQL_VARIANT_PROPERTY(DATETRUNC(minute, SYSDATETIME()),'BaseType') AS result_basetype

-- zaokrąglenie daty przekazanej jako smalldatetime do minuty
SELECT 
	GETDATE() AS input_date, 
	DATETRUNC(minute, CAST(GETDATE() as smalldatetime)) AS result_datetrunc, 
	SQL_VARIANT_PROPERTY(DATETRUNC(minute, CAST(GETDATE() as smalldatetime)),'BaseType') AS result_basetype


SELECT SYSDATETIME() AS 'SYSDATETIME()' 

-- argument datepart
SELECT DATETRUNC(year, SYSDATETIME()) AS _datetrunc, 'year' AS _datefirst, '' AS description
UNION
SELECT DATETRUNC(quarter, SYSDATETIME()), 'quarter', N'pierwszy miesiąc w kwartale'
UNION
SELECT DATETRUNC(month, SYSDATETIME()), 'month', ''
UNION
SELECT DATETRUNC(week, SYSDATETIME()), 'week', N'datefirst - domyślnie 7 (niedziela)'
UNION
SELECT DATETRUNC(iso_week, SYSDATETIME()), 'iso_week', N'ISO8601 - poniedziałek to pierwszy dzień tygodnia'
UNION
SELECT DATETRUNC(dayofyear, SYSDATETIME()), 'dayofyear', 'to samo co day'
UNION
SELECT DATETRUNC(day, SYSDATETIME()), 'day', ''
UNION
SELECT DATETRUNC(hour, SYSDATETIME()), 'hour', ''
UNION
SELECT DATETRUNC(minute, SYSDATETIME()), 'minute' , ''
UNION
SELECT DATETRUNC(second, SYSDATETIME()), 'second', ''
UNION
SELECT DATETRUNC(millisecond, SYSDATETIME()), 'millisecond', ''
UNION
SELECT DATETRUNC(microsecond, SYSDATETIME()), 'microsecond', ''



-- odczyt danych w tabeli
SELECT SalesOrderID
	,OrderDate
	,DATETRUNC(year, OrderDate) AS _year
	,DATETRUNC(quarter, OrderDate) AS _quarter
	,DATETRUNC(month, OrderDate) AS _month
	,DATETRUNC(week, OrderDate) AS _week
	,DATETRUNC(day, OrderDate) AS _day
	,DATETRUNC(hour, OrderDate) AS _hour
FROM Sales.SalesOrderHeader 



-- filtrowanie danych w tabelach
SELECT * FROM Sales.SalesOrderHeader WHERE OrderDate BETWEEN '20110601' AND '20110630'

SELECT * FROM Sales.SalesOrderHeader WHERE DATETRUNC(month, OrderDate) = '20110601'



-- niezależna od poziomu zgodności bazy danych
ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 120

SELECT name, compatibility_level FROM sys.databases WHERE name = 'AdventureWorks2019'

SELECT DATETRUNC(minute, GETDATE())

SELECT SalesOrderID	,DATETRUNC(year, OrderDate) AS _year
FROM Sales.SalesOrderHeader

ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 160

