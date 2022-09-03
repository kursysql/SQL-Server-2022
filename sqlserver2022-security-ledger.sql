/*
	SQL Server 2022 
	SQL Ledger
	
	libera@kursysql.pl
	https://www.kursysql.pl
    
*/


USE AdventureWorks2019
GO



/*
	Tworzenie tabeli i wypełnianie danymi
*/


DROP TABLE IF EXISTS dbo.EmployeeRate

-- utworzenie nowej tabeli typu ledger i wypełnienie jej danymi
CREATE TABLE dbo.EmployeeRate (
	BusinessEntityID int PRIMARY KEY IDENTITY,
	Firstname nvarchar(50),
	Lastname nvarchar(50),
	HireDate date,
	JobTitle nvarchar(50),
	Rate money,
	PayFrequency tinyint
)
WITH 
(
	SYSTEM_VERSIONING = ON,
	LEDGER = ON
)

-- ObjectExplorer: lista tabel, nowe ikonki...


DROP TABLE IF EXISTS dbo.EmployeeRate
GO

CREATE TABLE dbo.EmployeeRate (
	ID int PRIMARY KEY IDENTITY,
	Firstname nvarchar(50),
	Lastname nvarchar(50),
	HireDate date,
	JobTitle nvarchar(50),
	Rate money,
	PayFrequency tinyint
)
WITH 
(
 SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeRateHistory),
 LEDGER = ON
)




;WITH _cte  AS (
	SELECT *, ROW_NUMBER() OVER (PARTITION BY BusinessEntityID ORDER BY RateChangeDate DESC)  AS Rn
	FROM HumanResources.EmployeePayHistory
)
INSERT INTO dbo.EmployeeRate(FirstName, LastName, HireDate, JobTitle, Rate, PayFrequency)
SELECT TOP 10 p.FirstName, p.LastName, emp.HireDate, emp.JobTitle, _cte.Rate, _cte.PayFrequency
FROM _cte
JOIN HumanResources.Employee AS emp ON emp.BusinessEntityID = _cte.BusinessEntityID
JOIN Person.Person AS p ON p.BusinessEntityID = emp.BusinessEntityID
WHERE _cte.Rn = 1



/*
	Odczyt danych
*/




SELECT * FROM dbo.EmployeeRate

SELECT * FROM dbo.EmployeeRateHistory


-- nowe kolumny: ledger_type, ledger_type_desc, ledger_view_id, is_dropped_ledger_table
SELECT * FROM sys.tables 
WHERE name like 'Employee%'
ORDER BY name


SELECT 
	ID, Firstname, Lastname, HireDate, JobTitle, Rate, PayFrequency, 
	ledger_start_transaction_id, ledger_end_transaction_id, 
	ledger_start_sequence_number, ledger_end_sequence_number
FROM dbo.EmployeeRate


-- wstawienie kolejnych 2 wierszy
;WITH _cte  AS (
	SELECT *, ROW_NUMBER() OVER (PARTITION BY BusinessEntityID ORDER BY RateChangeDate DESC)  AS Rn
	FROM HumanResources.EmployeePayHistory
)
INSERT INTO dbo.EmployeeRate(FirstName, LastName, HireDate, JobTitle, Rate, PayFrequency)
SELECT TOP 2 p.FirstName, p.LastName, emp.HireDate, emp.JobTitle, _cte.Rate, _cte.PayFrequency
FROM _cte
JOIN HumanResources.Employee AS emp ON emp.BusinessEntityID = _cte.BusinessEntityID
JOIN Person.Person AS p ON p.BusinessEntityID = emp.BusinessEntityID
WHERE _cte.Rn = 1 AND emp.BusinessEntityID > 200


SELECT 
	ID, Firstname, Lastname, HireDate, JobTitle, Rate, PayFrequency, 
	ledger_start_transaction_id, ledger_end_transaction_id, 
	ledger_start_sequence_number, ledger_end_sequence_number
FROM dbo.EmployeeRate


/*
	Ledger view
*/


SELECT * FROM sys.views
WHERE name like 'Employee%'

-- lista wszystkich tabel ledger, tabel z historią i widoków
SELECT 
ts.[name] + '.' + t.[name] AS [ledger_table_name]
, hs.[name] + '.' + h.[name] AS [history_table_name]
, vs.[name] + '.' + v.[name] AS [ledger_view_name]
FROM sys.tables AS t
JOIN sys.tables AS h ON (h.[object_id] = t.[history_table_id])
JOIN sys.views v ON (v.[object_id] = t.[ledger_view_id])
JOIN sys.schemas ts ON (ts.[schema_id] = t.[schema_id])
JOIN sys.schemas hs ON (hs.[schema_id] = h.[schema_id])
JOIN sys.schemas vs ON (vs.[schema_id] = v.[schema_id])



SELECT * FROM EmployeeRate_Ledger


EXEC sp_helptext 'EmployeeRate_Ledger'
GO

-- definicja wygenerowanego widoku - zawiera informacje o wstawionych wierszach, 
-- a także historii zmian (UPDATE jako DELETE i INSERT)
CREATE VIEW [dbo].[EmployeeRate_Ledger] AS   
SELECT [ID], [Firstname], [Lastname], [HireDate], [JobTitle], [Rate], [PayFrequency], 
	[ledger_start_transaction_id] AS [ledger_transaction_id], [ledger_start_sequence_number] AS [ledger_sequence_number], 
	1 AS [ledger_operation_type], N'INSERT' AS [ledger_operation_type_desc] 
FROM [dbo].[EmployeeRate]   
UNION ALL   
SELECT [ID], [Firstname], [Lastname], [HireDate], [JobTitle], [Rate], [PayFrequency], 
	[ledger_start_transaction_id] AS [ledger_transaction_id], [ledger_start_sequence_number] AS [ledger_sequence_number], 
	1 AS [ledger_operation_type], N'INSERT' AS [ledger_operation_type_desc] 
FROM [dbo].[EmployeeRateHistory]   
UNION ALL   
SELECT [ID], [Firstname], [Lastname], [HireDate], [JobTitle], [Rate], [PayFrequency], 
	[ledger_end_transaction_id] AS [ledger_transaction_id], [ledger_end_sequence_number] AS [ledger_sequence_number], 
	2 AS [ledger_operation_type], N'DELETE' AS [ledger_operation_type_desc] 
FROM [dbo].[EmployeeRateHistory]



/*
	Modyfikowanie danych
*/



UPDATE dbo.EmployeeRate SET Rate = Rate*1.5 WHERE ID = 1

UPDATE dbo.EmployeeRate SET Rate = Rate*2 WHERE ID = 2



SELECT * FROM dbo.EmployeeRate

SELECT 
	ID, Firstname, Lastname, HireDate, JobTitle, Rate, PayFrequency, 
	ledger_start_transaction_id, ledger_end_transaction_id, 
	ledger_start_sequence_number, ledger_end_sequence_number
FROM dbo.EmployeeRate

-- w tabeli z historią - poprzednia wersja zmodyfikowanych wierszy
SELECT * FROM dbo.EmployeeRateHistory


-- kasowanie danych
DELETE FROM EmployeeRate WHERE ID = 10


SELECT * FROM dbo.EmployeeRate


SELECT 
	ID, Firstname, Lastname, HireDate, JobTitle, Rate, PayFrequency, 
	ledger_start_transaction_id, ledger_end_transaction_id, 
	ledger_start_sequence_number, ledger_end_sequence_number
FROM dbo.EmployeeRate

-- w tabeli z historią - skasowany wiersz
SELECT * FROM dbo.EmployeeRateHistory


-- widok prezentujący rodzaj operacji, 
-- posortowanych chronologicznie, tj zgodnie z identyfikatorami transkacji 
SELECT * FROM EmployeeRate_Ledger
ORDER BY ledger_transaction_id, ledger_sequence_number


-- Msg 13545, Level 16, State 1, Line 216
-- Truncate failed on table 'AdventureWorks2019.dbo.EmployeeRate' because 
-- it is not a supported operation on system-versioned tables.
TRUNCATE TABLE dbo.EmployeeRate





/*
	sys.database_ledger_transactions
*/



SELECT * FROM sys.database_ledger_transactions


SELECT
	t.commit_time	
	,t.principal_name
	,ID, Firstname, Lastname, HireDate, JobTitle, Rate, PayFrequency
	,e.ledger_operation_type_desc
	,e.ledger_transaction_id
FROM dbo.EmployeeRate_Ledger AS e
JOIN sys.database_ledger_transactions AS t
ON t.transaction_id = e.ledger_transaction_id
ORDER BY ledger_transaction_id, ledger_sequence_number






/*
	Kasowanie tabeli ledger
*/

DROP TABLE dbo.EmployeeRate
GO

SELECT * FROM sys.tables 
WHERE name like 'Employee%'
ORDER BY name

-- MSSQL_DroppedLedgerHistory_EmployeeRateHistory_GUID
SELECT * FROM sys.tables 
WHERE name like '%Employee%'
ORDER BY name

 