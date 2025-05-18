/*

Ta ut (select) en rad f�r varje (unik) period i tabellen �Elements� med
f�ljande kolumner: �period�, �from� med l�gsta atomnumret i perioden,
�to� med h�gsta atomnumret i perioden, �average isotopes� med
genomsnittligt antal isotoper visat med 2 decimaler, �symbols� med en
kommaseparerad lista av alla �mnen i perioden.

*/

select * from Elements


SELECT 
	   Period,
       Min(Number) as "from",
	   MAX(Number) as "to",
	   AVG(Stableisotopes),
	   ROUND(AVG(CAST(Stableisotopes AS FLOAT)),2) as "IsotopAVG",
	   STRING_AGG(Symbol, ', ' ) WITHIN GROUP(ORDER BY Symbol) AS Symbols -- extra argument WITHIN GROUP(ORDER BY Symbol)
FROM 
	Elements
GROUP BY 
	Period

/*

F�r varje stad som har 2 eller fler kunder i tabellen Customers, ta ut
(select) f�ljande kolumner: �Region�, �Country�, �City�, samt
�Customers� som anger hur m�nga kunder som finns i staden.

*/

SELECT 
	Region, 
	Country, 
	City,
	COUNT(*) AS Customers
FROM 
	company.customers
GROUP BY 
	Region, 
	Country, 
	City
HAVING 
	COUNT(*) > 2;

/*

Skapa en varchar-variabel och skriv en select-sats som s�tter v�rdet:
�S�song 1 s�ndes fr�n april till juni 2011. Totalt
s�ndes 10 avsnitt, som i genomsnitt s�gs av 2.5
miljoner m�nniskor i USA.�, f�ljt av radbyte/char(13), f�ljt av
�S�song 2 s�ndes �� osv.
N�r du sedan skriver (print) variabeln till messages ska du allts� f� en rad
f�r varje s�song enligt ovan, med data sammanst�llt fr�n tabellen
GameOfThrones.
Tips: Ange �sv� som tredje parameter i format() f�r svenska m�nader.

*/


-- 1

DECLARE @summary NVARCHAR(MAX) = '';
 
WITH SeasonSummary AS (
	 SELECT	Season,
		    FORMAT(MIN([Original air date]), 'MMMM', 'sv-SE') AS StartMonth,
		    FORMAT(MAX([Original air date]), 'MMMM yyyy', 'sv-SE') AS EndMonthYear,
		    COUNT(*) AS EpisodeCount,
		    AVG(CAST([U.S. viewers(millions)] AS FLOAT)) AS AvgViewers
	   FROM GameOfThrones
	  GROUP BY Season
)
 
SELECT @summary = STRING_AGG(CONCAT('S�song ', Season, ' s�ndes fr�n ', StartMonth, ' till ', EndMonthYear, 
                                    '. Totalt s�ndes ', EpisodeCount, ' avsnitt, som i genomsnitt s�gs av ', 
                                    CAST(AvgViewers AS DECIMAL(10, 1)), ' miljoner m�nniskor i USA.'), CHAR(10))
       WITHIN GROUP (ORDER BY Season)
  FROM SeasonSummary;
 
PRINT @summary;


-- 2 

select * from GameOfThrones

DECLARE @hejhej NVARCHAR(max)
SET @hejhej =''
 
SELECT
@hejhej += 'S�song ' + CAST(season AS NVARCHAR) + ' S�ndes fr�n ' + 
(MIN(FORMAT([Original air date],'MMMM','sv'))) + ' till ' +
(MAX(FORMAT([Original air date],'Y','sv'))) +
'. Totalt s�ndes '+  CAST(COUNT(episodeinseason) AS NVARCHAR) +
' avsnitt, som i genomsnitt s�gs av  ' + CAST(ROUND(AVG([U.S. viewers(millions)]),2) AS NVARCHAR) +
' miljoner m�nniskor i USA. ' + CHAR(10)
 
FROM GameOfThrones
GROUP BY Season
 
print @hejhej


/*

Ta ut (select) alla anv�ndare i tabellen �Users� s� du f�r tre kolumner:
�Namn� som har fulla namnet; ��lder� som visar hur m�nga �r personen
�r idag (ex. �45 �r�); �K�n� som visar om det �r en man eller kvinna.
Sortera raderna efter f�r- och efternamn.

*/


SELECT 
	ID,
	firstname + ' ' + lastname AS namn,
	RIGHT((YEAR(GETDATE()) - LEFT(ID, 2)), 2) AS �lder,
	SUBSTRING(ID, 3, 4),   -- plocka ut ID substring med start p� position 3 och total l�ngd 4
	SUBSTRING(ID, 10, 1),  -- plocka ut ID substring p� position 10 (endast en karakt�r) 
	CASE WHEN 
		SUBSTRING(ID, 10, 1) % 2 = 0 THEN 'kvinna' -- OBS, kunskap om personnummer h�r
		ELSE 'man' 
		END AS k�n
FROM 
	users;

/*

Ta ut en lista �ver regioner i tabellen �Countries� d�r det f�r varje region
framg�r regionens namn, antal l�nder i regionen, totalt antal inv�nare,
total area, befolkningst�theten med 2 decimaler, samt
sp�dbarnsd�dligheten per 100.000 f�dslar avrundat till heltal

*/

SELECT
    Region AS "Regions name",
    COUNT(*) AS "Number of countries",
    SUM(CAST(Population AS BIGINT)) AS  "Total population",
    SUM(CAST([Area (sq# mi#)] AS BIGINT)) AS "Total area",
    ROUND((SUM(CAST(Population AS BIGINT))) / CAST(SUM(CAST([Area (sq# mi#)] AS BIGINT)) AS FLOAT), 2) AS "Population density",
    ROUND(AVG(CAST(REPLACE([Infant mortality (per 1000 births)], ',', '.') AS FLOAT)), 0) AS "Infant mortality"
FROM
    dbo.Countries
GROUP BY
    Region;


/*

Fr�n tabellen �Airports�, gruppera per land och ta ut kolumner som visar:
land, antal flygplatser (IATA-koder), antal som saknar ICAO-kod, samt hur
m�nga procent av flygplatserna i varje land som saknar ICAO-kod.

*/

select * from Airports

select 
[Location served],
REVERSE([Location served]) as Reversed
from Airports


-- Skapa kopia och l�gg till kolumnen "Country"
SELECT
	*,
	SUBSTRING([Location served], LEN([Location served]) - CHARINDEX(',', REVERSE([Location served])) + 3, LEN([Location served])) 
	AS Country
INTO AirportsCopy	
FROM Airports;

 
-- I de fall d� vi bara har landsnamn i Location served har vi nu bara tomma str�ngar (eftersom det inte finns n�gra kommatecken). Fixa det.
UPDATE AirportsCopy
SET Country = [Location served]
WHERE LEN(Country) = 0;

select * from AirportsCopy
 
-- Ta bort CHAR(160) (whitespace som inte g�r att "trimma bort")
UPDATE AirportsCopy
SET Country = REPLACE(Country, CHAR(160), '')
WHERE LEFT(Country, 1) = CHAR(160);
 
-- Fixa konstiga "United States"-v�rden
UPDATE AirportsCopy
SET Country = 'United States'
WHERE Country LIKE '%United States%';
 
-- Byt ut siffror mot mellanslag
UPDATE AirportsCopy
SET Country = TRANSLATE(Country, '123456789', REPLICATE(' ', 9))
 

-- Ta bort mellanslag f�re och efter str�ng (som tillkom n�r vi k�rde TRANSLATE)
UPDATE AirportsCopy
SET Country = TRIM(Country);

select '   ali  ', TRIM('   ali  ')  -- visualisering av TRIM (tar bort leading and trailing spaces)
 
select * from AirportsCopy


SELECT
	Country,
	COUNT(IATA) AS [Number of airports],
	COUNT(*) - COUNT(ICAO) AS [Number of airports without ICAO], -- COUNT(*) - COUNT(kolumn) anv�nds f�r att ber�kna antalet null-rader i given kolumn
	ROUND(CAST((COUNT(*) - COUNT(ICAO)) AS FLOAT) / CAST(COUNT(IATA) AS FLOAT) * 100, 2) AS [% of airports without ICAO]
FROM AirportsCopy
GROUP BY Country
ORDER BY [Number of airports] DESC;



