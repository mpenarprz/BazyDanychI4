/*
 ___________________
< Utworzenie tabeli >
 -------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
******/
CREATE TABLE airline( 
	ID INT PRIMARY KEY,  -- Jak nie ma PK lub UNIQUE to obcinam punkty
	Name VARCHAR(100), 
	Alias VARCHAR(10), 
	IATA CHAR(2), 
	ICAO CHAR (3), 
	CallSign VARCHAR(10), 
	Country VARCHAR(20), 
	Active CHAR(1) CHECK(Active IN ('Y','N')) -- Jak tu nie ma CHAR(1) lub VARCHAR(1) lub... niech stracę... TEXT to obcinam pkt
);

/*
 _______________________
< Utworzenie ograniczeń >
 -----------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
****/

ALTER TABLE routes -- Jak jest coś innego niż ALTER to zjadam punkty jak grube dziecko ciastka
ADD CONSTRAINT xxx FOREIGN KEY AirlineID REFERENCES airline(ID);

-- Niepoprawne ale też akceptowałem
ALTER TABLE routes 
ADD FOREIGN KEY AirlineID REFERENCES airline(ID);

-- A nawet obejscie dla SQlite'a akceptowałem
ALTER TABLE routes 
ADD COLUMN AirlineID2 REFERENCES airline(ID);

-- lub w skrócie
ALTER TABLE routes 
ADD AirlineID2 REFERENCES airline(ID);