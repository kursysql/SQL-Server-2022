/*
	SQL Server 2022 
	SQL Ledger	
	- ledger database
	
	libera@kursysql.pl
	https://www.kursysql.pl
    
*/

USE tempdb
GO

DROP DATABASE IF EXISTS EmployeeProtectedData
GO

CREATE DATABASE EmployeeProtectedData
WITH LEDGER = ON
GO

USE EmployeeProtectedData

/*
	Tworzenie tabel
*/


DROP TABLE IF EXISTS dbo.EmployeeRate


CREATE TABLE dbo.EmployeeRate (
	BusinessEntityID int PRIMARY KEY IDENTITY,
	Firstname nvarchar(50),
	Lastname nvarchar(50),
	HireDate date,
	JobTitle nvarchar(50),
	Rate money,
	PayFrequency tinyint
)


DROP TABLE IF EXISTS dbo.EmployeeBonus


CREATE TABLE dbo.EmployeeBonus
(
	EmployeeBonusID int PRIMARY KEY IDENTITY,
	BusinessEntityID int,
	BonusAwarded money,
	BonusDate datetime DEFAULT GETDATE()
)



DROP TABLE IF EXISTS dbo.EmployeeBonus


CREATE TABLE dbo.EmployeeBonus
(
	EmployeeBonusID int PRIMARY KEY IDENTITY,
	BusinessEntityID int,
	BonusAwarded money,
	BonusDate datetime DEFAULT GETDATE()
)
WITH (LEDGER = ON (APPEND_ONLY = ON))




DROP TABLE IF EXISTS dbo.RegularTable

-- ! Msg 37420, Level 16, State 1, Line 67
-- ! LEDGER = OFF cannot be specified for tables in databases that were created with LEDGER = ON.
CREATE TABLE dbo.RegularTable
(
	EmployeeBonusID int PRIMARY KEY IDENTITY,
	BusinessEntityID int,
	BonusAwarded money,
	BonusDate datetime DEFAULT GETDATE()
)
WITH (LEDGER = OFF)




--> Azure SQL - Enable ledger database
