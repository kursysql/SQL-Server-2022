/*
	SQL Server 2022 
	- funkcja TRIM, LTRIM, RTRIM
	
	libera@kursysql.pl
	https://www.kursysql.pl
    
*/


USE AdventureWorks2019

-- przed SQL Server 2017
SELECT LTRIM(RTRIM( '  test    '))


/*
	TRIM
*/

-- SQL Server 2017-2019
-- TRIM ( [ characters FROM ] string )

-- usuwanie spacji
SELECT '  test    '
SELECT TRIM ( '  test    ')
SELECT TRIM ( ' ' FROM  '   test    ' )

-- usuwanie nie tylko spacji
SELECT TRIM ( '#' FROM  '##test###' )
SELECT TRIM ( '#' FROM  ' # test # ' )

-- usuwanie spacji i #
SELECT TRIM ( ' #' FROM  ' # test # ' )



-- SQL Server 2022
-- TRIM ( [ LEADING | TRAILING | BOTH ] [characters FROM ] string )
SELECT TRIM ( LEADING ' #' FROM  ' # test # ' )
SELECT TRIM ( TRAILING ' #' FROM  ' # test # ' )
SELECT TRIM ( BOTH ' #' FROM  ' # test # ' )

-- compat level min 160
ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 150
GO
SELECT TRIM ( ' #' FROM  ' # test # ' )
GO

ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 160
GO



/*
	LTRIM
*/

-- SQL Server 2019
-- LTRIM ( character_expression )

SELECT '  # test #  '
UNION ALL
SELECT LTRIM ( '  # test #  ' )


-- SQL Server 2022
-- LTRIM ( character_expression , [ characters ] )

SELECT '  # test #  '
UNION ALL
SELECT LTRIM ( '  # test #  ' , '#')
UNION ALL
SELECT LTRIM ( '  # test #  ' , ' #')



/*
	RTRIM
*/

-- SQL Server 2019
-- RTRIM ( character_expression )

SELECT '  # test #  '
UNION ALL
SELECT RTRIM ( '  # test #  ' )


-- SQL Server 2022
-- RTRIM ( character_expression , [ characters ] )

SELECT '  # test #  '
UNION ALL
SELECT RTRIM ( '  # test #  ' , '#')
UNION ALL
SELECT RTRIM ( '  # test #  ' , ' #')

