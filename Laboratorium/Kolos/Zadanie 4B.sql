/*
 ________________
< Wersja numer 2 >
 ----------------
  \
   \   \
        \ /\
        ( )
      .( o ).
******/
-- Za ten WITH jest 0,75 PKT
WITH Temp(SourceCity, DestinationCity, Distance, Crumb) AS(
	-- Loty bezpośrednie
	SELECT 
		R.SourceCity, 
		R.DestinationCity, 
		R.Distance, 
		R.SourceCity || '->' || R.DestinationCity 
	FROM 
		RouteDist R
		
	UNION ALL
	
	-- Loty pośrednie (1 przesiadka)
	SELECT 
		R1.SourceCity, 
		R2.DestinationCity, 
		R1.Distance + R2.Distance, 
		R1.SourceCity || '->' || R1.DestinationCity || '->' || R2.DestinationCity 
	FROM 
		RouteDist R1 
		INNER JOIN RouteDist R2 ON R1.DestinationID = R2.SourceID	
		
	UNION ALL
	
	-- Loty pośrednie (2 przesiadki)
	SELECT 
		R1.SourceCity, 
		R3.DestinationCity, 
		R1.Distance + R2.Distance + R3.Distance, 
		R1.SourceCity || '->' || R1.DestinationCity || '->' || R2.DestinationCity || '->' || R3.DestinationCity 
	FROM 
		RouteDist R1 
		INNER JOIN RouteDist R2 ON R1.DestinationID = R2.SourceID
		INNER JOIN RouteDist R3 ON R2.DestinationID = R3.SourceID		
)
-- Wybieramy trasę oraz najkrótszą z nich
SELECT 
	Crumb,
	MIN(Distance)	
FROM 
	Temp 
WHERE 
	SourceCity = 'Rzeszow'			-- Zaczynające się w Rzeszow
	AND DestinationCity = 'Tokyo'	-- Kończące się w Tokyo
GROUP BY
	Crumb							-- Grupowanie po trasach
HAVING 
	COUNT(*) > 1					-- Takie które dostępne są z kilku lotnisk
ORDER BY 
	Distance						-- Sortowanie po dystansie
LIMIT 10;							-- Tylko 10