USE everyloop

/*

Ta ut data (select) från tabellen GameOfThrones på sådant sätt att ni får ut
en kolumn ’Title’ med titeln samt en kolumn ’Episode’ som visar episoder
och säsonger i formatet ”S01E01”, ”S01E02”, osv.
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

Uppdatera (kopia på) tabellen user och sätt username för alla användare så
den blir de 2 första bokstäverna i förnamnet, och de 2 första i efternamnet
(istället för 3+3 som det är i orginalet). Hela användarnamnet ska vara i små
bokstäver.

*/

SELECT * INTO users2 FROM users

SELECT * FROM users2


UPDATE users2 SET UserName = LOWER(LEFT(FirstName, 2)) + LOWER(LEFT(LastName, 2)) 


SELECT 
	UserName,
	TRANSLATE(UserName, 'åäö', 'aao')  
FROM 
	users2

DROP TABLE users2

/*

Uppdatera (kopia på) tabellen airports så att alla null-värden i kolumnerna
Time och DST byts ut mot ’-’

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

Ta bort de rader från (kopia på) tabellen Elements där ”Name” är någon av
följande: 'Erbium', 'Helium', 'Nitrogen', 'Platinum', 'Selenium', samt alla
rader där ”Name” börjar på någon av bokstäverna d, k, m, o, eller u.

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

Skapa en ny tabell med alla rader från tabellen Elements. Den nya tabellen
ska innehålla ”Symbol” och ”Name” från orginalet, samt en tredje kolumn
med värdet ’Yes’ för de rader där ”Name” börjar med bokstäverna i
”Symbol”, och ’No’ för de rader där de inte gör det.
Ex: ’He’ -> ’Helium’ -> ’Yes’, ’Mg’ -> ’Magnesium’ -> ’No’.

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