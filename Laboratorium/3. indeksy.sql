/*
Pomoc:
1) Do pokazywania planu wykonywania zapytania: 
EXPLAIN QUERY PLAN

2) Do powiększenia tabeli tracks:
INSERT INTO tracks(Name,AlbumId,MediaTypeId,GenreId,Composer,Milliseconds,Bytes,UnitPrice)
SELECT Name,AlbumId,MediaTypeId,GenreId,Composer,Milliseconds,Bytes,UnitPrice FROM tracks;

3) Tworzenie indeksów:
CREATE INDEX [nazwa] ON [tabela]([kolumna], [kolumna], ...);

W odwrotnej kolejności
CREATE INDEX [nazwa] ON [tabela]([kolumna] DESC);

4) Stopnie optymalizacji zapytań:
:((( 		SCAN + pomocnicza struktura
:(( 		SCAN
:( 			SCAN USING INDEX
:) 			SEEK USING INDEX
:)) 		SEEK USING COVERING INDEX

5) Info w SQLite: https://www.sqlite.org/draft/eqp.html
6) Funkcje w SQLite: https://www.sqlite.org/draft/lang_corefunc.html
*/



/*
QUERY 1: Wybór utworów o konkretnej długości i konkretnego kompozytora
*/
SELECT Name FROM tracks WHERE Milliseconds BETWEEN 0 AND 30000 AND Composer = 'x';

/*
QUERY 2: Posortowane nazwy utworów
*/
SELECT Name FROM tracks WHERE Milliseconds DESC; 

/*
QUERY 3: Wybór wszystkich kolumn dla kompozytora 'x'
*/
SELECT * FROM tracks WHERE Composer = 'x'

/*
QUERY 4: Wybór utworów o konkretnej długości
*/
SELECT 
	t.Name
FROM 
	tracks t
WHERE	
	LENGTH(t.Name) > 120;

/*
QUERY 5: Wybór adresu klienta o podanym nazwisku
*/
SELECT 
	Address 
FROM 
	customers 
WHERE 
	cast(LastName AS NVARCHAR(20)) = 'Tremblay';
	
/*
QUERY 6: Wybór utworów o podanym gatunku
*/
SELECT 
	t.Name
FROM 
	tracks t
	INNER JOIN genres g ON t.GenreId = g.GenreId
WHERE	
	g.Name = 'Pop'
	
/*
QUERY 7: Utwory i artyści muzyki pop piosenek do 30 sekund
*/
SELECT 
	t.Name,
	ar.Name
FROM
	tracks t
	INNER JOIN albums a ON a.AlbumId = t.AlbumId
	INNER JOIN artists ar ON ar.ArtistId = a.ArtistId
	INNER JOIN genres g ON t.GenreId = g.GenreId
WHERE
	g.Name = 'Pop'
	AND t.Milliseconds BETWEEN 0 AND 30000;
	
/*
QUERY 8: Zliczenie utworów w ramach gatunków
*/
SELECT 
	g.Name,
	COUNT(*)
FROM 
	tracks t
	INNER JOIN genres g ON t.GenreId = g.GenreId
GROUP BY
	g.Name;
	
/*
QUERY 9: Zliczenie w ramach gatunków kompozytorów
*/
SELECT 
	g.Name,
	COUNT(DISTINCT t.Composer)
FROM 
	tracks t
	INNER JOIN genres g ON t.GenreId = g.GenreId
GROUP BY
	g.Name;
	
/*
QUERY 10: Utwory których kompozytor jest wśród tabeli artists:
*/
SELECT 
	t.Name
FROM 
	tracks t
WHERE
	EXISTS(SELECT * FROM artists a WHERE t.Composer = a.Name)

/*
QUERY 11: Wszyscy artyści
*/
SELECT Name FROM artists
UNION
SELECT Composer FROM tracks

/*
QUERY 12: Gatunki kończące się na 'p'
*/
SELECT Name FROM genres WHERE Name LIKE '%p'

