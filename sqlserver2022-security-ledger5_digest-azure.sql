/*
	SQL Server 2022 
	
	SQL Ledger : Digest management : Azure
	
	libera@kursysql.pl
	https://www.kursysql.pl
    
*/


/*
	Azure SQL

	AUTOMATYCZNE generowanie database digests

*/



DROP TABLE IF EXISTS dbo.Customer

-- utworzenie nowej tabeli typu ledger i wypełnienie jej danymi
CREATE TABLE dbo.Customer (
	ID int PRIMARY KEY IDENTITY,
	Firstname nvarchar(50), 
	Lastname nvarchar(50), 
	PasswordHash varchar(128)
)
WITH 
(
 SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.CustomerHistory),
 LEDGER = ON
)


INSERT INTO dbo.Customer (Firstname, Lastname, PasswordHash)
SELECT TOP 10 FirstName, LastName, PasswordHash
FROM SalesLT.Customer 


SELECT * FROM dbo.Customer


SELECT * FROM sys.database_ledger_digest_locations



DECLARE @digest_locations NVARCHAR(MAX) = (SELECT * FROM sys.database_ledger_digest_locations FOR JSON AUTO, INCLUDE_NULL_VALUES);
SELECT @digest_locations as digest_locations;
BEGIN TRY
    EXEC sys.sp_verify_database_ledger_from_digest_storage @digest_locations;
    SELECT 'Ledger verification succeeded.' AS Result;
END TRY
BEGIN CATCH
    THROW;
END CATCH


