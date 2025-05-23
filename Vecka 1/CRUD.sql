USE everyloop

SELECT 
	*
FROM
	dbo.Users

SELECT
	*
FROM
	Users        -- beh�ver ej skriva ut dbo. i tabellnamn, ty dbo �r standardschema (mer om detta senare)


SELECT
	ID,
	FirstName,
	LastName,
	FirstName + ' ' + LastName as FullName  -- generera en ny kolumn i v� returnerade vy (obs, �ndrar ej i sj�lva tabellen)
FROM
	Users


-- SELECT INTO (skapa en ny tabell, fr�n en befintlig tabell)

SELECT
	*
INTO 
	Users2
FROM 
	Users


SELECT
	*
FROM
	Users2


-- DROP TABLE (l�t oss radera den nyligen skapade tabellen)

DROP TABLE Users2

--

SELECT
	Id,
	FirstName,
	LastName,
	FirstName + ' ' + LastName AS FullName
INTO 
	Users2
FROM 
	Users


SELECT * FROM Users2

-- L�t oss skapa en till tabell som heter GoTs01, som bara inneh�ller episodes fr�n s�song 1

SELECT * FROM GameOfThrones


SELECT
	*
INTO 
	GoTs01
FROM
	GameOfThrones
WHERE
	Season = 1

SELECT * FROM GoTs01	


-- INSERT INTO (l�gg till rader till en befintlig tabell)

SELECT * FROM Users2


INSERT INTO Users2 (ID, FirstName, LastName, FullName) VALUES('1', 'Ali', 'Leylani', 'Ali Leylani')
INSERT INTO Users2 VALUES('1', 'Ali', 'Leylani', 'Ali Leylani')
INSERT INTO Users2 (ID, FirstName, LastName) VALUES('1', 'Ali', 'Leylani')

INSERT INTO Users2 (FirstName, LastName) VALUES('Ali', 'Leylani')  -- kommer ge error, eftersom att kolumnen Id ej till�ter NULL


SELECT Id, FirstName FROM Users2
ORDER BY Id ASC

DELETE FROM Users2 WHERE Id = '1'

SELECT Id, FirstName FROM Users2
ORDER BY Id ASC


-- TRUNCATE TABLE (radera alla rader fr�n en befintlig tabell)

SELECT * FROM Users


SELECT
	FirstName as 'UserName',
	LastName as 'PassWord'
INTO
	UserCredentials
FROM 
	Users


SELECT * FROM UserCredentials

TRUNCATE TABLE UserCredentials

SELECT * FROM UserCredentials

-- INSERT INTO SELECT FROM (s�tta in v�rden till en befintlig tabell, fr�n en annan tabell, givet vissa villkor


SELECT * FROM GameOfThrones

SELECT * FROM UserCredentials


INSERT INTO UserCredentials (UserName, PassWord)
SELECT 
	Season, Title
FROM GameOfThrones
WHERE Season < 7

DROP TABLE UserCredentials


-- UPDATE (uppdatera v�rden i en befintlig kolumn)


SELECT * FROM Users2

INSERT INTO Users2 (ID, FirstName, LastName) VALUES('1', 'Ali', 'Leylani')

UPDATE Users2 SET FullName = 'Ali Leylani' WHERE Id = '1'


SELECT
	ID,
	FirstName,
	LastName,
	FirstName + ' ' + LastName AS FullName,
	FirstName + ' ' + LastName + '' + LastName AS Email
INTO
	Users3
FROM
	Users


SELECT * FROM Users3


-- MINIUPPGIFT 1
-- updatera Email till att anta formatet [f�rnamn]@gmail.com f�r alla rader d�r f�rnamnets l�ngd �r kortare �n 6 bokst�ver 
-- exempelvis ali@gmail.com


UPDATE Users3 SET Email = LOWER(FirstName) + '@gmail.com'
WHERE LEN(FirstName) < 6

SELECT * FROM Users3


-- CREATE TABLE (skapa ny tabell, fr�n ingenting)

CREATE TABLE Persons(
	Id int,
	FirstName nvarchar(20),
	LastName nvarchar(max)
	)

SELECT * FROM Persons


INSERT INTO Persons VALUES(1, 'Ali', 'Leylani')
INSERT INTO Persons (ID, FirstName) VALUES(1, 'Ali')
INSERT INTO Persons VALUES(0, 'Amir', 'Leylani')

DROP TABLE Persons

CREATE TABLE Persons(
	Id int,
	FirstName nvarchar(20) NOT NULL,
	LastName nvarchar(max)
	)

INSERT INTO Persons VALUES(1, 'Ali', 'Leylani')
INSERT INTO Persons (ID, FirstName) VALUES(1, 'Ali')

INSERT INTO Persons (ID, LastName) VALUES(1, 'Leylani')

DROP TABLE Persons

-- PRIMARY KEY

CREATE TABLE Persons(
	Id INT PRIMARY KEY,
	FirstName nvarchar(20) NOT NULL,
	LastName nvarchar(max)
	)

INSERT INTO Persons (Id, FirstName, LastName) VALUES(1, 'Ali', 'Leylani')
INSERT INTO Persons (Id, FirstName, LastName) VALUES(2, 'Ali', 'Leylani')

SELECT * FROM Persons