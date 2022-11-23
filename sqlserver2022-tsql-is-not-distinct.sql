/*
	SQL Server 2022 
	- IS [NOT] DISTINCT FROM

	libera@kursysql.pl
	https://www.kursysql.pl
    
*/

SELECT @@VERSION

CREATE TABLE #testsql2022 (ColA int, ColB int)
INSERT INTO #testsql2022 (ColA, ColB)
VALUES (0, 0), (0, 1), (0, NULL), (NULL, NULL)
SELECT * FROM #testsql2022

SELECT * FROM #testsql2022


/*
	Porównywanie dwóch wartości
*/

-- =	w wyniku tylko wartości, które w obu kolumnach są identycze, pomijając te w których występują NULL-e
SELECT * FROM #testsql2022
SELECT ColA, ColB, 'ColA = ColB' FROM #testsql2022 WHERE ColA = ColB

-- <>	w wyniku tylko wartości, które w obu kolumnach są różne, pomijając te w których występują NULL-e
SELECT * FROM #testsql2022
SELECT ColA, ColB, 'ColA <> ColB' FROM #testsql2022 WHERE ColA <> ColB

-- IS NOT DISTINCT FROM		w obu kolumnach identyczne wartości, w tym w obu wartości nieokreślone
SELECT * FROM #testsql2022
SELECT ColA, ColB, 'ColA IS NOT DISTINCT FROM ColB' FROM #testsql2022 WHERE ColA IS NOT DISTINCT FROM ColB

-- IS DISTINCT FROM		w obu kolumnach różne wartości, w tym jeśli jedną z nich jest wartość nieokreślona
SELECT * FROM #testsql2022
SELECT ColA, ColB, 'ColA IS DISTINCT FROM ColB' FROM #testsql2022 WHERE ColA IS DISTINCT FROM ColB


/*
	Porównywanie do wartości nieokreślonej (NULL)
*/
-- =/ <> NULL	porównanie do wartości nieokreślonej, zawsze daje w wyniku zbiór pusty
SELECT * FROM #testsql2022
SELECT ColA, ColB, 'ColA = NULL' FROM #testsql2022 WHERE ColA = NULL
SELECT ColA, ColB, 'ColA <> NULL' FROM #testsql2022 WHERE ColA <> NULL

-- IS NOT DISTINCT FROM	NULL	w pierwszej kolumnie wartość nieokreślona
SELECT * FROM #testsql2022
SELECT ColA, ColB, 'ColA IS NOT DISTINCT FROM NULL' FROM #testsql2022 WHERE ColA IS NOT DISTINCT FROM NULL

-- IS DISTINCT FROM NULL	w pierwszej kolumnie wartość inna niż NULL
SELECT * FROM #testsql2022
SELECT ColA, ColB, 'ColA IS DISTINCT FROM NULL' FROM #testsql2022 WHERE ColA IS DISTINCT FROM NULL


