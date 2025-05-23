USE AI24

/*

SQL Constraints

SQL constraints are used to specify rules for the data in a table.

Constraints are used to limit the type of data that can go into a table. This ensures the accuracy and reliability 
of the data in the table. If there is any violation between the constraint and the data action, the action is aborted.

Constraints can be column level or table level. Column level constraints apply to a column, and table level constraints 
apply to the whole table.

The following constraints are commonly used in SQL:

    NOT NULL - Ensures that a column cannot have a NULL value
    UNIQUE - Ensures that all values in a column are different
    PRIMARY KEY - A combination of a NOT NULL and UNIQUE. Uniquely identifies each row in a table
    FOREIGN KEY - Prevents actions that would destroy links between tables
    CHECK - Ensures that the values in a column satisfies a specific condition
    DEFAULT - Sets a default value for a column if no value is specified

*/

CREATE TABLE Persons(
	ID INT PRIMARY KEY,
	FirstName NVARCHAR(30) DEFAULT 'Jane',
	LastName NVARCHAR(30) NOT NULL DEFAULT 'Doe',
	Age INT CHECK(Age>=18 AND Age<30)
);

INSERT INTO Persons (ID) VALUES (1);

SELECT * FROM Persons;

INSERT INTO Persons (ID, Age) VALUES (2, 35);  -- tillåts ej

INSERT INTO Persons (ID, Age) VALUES (2, 29);  -- tillåts

SELECT * FROM Persons;

INSERT INTO Persons (ID, FirstName, Age) VALUES (3, NULL, 25);

SELECT * FROM Persons;

INSERT INTO Persons (ID, FirstName, LastName, Age) VALUES (4, NULL, '', 25);

SELECT * FROM Persons;

-- Notera att vi kan bland annat lägga in nästintill godtyckliga restriktioner med hjälp av CHECK

CREATE TABLE Only_the_best_people(
	FirstName NVARCHAR(30) CHECK(FirstName LIKE 'a%'),
);

INSERT INTO Only_the_best_people VALUES('Ali');

SELECT * FROM Only_the_best_people;

INSERT INTO Only_the_best_people VALUES('Amir');

SELECT * FROM Only_the_best_people;

INSERT INTO Only_the_best_people VALUES('Rozann');

SELECT * FROM Only_the_best_people;


-- En till mycket praktiskt användbar default 

CREATE TABLE Purchases(
	ItemName NVARCHAR(30),
	PurchaseDate DATETIME DEFAULT GETDATE()
);

INSERT INTO Purchases (ItemName) VALUES ('Generic Proteinbar');

SELECT * FROM Purchases;