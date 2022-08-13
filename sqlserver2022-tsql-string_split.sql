/*
	SQL Server 2022 
	- funkcja STRING_SPLIT
	
	libera@kursysql.pl
	https://www.kursysql.pl
    
*/


USE AdventureWorks2019



SELECT value FROM STRING_SPLIT('Lorem ipsum dolor sit amet.', ' ')






-- min 130 compat level
ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 120
GO

-- ! 208 Invalid object name 'STRING_SPLIT'.
SELECT value FROM STRING_SPLIT('Lorem ipsum dolor sit amet.', ' ')



ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 130
GO


SELECT * FROM STRING_SPLIT('Chisel Epic Epic EVO Epic FSR Epic Hardtail Riprock', ' ')


-- wartości oddzielone przecinkiem, włącznie z pustą wartością
DECLARE @tags NVARCHAR(400) = 'Chisel,Epic,Epic EVO,Epic FSR,,Epic Hardtail,Riprock'  
  
SELECT value  
FROM STRING_SPLIT(@tags, ',')  


-- usunięcie pustych wartości 
SELECT value  
FROM STRING_SPLIT(@tags, ',')  
WHERE RTRIM(value) <> ''
GO




/*
	enable_ordinal
	A value of 1 enables the ordinal column. 
	If enable_ordinal is omitted, NULL, or has a value of 0, the ordinal column is disabled.
*/

SELECT * 
FROM STRING_SPLIT('Chisel Epic Epic EVO Epic FSR Epic Hardtail Riprock', ' ')



SELECT * 
FROM STRING_SPLIT('Chisel Epic Epic EVO Epic FSR Epic Hardtail Riprock', ' ', 1)



-- numerowane są też puste wartości
DECLARE @tags NVARCHAR(400) = 'Chisel,Epic,Epic EVO,Epic FSR,,Epic Hardtail,Riprock'  
  
SELECT * FROM STRING_SPLIT(@tags, ',', 1)  



-- wartość z kolumny ordinal, możemy od razy w zapytaniu, np. do filtrowania
SELECT * 
FROM STRING_SPLIT('Chisel Epic Epic EVO Epic FSR Epic Hardtail Riprock', ' ', 1)
WHERE ordinal % 2 = 0





-- Typ danych varchar(max)
DECLARE @tags varchar(max) = 
	REPLICATE(CAST('Chisel,Epic,Epic EVO,Epic FSR,Epic Hardtail,Riprock,' AS varchar(max)), 2000)

SELECT @tags
SELECT LEN(@tags) AS tags_LEN
  
SELECT * FROM STRING_SPLIT(@tags, ',', 1)  








ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 160
GO
