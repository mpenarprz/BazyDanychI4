/*
	Najprostsza rekursja w SQL
*/
WITH MY_TEMP(NUMBER) AS(
	SELECT 1
	UNION ALL
	SELECT NUMBER + 1 FROM MY_TEMP WHERE NUMBER < 10
)
SELECT * FROM MY_TEMP;

/*
	Częsty przypadek użycia rekursji
*/
WITH MY_TEMP(MY_DATE) AS(
	SELECT '2019-01-01'
	UNION ALL
	SELECT date(MY_DATE, '+1 day') FROM MY_TEMP WHERE MY_DATE < date('now')
)
SELECT MY_DATE FROM MY_TEMP;

/*
	Antywzorzec drzewa w SQL
*/
CREATE TABLE TREE(
	ID INT PRIMARY KEY,
	PARENT_ID INT REFERENCES TREE(ID),
	NAME VARCHAR(100)
);

INSERT INTO TREE VALUES(1, NULL, 'Stary dziad');
INSERT INTO TREE VALUES(2, 1, 'Main');
INSERT INTO TREE VALUES(3, 1, 'Cabel');
INSERT INTO TREE VALUES(4, 2, 'Pan Syn');
INSERT INTO TREE VALUES(5, 2, 'Pani Córka');