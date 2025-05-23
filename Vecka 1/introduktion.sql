-- Radkommentar

USE everyloop

SELECT  
	*           -- Genom att välja * extraherar vi samtliga kolumner
FROM 
	dbo.Users   


SELECT
	ID, UserName, Password  -- Välj enbart specifika kolumner
FROM
	dbo.Users


SELECT TOP 10               -- Begränsa till översta X rader
	ID, UserName, Password
FROM
	dbo.Users


SELECT
	*
FROM
	dbo.Users
WHERE
	FirstName = 'Johanna'   -- Endast de rader där FirstName är Johanna


SELECT 
	*
FROM
	dbo.GameOfThrones
WHERE 
	Season = 1 AND [Directed by]='Brian Kirk'  -- Endast de rader som uppfyller följande villkor


SELECT 
	*
FROM
	dbo.GameOfThrones
WHERE
	[Directed by]='Brian Kirk' OR [Directed by]='Tim Van Patten' OR [Directed by]='Alan Taylor'  -- Ganska ineffektivt


SELECT 
	*
FROM
	dbo.GameOfThrones
WHERE
	[Directed by] IN ('Brian Kirk', 'Tim Van Patten', 'Alan Taylor')  -- Effektivt när man vill filtrera på fler värden av en kolumn


SELECT
	*
FROM
	dbo.GameOfThrones
WHERE
	Season BETWEEN 2 AND 4


SELECT
	*
FROM
	dbo.Airports
WHERE 
	IATA BETWEEN 'AAF' AND 'AAJ'  -- AAF, AAG, AAH, AAI, AAJ


SELECT
	*
FROM
	dbo.GameOfThrones
WHERE
	[Directed by] LIKE 'D%'


SELECT
	*
FROM
	dbo.GameOfThrones
WHERE
	[Directed by] LIKE '%R'
	

SELECT
	*
FROM
	dbo.Airports
WHERE 
	IATA LIKE '[acf]_q'


SELECT
	*
FROM
	dbo.Airports
WHERE 
	IATA LIKE '[acf]_[q-z]'


SELECT
	* 
FROM 
	dbo.GameOfThrones
WHERE
	[Directed by] LIKE '[ABC]%[A-P]'


SELECT
	* 
FROM 
	dbo.GameOfThrones
WHERE
	[Directed by] LIKE '%Ali%'


SELECT
	*
FROM
	dbo.GameOfThrones
ORDER BY
	[Directed by]        -- Sorterar på vald kolumn, default ascending


SELECT
	*
FROM
	dbo.GameOfThrones
ORDER BY
	[Directed by] ASC    -- Sorterar på vald kolumn, med ascending specifierad


SELECT
	*
FROM
	dbo.GameOfThrones
ORDER BY
	[Directed by] DESC    -- Sorterar på vald kolumn, med descending ordning


SELECT
	*
FROM
	dbo.GameOfThrones
ORDER BY
	[U.S. viewers(millions)] DESC


SELECT 
	*
FROM
	dbo.GameOfThrones
WHERE
	[Directed by] LIKE 'D%'
ORDER BY
	[U.S. viewers(millions)] DESC


SELECT
	Title AS [Episode Name], [Directed by] AS Director
FROM
	dbo.GameOfThrones


SELECT DISTINCT
	[Directed by]
FROM
	dbo.GameOfThrones

-- Union nedan

SELECT
	FirstName, Lastname
FROM
	dbo.Users

UNION ALL

SELECT
	Title, [Directed by]
FROM
	dbo.GameOfThrones

-- Slut union all

SELECT
	FirstName, CASE
				WHEN LEN(FirstName) <= 4 THEN 'Kort'
				WHEN LEN(FirstName) >= 8 THEN 'Långt'
				ELSE 'Mellan'
			   END
			   AS 'NamnLängd'
FROM
	dbo.Users

	
