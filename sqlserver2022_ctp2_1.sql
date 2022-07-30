/*
	SQL Server 2022 - CTP 1.2
	- funkcja DATETRUNC
	- IS [NOT] DISTINCT FROM

	libera@kursysql.pl
	https://www.kursysql.pl
    
*/


USE AdventureWorks2019
GO

/*
	Funkcja DATETRUNC()
*/

-- zaokrąglenie daty zwracanej przez funkcję GETDATE (typ danych datetime) do miesiąca 
SELECT GETDATE() AS input_date, 
	DATETRUNC(minute, GETDATE()) AS result_datetrunc, 
	SQL_VARIANT_PROPERTY(DATETRUNC(month, GETDATE()),'BaseType') AS result_basetype

	
-- zaokrąglenie daty zwracanej przez funkcję SYSDATETIME (typ danych datetime2) do miesiąca 
SELECT SYSDATETIME() AS input_date, 
	DATETRUNC(minute, SYSDATETIME()) AS result_datetrunc, 
	SQL_VARIANT_PROPERTY(DATETRUNC(month, SYSDATETIME()),'BaseType') AS result_basetype



CREATE TABLE #testctp21 (ColA int, ColB int)
INSERT INTO #testctp21 (ColA, ColB)
VALUES (0, 0), (0, 1), (0, NULL), (NULL, NULL)

SELECT * FROM #testctp21


/*
	Porównywanie dwóch wartości 
*/
-- =	w wyiku tylko wartości, które w obu kolumnach są identycze, pomijając te w których występują NULL-e
SELECT ColA, ColB, 'ColA = ColB' FROM #testctp21 WHERE ColA = ColB

-- <>	w wyiku tylko wartości, które w obu kolumnach są różne, pomijając te w których występują NULL-e
SELECT ColA, ColB, 'ColA <> ColB' FROM #testctp21 WHERE ColA <> ColB

-- IS NOT DISTINCT FROM		w obu kolumnach identyczne wartości, w tym w obu wartości nieokreślone
SELECT ColA, ColB, 'ColA IS NOT DISTINCT FROM ColB' FROM #testctp21 WHERE ColA IS NOT DISTINCT FROM ColB

-- IS DISTINCT FROM		w obu kolumnach różne wartości, w tym jeśli jedną z nich jest wartość nieokreślona
SELECT ColA, ColB, 'ColA IS DISTINCT FROM ColB' FROM #testctp21 WHERE ColA IS DISTINCT FROM ColB

/*
	Porównywanie do wartości nieokreślonej (NULL)
*/
-- =/ <> ULL	przyrównanie do wartości nieokreślonej, zawsze daje w wyniku zbiór pusty
SELECT ColA, ColB, 'ColA = NULL' FROM #testctp21 WHERE ColA = NULL
SELECT ColA, ColB, 'ColA <> NULL' FROM #testctp21 WHERE ColA <> NULL

-- IS NOT DISTINCT FROM	NULL	w pierwszej kolumnie wartość nieokreślona
SELECT ColA, ColB, 'ColA IS NOT DISTINCT FROM NULL' FROM #testctp21 WHERE ColA IS NOT DISTINCT FROM NULL

-- IS DISTINCT FROM NULL	w pierwszej kolumnie wartość inna niż NULL
SELECT ColA, ColB, 'ColA IS DISTINCT FROM NULL' FROM #testctp21 WHERE ColA IS DISTINCT FROM NULL

