USE everyloop

SELECT 
	Season, 
	EpisodeInSeason,
	[U.S. viewers(millions)],
	Title
FROM
	GameOfThrones

SELECT
	AVG([U.S. viewers(millions)]) as [Average viewers in total per episode (millions)],
	STDEV([U.S. viewers(millions)]) as [Stdev viewers in total per episode (millions)],
	SUM([U.S. viewers(millions)]) as [Total viewers over all episode (millions)],
	STRING_AGG(Title, ' | ') AS [Titles concatinated]
FROM
	GameOfThrones


-- nedan kommer ej funka pga av kombination av aggregate funktion samt ej aggregate funktion
-- uppstår en konflikt i storleken på det som returneras


SELECT
	Title,
	AVG([U.S. viewers(millions)]) AS [Average viewers in total per episode (millions)]
FROM 
	GameOfThrones

-- COUNT

SELECT * FROM Users

-- COUNT(*) | Counts all rows, even if some columns have NULL values
-- COUNT(column_name) | Counts only the rows where that specific column is NOT NULL
-- COUNT(DISTINCT column_name) | Counts the unique non-NULL values in that column

SELECT
	COUNT(*)
FROM
	Users


SELECT
	COUNT(UserName) AS [Number of users]
FROM
	Users


SELECT
	COUNT(DISTINCT UserName) AS [Number of users]
FROM
	Users


SELECT
	COUNT(DISTINCT UserName) AS [Number of users]
FROM
	Users
WHERE
	UserName LIKE '[ABC]%'


-- GROUP BY

SELECT * FROM GameOfThrones

SELECT
	Season,
	AVG([U.S. viewers(millions)]) as [Average viewers in total per episode (millions)],
	STDEV([U.S. viewers(millions)]) as [Stdev viewers in total per episode (millions)],
	SUM([U.S. viewers(millions)]) as [Total viewers over all episode (millions)],
	STRING_AGG(Title, ' | ') AS [Titles concatinated],
	COUNT(*) AS [Number of episodes in Season]
FROM
	GameOfThrones
GROUP BY
	Season


-- Mer GROUP BY

SELECT * FROM company.orders


SELECT
	ShipRegion,
	COUNT(*) as [Number of transports]
FROM
	company.orders
GROUP BY
	ShipRegion


SELECT
	ShipRegion,
	ShipCountry,
	COUNT(*) as [Number of transports]
FROM
	company.orders
GROUP BY
	ShipRegion, ShipCountry


SELECT
	ShipRegion,
	ShipCountry,
	ShipCity,
	COUNT(*) as [Number of transports]
FROM
	company.orders
GROUP BY
	ShipRegion, ShipCountry, ShipCity


-- GROUP BY, ORDER BY

SELECT
	ShipRegion,
	ShipCountry,
	ShipCity,
	COUNT(*) as [Number of transports]
FROM
	company.orders
GROUP BY
	ShipRegion, ShipCountry, ShipCity
ORDER BY
	ShipRegion ASC, ShipCity DESC


-- HAVING (som WHERE, men används tillsammans med GROUP BY)


SELECT * FROM Countries


SELECT
	Region,
	SUM(CAST(Population as bigint)) as [Total pop]
FROM
	Countries
GROUP BY
	Region


SELECT
	Region,
	SUM(CAST(Population as bigint)) as [Total pop]
FROM
	Countries
GROUP BY
	Region
HAVING
	Region LIKE '[ABC]%'
	




