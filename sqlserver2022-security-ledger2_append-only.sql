/*
	SQL Server 2022 

	SQL Ledger : Append-only tables
	
	libera@kursysql.pl
	https://www.kursysql.pl
    
*/

/*
	Tworzenie tabeli i wypełnianie danymi
*/

DROP TABLE IF EXISTS dbo.EmployeeBonus
GO

CREATE TABLE dbo.EmployeeBonus
(
	EmployeeBonusID int PRIMARY KEY IDENTITY,
	BusinessEntityID int,
	BonusAwarded money,
	BonusDate datetime DEFAULT GETDATE()
)
WITH (LEDGER = ON (APPEND_ONLY = ON))


-- ObjectExplorer: lista tabel, nowe ikonki...


INSERT INTO dbo.EmployeeBonus (BusinessEntityID, BonusAwarded)
VALUES (1, 500), (2, 1000), (3, 900)



/*
	Odczyt danych
*/



SELECT *FROM EmployeeBonus


SELECT 
	EmployeeBonusID, BusinessEntityID, BonusAwarded, BonusDate,
	ledger_start_transaction_id,  
	ledger_start_sequence_number
FROM dbo.EmployeeBonus

-- wstawienie kolejnego wiersza
INSERT INTO dbo.EmployeeBonus (BusinessEntityID, BonusAwarded)
VALUES (5, 1000)



SELECT 
	EmployeeBonusID, BusinessEntityID, BonusAwarded, BonusDate,
	ledger_start_transaction_id,  
	ledger_start_sequence_number
FROM dbo.EmployeeBonus



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


-- nowe kolumny: ledger_type, ledger_type_desc, ledger_view_id, is_dropped_ledger_table
SELECT object_id, name, type, type_desc, ledger_type, ledger_type_desc, ledger_view_id, is_dropped_ledger_table
FROM sys.tables 
WHERE name like 'Employee%'
ORDER BY name




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
LEFT JOIN sys.tables AS h ON (h.[object_id] = t.[history_table_id]) -- left join
JOIN sys.views v ON (v.[object_id] = t.[ledger_view_id])
JOIN sys.schemas ts ON (ts.[schema_id] = t.[schema_id])
LEFT JOIN sys.schemas hs ON (hs.[schema_id] = h.[schema_id]) -- left join
JOIN sys.schemas vs ON (vs.[schema_id] = v.[schema_id])



SELECT * FROM EmployeeBonus_Ledger


EXEC sp_helptext 'EmployeeBonus_Ledger'
GO

-- definicja wygenerowanego widoku - zawiera TYLKO informacje o wstawionych wierszach, 

CREATE VIEW [dbo].[EmployeeBonus_Ledger] AS   
SELECT [EmployeeBonusID], [BusinessEntityID], [BonusAwarded], [BonusDate], 
[ledger_start_transaction_id] AS [ledger_transaction_id], 
[ledger_start_sequence_number] AS [ledger_sequence_number], 
1 AS [ledger_operation_type], N'INSERT' AS [ledger_operation_type_desc] 
FROM [dbo].[EmployeeBonus]


/*
	Modyfikowanie danych (PRÓBA!)
*/

SELECT * FROM EmployeeBonus

-- ! Msg 37359, Level 16, State 1, Line 144
-- ! Updates are not allowed for the append only Ledger table 'dbo.EmployeeBonus'.
UPDATE dbo.EmployeeBonus SET BonusAwarded = BonusAwarded*1.5 WHERE BusinessEntityID = 1

-- !
DELETE FROM dbo.EmployeeBonus WHERE BusinessEntityID = 2





/*
	sys.database_ledger_transactions
*/



SELECT * FROM sys.database_ledger_transactions


SELECT
	BusinessEntityID, BonusAwarded, BonusDate,
	t.commit_time	
	,t.principal_name
	,e.ledger_operation_type_desc
	,e.ledger_transaction_id
FROM dbo.EmployeeBonus_Ledger AS e
JOIN sys.database_ledger_transactions AS t
ON t.transaction_id = e.ledger_transaction_id
ORDER BY ledger_transaction_id, ledger_sequence_number






/*
	Kasowanie tabeli ledger append-only
*/

DROP TABLE dbo.EmployeeBonus
GO

SELECT * FROM sys.tables 
WHERE name like 'Employee%'
ORDER BY name

-- MSSQL_DroppedLedgerHistory_EmployeeBonus_GUID
SELECT * FROM sys.tables 
WHERE name like '%Employee%'
ORDER BY name

 