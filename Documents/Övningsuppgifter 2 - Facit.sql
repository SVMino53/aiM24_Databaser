/*

Ta ut (select) en rad för varje (unik) period i tabellen ”Elements” med
följande kolumner: ”period”, ”from” med lägsta atomnumret i perioden,
”to” med högsta atomnumret i perioden, ”average isotopes” med
genomsnittligt antal isotoper visat med 2 decimaler, ”symbols” med en
kommaseparerad lista av alla ämnen i perioden.

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

För varje stad som har 2 eller fler kunder i tabellen Customers, ta ut
(select) följande kolumner: ”Region”, ”Country”, ”City”, samt
”Customers” som anger hur många kunder som finns i staden.

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

Skapa en varchar-variabel och skriv en select-sats som sätter värdet:
”Säsong 1 sändes från april till juni 2011. Totalt
sändes 10 avsnitt, som i genomsnitt sågs av 2.5
miljoner människor i USA.”, följt av radbyte/char(13), följt av
”Säsong 2 sändes …” osv.
När du sedan skriver (print) variabeln till messages ska du alltså få en rad
för varje säsong enligt ovan, med data sammanställt från tabellen
GameOfThrones.
Tips: Ange ’sv’ som tredje parameter i format() för svenska månader.

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
 
SELECT @summary = STRING_AGG(CONCAT('Säsong ', Season, ' sändes från ', StartMonth, ' till ', EndMonthYear, 
                                    '. Totalt sändes ', EpisodeCount, ' avsnitt, som i genomsnitt sågs av ', 
                                    CAST(AvgViewers AS DECIMAL(10, 1)), ' miljoner människor i USA.'), CHAR(10))
       WITHIN GROUP (ORDER BY Season)
  FROM SeasonSummary;
 
PRINT @summary;


-- 2 

select * from GameOfThrones

DECLARE @hejhej NVARCHAR(max)
SET @hejhej =''
 
SELECT
@hejhej += 'Säsong ' + CAST(season AS NVARCHAR) + ' Sändes från ' + 
(MIN(FORMAT([Original air date],'MMMM','sv'))) + ' till ' +
(MAX(FORMAT([Original air date],'Y','sv'))) +
'. Totalt sändes '+  CAST(COUNT(episodeinseason) AS NVARCHAR) +
' avsnitt, som i genomsnitt sågs av  ' + CAST(ROUND(AVG([U.S. viewers(millions)]),2) AS NVARCHAR) +
' miljoner människor i USA. ' + CHAR(10)
 
FROM GameOfThrones
GROUP BY Season
 
print @hejhej


/*

Ta ut (select) alla användare i tabellen ”Users” så du får tre kolumner:
”Namn” som har fulla namnet; ”Ålder” som visar hur många år personen
är idag (ex. ’45 år’); ”Kön” som visar om det är en man eller kvinna.
Sortera raderna efter för- och efternamn.

*/


SELECT 
	ID,
	firstname + ' ' + lastname AS namn,
	RIGHT((YEAR(GETDATE()) - LEFT(ID, 2)), 2) AS ålder,
	SUBSTRING(ID, 3, 4),   -- plocka ut ID substring med start på position 3 och total längd 4
	SUBSTRING(ID, 10, 1),  -- plocka ut ID substring på position 10 (endast en karaktär) 
	CASE WHEN 
		SUBSTRING(ID, 10, 1) % 2 = 0 THEN 'kvinna' -- OBS, kunskap om personnummer här
		ELSE 'man' 
		END AS kön
FROM 
	users;

/*

Ta ut en lista över regioner i tabellen ”Countries” där det för varje region
framgår regionens namn, antal länder i regionen, totalt antal invånare,
total area, befolkningstätheten med 2 decimaler, samt
spädbarnsdödligheten per 100.000 födslar avrundat till heltal

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

Från tabellen ”Airports”, gruppera per land och ta ut kolumner som visar:
land, antal flygplatser (IATA-koder), antal som saknar ICAO-kod, samt hur
många procent av flygplatserna i varje land som saknar ICAO-kod.

*/

select * from Airports

select 
[Location served],
REVERSE([Location served]) as Reversed
from Airports


-- Skapa kopia och lägg till kolumnen "Country"
SELECT
	*,
	SUBSTRING([Location served], LEN([Location served]) - CHARINDEX(',', REVERSE([Location served])) + 3, LEN([Location served])) 
	AS Country
INTO AirportsCopy	
FROM Airports;

 
-- I de fall då vi bara har landsnamn i Location served har vi nu bara tomma strängar (eftersom det inte finns några kommatecken). Fixa det.
UPDATE AirportsCopy
SET Country = [Location served]
WHERE LEN(Country) = 0;

select * from AirportsCopy
 
-- Ta bort CHAR(160) (whitespace som inte går att "trimma bort")
UPDATE AirportsCopy
SET Country = REPLACE(Country, CHAR(160), '')
WHERE LEFT(Country, 1) = CHAR(160);
 
-- Fixa konstiga "United States"-värden
UPDATE AirportsCopy
SET Country = 'United States'
WHERE Country LIKE '%United States%';
 
-- Byt ut siffror mot mellanslag
UPDATE AirportsCopy
SET Country = TRANSLATE(Country, '123456789', REPLICATE(' ', 9))
 

-- Ta bort mellanslag före och efter sträng (som tillkom när vi körde TRANSLATE)
UPDATE AirportsCopy
SET Country = TRIM(Country);

select '   ali  ', TRIM('   ali  ')  -- visualisering av TRIM (tar bort leading and trailing spaces)
 
select * from AirportsCopy


SELECT
	Country,
	COUNT(IATA) AS [Number of airports],
	COUNT(*) - COUNT(ICAO) AS [Number of airports without ICAO], -- COUNT(*) - COUNT(kolumn) används för att beräkna antalet null-rader i given kolumn
	ROUND(CAST((COUNT(*) - COUNT(ICAO)) AS FLOAT) / CAST(COUNT(IATA) AS FLOAT) * 100, 2) AS [% of airports without ICAO]
FROM AirportsCopy
GROUP BY Country
ORDER BY [Number of airports] DESC;



