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

