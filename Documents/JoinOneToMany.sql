USE everyloop

DROP TABLE countries

CREATE TABLE countries
(
	id INT PRIMARY KEY,
	name NVARCHAR(20)
)

INSERT INTO countries VALUES(1, 'Sweden')
INSERT INTO countries VALUES(2, 'Denmark')
INSERT INTO countries VALUES(3, 'Norway')
INSERT INTO countries VALUES(4, 'Finland')

INSERT INTO countries VALUES(4, 'Germany')   -- kommer ej att gå, eftersom att primary key behöver vara unikt

SELECT * FROM countries

DROP TABLE cities

CREATE TABLE cities
(
	id INT PRIMARY KEY,
	name NVARCHAR(20),
	countryid INT        -- foreign key som ska referea till id columnen i countries tabellen
)

INSERT INTO cities VALUES(1, 'Stockholm', 1)
INSERT INTO cities VALUES(2, 'Gothenburg', 1)
INSERT INTO cities VALUES(3, 'Malmö', 1)
INSERT INTO cities VALUES(4, 'Copenhagen', 2)
INSERT INTO cities VALUES(5, 'Oslo', 3)
INSERT INTO cities VALUES(6, 'Bergen', 3)
INSERT INTO cities VALUES(7, 'London', 5)

-- show everything we have so far

SELECT * FROM countries
SELECT * FROM cities

-- JOIN (inner join by default)

SELECT
	*
FROM
	cities JOIN countries ON cities.countryid = countries.id   -- ni kan lika gärna skriva INNER JOIN (istället för bara JOIN) för att vara extra tydliga)


SELECT
	*
FROM
	countries JOIN cities ON cities.countryid = countries.id   -- ordningen på tabellerna i angivelsen spelar roll!


SELECT
--	*,           
	cities.name AS stad,
	countries.name AS land
FROM
	cities JOIN countries ON cities.countryid = countries.id


SELECT
	*,           
	ci.name AS stad,
	co.name AS land
FROM
	cities AS ci JOIN countries AS co ON ci.countryid = co.id     -- vi kan ge allias till våra tabeller, för att underlätta queryn
																  -- OBS! FROM sker innan SELECT


SELECT
	ci.name AS [City name],
	co.name AS [Country name],
	ci.name + ' ' + co.name AS [Combined]
FROM
	cities ci JOIN countries co ON ci.countryid = co.id


SELECT
	A.name AS [City name],
	B.name AS [Country name],
	A.name + ' ' + B.name AS [Combined]
FROM
	cities A JOIN countries B ON A.countryid = B.id


-- LEFT JOIN

SELECT * FROM countries
SELECT * FROM cities

SELECT
	ci.name AS [City name],
	co.name AS [Country name],
	ci.name + ' ' + co.name AS [Combined]
FROM
	cities ci LEFT JOIN countries co ON ci.countryid = co.id


SELECT
	ci.name AS [City name],
	co.name AS [Country name],
	ci.name + ' ' + co.name AS [Combined]
FROM
	countries co LEFT JOIN cities ci ON ci.countryid = co.id


-- RIGHT JOIN


SELECT
	ci.name AS [City name],
	co.name AS [Country name],
	ci.name + ' ' + co.name AS [Combined]
FROM
	cities ci RIGHT JOIN countries co ON ci.countryid = co.id


-- CROSS JOIN

SELECT
	a.name as [City name],
	b.name AS [Country name]
FROM
	cities a CROSS JOIN countries b


-- När användar man cross join? Wijdan tvingade mig visa er ett exempel x)

CREATE TABLE frukter
(
	id INT PRIMARY KEY,
	name NVARCHAR(20),
)

CREATE TABLE dryck
(
	id INT PRIMARY KEY,
	name NVARCHAR(20),
)

CREATE TABLE måltid
(
	id INT PRIMARY KEY,
	name NVARCHAR(20),
)

INSERT INTO frukter VALUES(1, 'Äpple')
INSERT INTO frukter VALUES(2, 'Banan')
INSERT INTO frukter VALUES(3, 'Apelsin')

INSERT INTO dryck VALUES(1, 'Palestine Coke')
INSERT INTO dryck VALUES(2, 'Zingo Zero')
INSERT INTO dryck VALUES(3, 'Pucko')

INSERT INTO måltid VALUES(1, 'Lasagne')
INSERT INTO måltid VALUES(2, 'Hamburgare')
INSERT INTO måltid VALUES(3, 'Kycklingsallad')



SELECT * FROM frukter
SELECT * FROM dryck
SELECT * FROM måltid


SELECT 
	f.name,
	d.name
FROM
	frukter f CROSS JOIN dryck d


SELECT
	m.name,
	d.name,
	f.name
FROM
	måltid m CROSS JOIN dryck d CROSS JOIN frukter f


-- JOIN combined with GROUP BY

SELECT 
	co.name AS 'Country',
	COUNT(ci.name) AS 'Number of cities',
	ISNULL(STRING_AGG(ci.name, ', '), '-') AS 'List of Cities'
FROM 
	cities ci RIGHT JOIN countries co ON ci.countryid = co.id
GROUP BY
	co.name
