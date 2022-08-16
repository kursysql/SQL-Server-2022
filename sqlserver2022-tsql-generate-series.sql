/*
	SQL Server 2022 
	- funkcja GENERATE_SERIES
	
	libera@kursysql.pl
	https://www.kursysql.pl
    
*/



ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 160
GO


USE AdventureWorks2019
GO



SELECT * FROM GENERATE_SERIES(1, 21)

SELECT value FROM GENERATE_SERIES(1, 21, 5)


-- ! 102 Incorrect syntax near '='.
-- SQL Server CTP 2.0
SELECT value FROM GENERATE_SERIES(START=1, STOP=21, STEP=5)


-- wartości decimal
SELECT value FROM GENERATE_SERIES(1.0, 10.0, 1.0)

SELECT value FROM GENERATE_SERIES(1.0, 10.0, 1.5)



-- wszystkie argumenty muszą być tego samego typu danych, co pierwszy (start)

-- ! Msg 8116, Level 16, State 3, Line 38
-- ! Argument data type int is invalid for argument 3 of generate_series function.
SELECT value FROM GENERATE_SERIES(1.0, 10.0, 1)

-- ! Msg 8116, Level 16, State 2, Line 42
-- ! Argument data type int is invalid for argument 2 of generate_series function.
SELECT value FROM GENERATE_SERIES(1.0, 10, 1.0)




-- wartości ujemne

SELECT value FROM GENERATE_SERIES(21, 1, -1)



-- pusty zbiór
SELECT value FROM GENERATE_SERIES(1, 21, -1)
SELECT value FROM GENERATE_SERIES(21, 1, 1)




-- poziom zgodności

ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 150
GO


-- ! Msg 208, Level 16, State 1, Line 68
-- ! Invalid object name 'GENERATE_SERIES'.
SELECT value FROM GENERATE_SERIES(1, 21)



ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 160
GO
