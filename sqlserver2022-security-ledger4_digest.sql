/*
	SQL Server 2022 
	
	SQL Ledger : Digest management
	
	libera@kursysql.pl
	https://www.kursysql.pl
    
*/


-- RESTORE AdventureWorks2019

USE AdventureWorks2019
GO


/*
	Tworzenie tabeli i wypełnianie danymi
*/


DROP TABLE IF EXISTS dbo.EmployeeRate

-- utworzenie nowej tabeli typu ledger i wypełnienie jej danymi
CREATE TABLE dbo.EmployeeRate (
	ID int PRIMARY KEY IDENTITY,
	Firstname nvarchar(50), 
	Lastname nvarchar(50), 
	HireDate date,
	JobTitle varchar(50),
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





SELECT * FROM dbo.EmployeeRate

SELECT * FROM dbo.EmployeeRateHistory



/*
	MANUALNE generowanie database digests
*/


ALTER DATABASE AdventureWorks2019 SET ALLOW_SNAPSHOT_ISOLATION ON
GO



SELECT * FROM sys.database_ledger_blocks



-- ostatni database digest i hash bazy 
EXEC sp_generate_database_ledger_digest
/*
{
	"database_name":"AW_EmployeeRate","block_id":0,"hash":"0xCE7F35F78F7C1B85AF72A55F9BB9134A88582C2C3C2F4462AA839925890B0134","last_transaction_commit_time":"2022-11-23T12:29:09.5966667","digest_time":"2022-11-23T11:30:08.1090133"	
}

*/

EXEC sp_verify_database_ledger N'
{
"database_name":"AW_EmployeeRate","block_id":0,"hash":"0xCE7F35F78F7C1B85AF72A55F9BB9134A88582C2C3C2F4462AA839925890B0134","last_transaction_commit_time":"2022-11-23T12:29:09.5966667","digest_time":"2022-11-23T11:30:08.1090133"
}'


SELECT * FROM dbo.EmployeeRate


UPDATE EmployeeRate SET Rate = Rate*3 WHERE ID IN (8,9)


SELECT * FROM sys.database_ledger_blocks

-- ostatni database digest i hash bazy 
EXEC sp_generate_database_ledger_digest
/*
{
	"database_name":"AW_EmployeeRate","block_id":1,"hash":"0x20557F57AC9E6157D1AEEA1F70A4DC20BCDDC95451F59E55920F00B98E53D193","last_transaction_commit_time":"2022-11-23T12:30:59.0433333","digest_time":"2022-11-23T11:31:04.5894319"
}

*/

SELECT * FROM sys.database_ledger_blocks

EXEC sp_verify_database_ledger N'
{
	"database_name":"AW_EmployeeRate","block_id":1,"hash":"0x20557F57AC9E6157D1AEEA1F70A4DC20BCDDC95451F59E55920F00B98E53D193","last_transaction_commit_time":"2022-11-23T12:30:59.0433333","digest_time":"2022-11-23T11:31:04.5894319"

}'




EXECUTE sp_verify_database_ledger N'
[
    {
	"database_name":"AdventureWorks2019",
	"block_id":1,
	"hash":"0xB64487576676312647B4EC9BB96BDF4CA66F320650ACF51740382EE9E7F0303C",
	"last_transaction_commit_time":"2022-11-23T10:21:42.8566667",
	"digest_time":"2022-11-23T09:23:00.3199395"
    },
    {
	"database_name":"AdventureWorks2019",
	"block_id":2,
	"hash":"0x391A6A0EBA9F92B87C9782274F5972913AF940CCDBFAAC1B85366D8EB367B393",
	"last_transaction_commit_time":"2022-11-23T10:31:21.9200000",
	"digest_time":"2022-11-23T09:31:32.9567439"
    }
]'





/*
	SQL Server 2022

	AUTOMATYCZNE generowanie database digests

	- utworzenie kontenera sqldbledgerdigests w ramach Azure Storage
	- utworzenie shared access signature (SAS) na kontenerze (Read, Add, Create, Write, List, Immutable Storage)
	- utworzenie CREDENTIAL w SQL Server 
	- digest będzie tworzony co 30 sek

*/

DROP CREDENTIAL [https://kursysqldemo.blob.core.windows.net/sqldbledgerdigests]

CREATE CREDENTIAL [https://kursysqldemo.blob.core.windows.net/sqldbledgerdigests]  
WITH IDENTITY='SHARED ACCESS SIGNATURE',  
--SECRET = 'sr=c&sig=x3QaaG3GcTu0uYPDyaK0I7UYPwVrlVByAP2MkdiUaA0%3D'   
SECRET = 'sp=racwli&st=2022-11-23T12:16:13Z&se=2022-11-23T20:16:13Z&spr=https&sv=2021-06-08&sr=c&sig=x3QaaG3GcTu0uYPDyaK0I7UYPwVrlVByAP2MkdiUaA0%3D'


ALTER DATABASE SCOPED CONFIGURATION
SET LEDGER_DIGEST_STORAGE_ENDPOINT = 'https://kursysqldemo.blob.core.windows.net'


-- > Extended Events: ledger_digest_upload_success
-- REKOMENDACJA: SQL Server Agent Alert 37417 - Uploading ledger digest failed. 


-- > Storage Explorer


SELECT * FROM sys.database_ledger_digest_locations
-- last_digest_block_id


DECLARE @digest_locations NVARCHAR(MAX) = (SELECT * FROM sys.database_ledger_digest_locations FOR JSON AUTO, INCLUDE_NULL_VALUES);SELECT @digest_locations as digest_locations;
BEGIN TRY
    EXEC sys.sp_verify_database_ledger_from_digest_storage @digest_locations;
    SELECT 'Ledger verification succeeded.' AS Result;
END TRY
BEGIN CATCH
    THROW;
END CATCH



UPDATE EmployeeRate SET Rate = Rate*10 WHERE ID = 10
-- 30 sek...


-- > Extended Events: ledger_digest_upload_success

SELECT * FROM sys.database_ledger_digest_locations
-- last_digest_block_id



SELECT * FROM sys.database_ledger_blocks

SELECT * FROM dbo.EmployeeRate

SELECT * FROM dbo.EmployeeRateHistory





