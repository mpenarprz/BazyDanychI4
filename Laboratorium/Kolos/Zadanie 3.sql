/*
 _____________________________________
< Za definicję widoku dawałem 0,1 pkt >
 -------------------------------------
    \
     \  /\/\
       \   /
       |  0 >>
       |___|
 __((_<|   |
(          |
(__________)
   |      |
   |      |
   /\     /\
******/
CREATE VIEW RouteDist AS 
SELECT 
	R.*, 
	A1.City AS SourceCity, 
	A2.City AS DestinationCity, 
	ABS(A1.Longitude - A2.Longitude) + ABS(A1.Latitude - A2.Latitude) AS Distance 
FROM 
	routes R 
	INNER JOIN airports A1 ON A1.AirportID = R.SourceID 
	INNER JOIN airports A2 ON A2.AirportID = R.DestinationID;