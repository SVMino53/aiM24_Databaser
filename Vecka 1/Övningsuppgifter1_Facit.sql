USE everyloop

/*

Ta ut data (select) fr�n tabellen GameOfThrones p� s�dant s�tt att ni f�r ut
en kolumn �Title� med titeln samt en kolumn �Episode� som visar episoder
och s�songer i formatet �S01E01�, �S01E02�, osv.
Tips: kolla upp funktionen format()

*/
 

SELECT
	Title,
	Season,
	EpisodeInSeason,
	'S' + RIGHT('0' + CAST(season AS NVARCHAR), 2) + 'E' + RIGHT('0' + CAST(EpisodeInSeason AS NVARCHAR), 2) AS 'EpisodeCode_v1',
	CONCAT('S', FORMAT(Season, '00'), 'E', FORMAT(episodeinseason, '00')) AS 'EpisodeCode_v2'
FROM 
	GameOfThrones

/*

Uppdatera (kopia p�) tabellen user och s�tt username f�r alla anv�ndare s�
den blir de 2 f�rsta bokst�verna i f�rnamnet, och de 2 f�rsta i efternamnet
(ist�llet f�r 3+3 som det �r i orginalet). Hela anv�ndarnamnet ska vara i sm�
bokst�ver.

*/

SELECT * INTO users2 FROM users

SELECT * FROM users2


UPDATE users2 SET UserName = LOWER(LEFT(FirstName, 2)) + LOWER(LEFT(LastName, 2)) 


SELECT 
	UserName,
	TRANSLATE(UserName, '���', 'aao')  
FROM 
	users2

DROP TABLE users2

/*

Uppdatera (kopia p�) tabellen airports s� att alla null-v�rden i kolumnerna
Time och DST byts ut mot �-�

*/

SELECT * INTO AirportsTwo FROM Airports

SELECT * FROM AirportsTwo

SELECT * FROM AirportsTwo WHERE Time IS NULL

SELECT COUNT(*) FROM AirportsTwo WHERE Time IS NULL
SELECT COUNT(*) FROM AirportsTwo WHERE DST IS NULL



UPDATE AirportsTwo SET DST = '-' WHERE DST IS NULL
UPDATE AirportsTwo SET Time = '-' WHERE Time IS NULL

SELECT * FROM AirportsTwo

DROP TABLE AirportsTwo

-- en till metod

SELECT * INTO Airports_copy FROM Airports

UPDATE Airports_copy SET Time = ISNULL(Time,'-'), DST = ISNULL(DST,'-')

SELECT * FROM Airports_copy

DROP TABLE Airports_copy


/*

Ta bort de rader fr�n (kopia p�) tabellen Elements d�r �Name� �r n�gon av
f�ljande: 'Erbium', 'Helium', 'Nitrogen', 'Platinum', 'Selenium', samt alla
rader d�r �Name� b�rjar p� n�gon av bokst�verna d, k, m, o, eller u.

*/

SELECT * INTO ElementsTwo FROM Elements

SELECT * FROM ElementsTwo


DELETE FROM 
	ElementsTwo
WHERE 
	Name IN('Erbium', 'Helium', 'Nitrogen', 'Platinum', 'Selenium') OR Name LIKE '[dkmou]%'

SELECT * FROM ElementsTwo

DROP TABLE ElementsTwo

/*

Skapa en ny tabell med alla rader fr�n tabellen Elements. Den nya tabellen
ska inneh�lla �Symbol� och �Name� fr�n orginalet, samt en tredje kolumn
med v�rdet �Yes� f�r de rader d�r �Name� b�rjar med bokst�verna i
�Symbol�, och �No� f�r de rader d�r de inte g�r det.
Ex: �He� -> �Helium� -> �Yes�, �Mg� -> �Magnesium� -> �No�.

*/

SELECT 
	symbol, 
	name,
	CASE 
		WHEN LEFT(name, len(symbol)) = symbol THEN 'Yes' 
		ELSE 'No' 
	END 
		AS match
INTO 
	elementsThree
FROM 
	elements;

SELECT * FROM ElementsThree

DROP TABLE elementsThree