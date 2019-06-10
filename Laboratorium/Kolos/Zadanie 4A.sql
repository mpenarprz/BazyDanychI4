/*
 ________________
< Wersja numer 1 >
 ----------------
  \
   \   \
        \ /\
        ( )
      .( o ).
******/
-- Za ten WITH jest 0,75 PKT
WITH Temp(SourceID, DestinationID, SourceCity, DestinationCity, Hops, Distance, Crumb) AS(
	-- Początek rekursji: Rzeszów do... dokądkolwiek
	SELECT 
		SourceID,
		DestinationID, 
		SourceCity, 
		DestinationCity, 
		0, 										-- Nie ma skoków / lot bezpośredni
		Distance, 								-- Dystans bezpośredni
		SourceCity || '->' || DestinationCity 	-- Trasa bezpośrednia
	FROM 
		RouteDist 
	WHERE 
		SourceCity = 'Rzeszow'
	UNION ALL
	-- Rekursja: Poszerzanie tras o kolejne 'skoki'
	SELECT
		T.SourceID,
		R.DestinationID, 
		T.SourceCity,	
		R.DestinationCity, 
		T.Hops + 1, 							-- Lot pośredni
		T.Distance + R.Distance, 				-- Dystans pośredni
		T.Crumb || '->' || R.DestinationCity	-- Trasa pośrednia
	FROM
		TEMP T
		INNER JOIN RouteDist R ON T.DestinationID = R.SourceID		
	WHERE
		Hops < 2								-- Ograniczenie liczby przesiadek... i także głębokości rekursji
)
-- Wybieramy trasę oraz najkrótszą z nich
SELECT 
	Crumb,
	MIN(Distance)	
FROM 
	Temp 
WHERE 
	DestinationCity = 'Tokyo'	-- Kończące się w Tokyo
GROUP BY
	Crumb						-- Grupowanie po trasach
HAVING 
	COUNT(*) > 1				-- Takie które dostępne są z kilku lotnisk
ORDER BY 
	Distance					-- Sortowanie po dystansie
LIMIT 10;						-- Tylko 10