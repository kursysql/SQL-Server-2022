/*
	SQL Server 2022 
	- Dynamic data masking - UNMASK
	
	libera@kursysql.pl
	https://www.kursysql.pl
    
*/

-- Dynamic data masking (SQL Server 2016)


USE AdventureWorks2019

DROP TABLE IF EXISTS Users
DROP TABLE IF EXISTS Employees

-- Tabela na dane testowe, kolumna na email zamaskowana
CREATE TABLE dbo.Users
  (ID int PRIMARY KEY,
   FirstName nvarchar(100) MASKED WITH (FUNCTION = 'partial(1,"XXXXXXX",0)'),
   LastName nvarchar(100) MASKED WITH (FUNCTION = 'partial(2,"XXX",0)'),
   ModifiedDate datetime, 
   PhoneNumber varchar(25) MASKED WITH (FUNCTION = 'default()'),
   EmailAddress nvarchar(100) MASKED WITH (FUNCTION = 'email()'),
   AddressLine nvarchar(60),
   City nvarchar(30),
   PostalCode nvarchar(10)
)


CREATE TABLE Employees (
	ID int PRIMARY KEY, 
	JobTitle nvarchar(50), 
	LoginID nvarchar(50) MASKED WITH (FUNCTION = 'default()'), 
	NationalIDNumber int MASKED WITH (FUNCTION = 'default()'),
	Rate money MASKED WITH (FUNCTION = 'default()'),
	PayFrequency int)

-- 
INSERT INTO Users (ID, FirstName, LastName, ModifiedDate, PhoneNumber, EmailAddress, AddressLine, City, PostalCode)
SELECT p.BusinessEntityID, p.FirstName, p.LastName, p.ModifiedDate, pp.PhoneNumber, ea.EmailAddress, ad.AddressLine1, ad.City, ad.PostalCode
FROM Person.Person AS p
JOIN Person.PersonPhone AS pp ON pp.BusinessEntityID = p.BusinessEntityID
JOIN Person.EmailAddress AS ea ON ea.BusinessEntityID = p.BusinessEntityID
JOIN Person.BusinessEntityAddress AS bea ON bea.BusinessEntityID = p.BusinessEntityID
JOIN Person.Address AS ad ON ad.AddressID = bea.AddressID
JOIN HumanResources.Employee AS e ON e.BusinessEntityID = p.BusinessEntityID



INSERT INTO Employees (ID, JobTitle, LoginID, NationalIDNumber, Rate, PayFrequency)
SELECT DISTINCT p.BusinessEntityID, e.JobTitle, e.LoginID, e.NationalIDNumber, MAX(ep.Rate), MAX(ep.PayFrequency)
FROM Person.Person AS p
JOIN HumanResources.Employee AS e ON e.BusinessEntityID = p.BusinessEntityID
JOIN HumanResources.EmployeePayHistory AS ep ON ep.BusinessEntityID = e.BusinessEntityID
GROUP BY p.BusinessEntityID, e.JobTitle, e.LoginID, e.NationalIDNumber



-- Rick i Cliff mają uprawnienia do czytania tabeli Users
DROP USER IF EXISTS Rick 
DROP USER IF EXISTS Cliff 


CREATE USER Rick WITHOUT LOGIN
GRANT SELECT ON Users TO Rick
GRANT SELECT ON Employees TO Rick
GO

CREATE USER Cliff WITHOUT LOGIN
GRANT SELECT ON Users TO Cliff
GRANT SELECT ON Employees TO Cliff
GO


-- Sprawdzamy co Rick i Cliff widzą w tabeli 
EXECUTE AS USER = 'Rick'
	SELECT * FROM Users
	SELECT * FROM Employees
REVERT

EXECUTE AS USER = 'Cliff'
	SELECT * FROM Users
	SELECT * FROM Employees
REVERT


-- Uprawnienie UMASK - dostęp do zamaskowanych danych (SQL Server 2016,2017,2019)
-- poziom bazy danych
GRANT UNMASK TO Cliff
GO

EXECUTE AS USER = 'Cliff'
	SELECT * FROM Users
	SELECT * FROM Employees
REVERT



-- UNMASK (SQL Server 2022)
-- poziom tabeli
GRANT UNMASK ON Users TO Rick


EXECUTE AS USER = 'Rick'
	SELECT * FROM Users
	SELECT * FROM Employees
REVERT


-- poziom kolumny
GRANT UNMASK ON Employees(LoginID) TO Rick



EXECUTE AS USER = 'Rick'
	SELECT * FROM Employees
REVERT


-- poziom schematu
GRANT UNMASK ON SCHEMA::dbo TO Rick



EXECUTE AS USER = 'Rick'
	SELECT * FROM Users
	SELECT * FROM Employees
REVERT




-- wycofanie uprawnienia UNMASK na poziomie schematu
REVOKE UNMASK ON SCHEMA::dbo FROM Rick
GO

EXECUTE AS USER = 'Rick'
	SELECT * FROM Users
	SELECT * FROM Employees
REVERT


-- wycofanie uprawnienia UNMASK na poziomie tabeli
REVOKE UNMASK ON Users FROM Rick

EXECUTE AS USER = 'Rick'
	SELECT * FROM Users	
REVERT


-- wycofanie uprawnienia UNMASK na poziomie kolumny
REVOKE UNMASK ON Employees(LoginID) FROM Rick


EXECUTE AS USER = 'Rick'
	SELECT * FROM Employees
REVERT




DROP USER Rick
DROP USER Cliff
GO

DROP TABLE Users
GO

DROP TABLE Employees
GO
