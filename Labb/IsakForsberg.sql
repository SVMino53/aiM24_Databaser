-- Databaser Labb - Isak Forsberg

USE everyloop


-- MoonMissions

-- Uppgift 1

SELECT
		Spacecraft,
		[Launch date],
		[Carrier rocket],
		Operator,
		[Mission type]
INTO
	SuccessfulMissions
FROM
	MoonMissions
WHERE
	Outcome LIKE '%success%';

SELECT
	*
FROM
	SuccessfulMissions;


-- Uppgift 2

UPDATE
	SuccessfulMissions
SET
	Operator = TRIM(Operator)
WHERE
	Operator LIKE '[ ]%';

SELECT
	*
FROM
	SuccessfulMissions;


-- Uppgift 3

SELECT
	Operator,
	[Mission type],
	COUNT(*) AS [Mission count]
FROM
	SuccessfulMissions
GROUP BY
	Operator, [Mission type]
HAVING
	COUNT(*) > 1
ORDER BY
	Operator, [Mission count];



-- Users

-- Uppgift 5

SELECT
	*,
	FirstName + ' ' + LastName AS Name,
	CASE
		WHEN ID LIKE '%[02468]_' THEN 'Female'
		ELSE 'Male'
	END AS Gender
INTO
	NewUsers
FROM
	Users;

SELECT
	*
FROM
	NewUsers


-- Uppgift 6

SELECT
	UserName,
	COUNT(*) - 1 AS DuplicateCount
FROM
	NewUsers
GROUP BY
	UserName
HAVING
	COUNT(*) > 1
ORDER BY
	UserName


-- Uppgift 7

UPDATE
	NewUsers
SET
	UserName = 'felbe1'
WHERE
	ID = '890701-1480';

UPDATE
	NewUsers
SET
	UserName = 'sigpe1'
WHERE
	ID = '630303-4894';

UPDATE
	NewUsers
SET
	UserName = 'sigpe2'
WHERE
	ID = '811008-5301';

SELECT
	*
FROM
	NewUsers;


-- Uppgift 8

DELETE FROM
	NewUsers
WHERE
	Gender = 'Female'
	AND ID LIKE '[0-6][0-9]%';

SELECT
	*
FROM
	NewUsers;


-- Uppgift 9

INSERT INTO NewUsers VALUES
	('971203-2391', 'barbie', 'ef7f2f1844f3f5e71a570d742bf49a7e', 'Bärra', 'Bieling', 'barra.bieling@gmail.com', '070-1740605', 'Bärra Bieling', 'Male');
-- Testpersonnummer hämtat från Skatteverkets hemsida :)

SELECT
	*
FROM
	NewUsers
WHERE
	ID = '971203-2391';


-- Company

-- Uppgift 11

SELECT
	p.Id,
	p.ProductName AS Product,
	s.CompanyName AS Supplier,
	c.CategoryName AS Category
FROM
	company.products p
	JOIN company.suppliers s ON p.SupplierId = s.Id
	JOIN company.categories c ON p.CategoryId = c.Id;


-- Uppgift 12

WITH EmployeeRegion AS (
	SELECT
		et.EmployeeId,
		r.RegionDescription
	FROM
		company.employee_territory et
		JOIN company.territories t ON et.TerritoryId = t.Id
		JOIN company.regions r ON t.RegionId = r.Id
	GROUP BY
		et.EmployeeId, r.RegionDescription)

SELECT
	er.RegionDescription AS Region,
	COUNT(er.RegionDescription) AS NumEmployees
FROM
	EmployeeRegion er
GROUP BY
	er.RegionDescription;