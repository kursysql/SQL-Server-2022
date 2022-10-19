/*
	SQL Server 2022 
	- STATS - AUTO_DROP
	
	libera@kursysql.pl
	https://www.kursysql.pl
    
*/



USE AdventureWorks2019


-- Statistics for Sales.CreditCard table



/*
	Index statistics (created automatically)
*/

SELECT * FROM sys.stats 
WHERE object_id = object_id('Sales.CreditCard')


CREATE INDEX IX_CreditCard_ExpMonth ON Sales.CreditCard (ExpMonth) 

SELECT object_id, name, stats_id, auto_created, user_created, auto_drop FROM sys.stats 
WHERE object_id = object_id('Sales.CreditCard')



-- ExpMonth	tinyint -> int

--  !!! Msg 5074, Level 16, State 1, Line 28
--  The index 'IX_CreditCard_ExpMonth' is dependent on column 'ExpMonth'.
--  !!! Msg 4922, Level 16, State 9, Line 28
--  ALTER TABLE ALTER COLUMN ExpMonth failed because one or more objects access this column.

ALTER TABLE Sales.CreditCard
ALTER COLUMN ExpMonth int


DROP INDEX IX_CreditCard_ExpMonth ON Sales.CreditCard


ALTER TABLE Sales.CreditCard
ALTER COLUMN ExpMonth int

-- Cleanup
ALTER TABLE Sales.CreditCard ALTER COLUMN ExpMonth tinyint



/*
	Column statistics (created automatically)
*/

SELECT object_id, name, stats_id, auto_created, user_created, auto_drop FROM sys.stats 
WHERE object_id = object_id('Sales.CreditCard')


SELECT * FROM Sales.CreditCard WHERE ExpMonth = '10'

-- auto_drop = 1
SELECT object_id, name, stats_id, auto_created, user_created, auto_drop FROM sys.stats 
WHERE object_id = object_id('Sales.CreditCard')


ALTER TABLE Sales.CreditCard
ALTER COLUMN ExpMonth int

-- Cleanup
ALTER TABLE Sales.CreditCard ALTER COLUMN ExpMonth tinyint



/*
	Column statistics (created by user)
*/


SELECT object_id, name, stats_id, auto_created, user_created, auto_drop FROM sys.stats 
WHERE object_id = object_id('Sales.CreditCard')


CREATE STATISTICS stat_Sales_CreditCard
ON Sales.CreditCard (ExpMonth)  

-- ExpMonth	tinyint -> int

-- !!! Msg 5074, Level 16, State 1, Line 89
-- The statistics 'stat_Sales_CreditCard' is dependent on column 'ExpMonth'.
-- !!! Msg 4922, Level 16, State 9, Line 89
-- ALTER TABLE ALTER COLUMN ExpMonth failed because one or more objects access this column.

ALTER TABLE Sales.CreditCard
ALTER COLUMN ExpMonth int

SELECT object_id, name, stats_id, auto_created, user_created, auto_drop FROM sys.stats 
WHERE object_id = object_id('Sales.CreditCard')

-- SQL Server 2022
UPDATE STATISTICS Sales.CreditCard stat_Sales_CreditCard WITH AUTO_DROP = ON

SELECT object_id, name, stats_id, auto_created, user_created, auto_drop FROM sys.stats 
WHERE object_id = object_id('Sales.CreditCard')

ALTER TABLE Sales.CreditCard
ALTER COLUMN ExpMonth int

ALTER TABLE Sales.CreditCard ALTER COLUMN ExpMonth tinyint


-- SQL Server 2022
CREATE STATISTICS stat_Sales_CreditCard
ON Sales.CreditCard (ExpMonth) WITH AUTO_DROP = ON

SELECT object_id, name, stats_id, auto_created, user_created, auto_drop FROM sys.stats 
WHERE object_id = object_id('Sales.CreditCard')



-- Cleanup
ALTER TABLE Sales.CreditCard ALTER COLUMN ExpMonth tinyint

DROP STATISTICS Sales.CreditCard.stat_Sales_CreditCard



