USE everyloop

CREATE TABLE Products
(
	ID int,
	Name nvarchar(50)
)

SELECT * FROM Products

INSERT INTO Products (ID, Name) VALUES(1, 'Ali')
INSERT INTO Products (Name) VALUES('Lovisa')


CREATE TABLE Products2
(
	ID int IDENTITY,
	Name nvarchar(50)
)

SELECT * FROM Products2

INSERT INTO Products2 (Name) VALUES('ALexander')
INSERT INTO Products2 (Name) VALUES('Hans')


-- Variabler

SELECT 
	*
FROM
	Users


DECLARE @ettnamn AS NVARCHAR(20)
SET @ettnamn = 'Alibaba'
PRINT @ettnamn


DECLARE @username AS NVARCHAR(15) = 'Sigge'   -- motsvarighet i Python: username = 'Misandra'
PRINT @username


SELECT
	*
FROM
	Users
WHERE
	FirstName = @username


-- Ett till exempel på variabler

DECLARE @user AS NVARCHAR(50)
DECLARE @password AS NVARCHAR(50)


SELECT TOP 1
	@user = UserName, @password = Password
FROM
	Users


PRINT @user
PRINT @password


-- ROWCOUNT (och andra inställningar man kan göra)

SELECT 
	*
INTO
	Users2
FROM
	Users

PRINT @@ROWCOUNT

SELECT
	*
FROM
	Users
WHERE
	UserName LIKE '[abc]%'

PRINT @@ROWCOUNT


-- temporära tabeller

DECLARE @people_in_da_house AS TABLE
(
name NVARCHAR(max),
age INT
);

SELECT * FROM @people_in_da_house

-- TIPS

SELECT 
	*
FROM
	GameOfThrones

DECLARE @my_variable AS NVARCHAR(max) = ''


SELECT
	@my_variable += 'Season' + CAST(Season AS NVARCHAR) + ' '
FROM
	GameOfThrones
GROUP BY
	Season

PRINT @my_variable

