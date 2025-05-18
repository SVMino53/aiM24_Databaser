USE AI24

/*

A schema in SQL could be thought of as a logical container or namespace within a database that holds related object, such as Tables, Views etc.

Schemas are quite important when it comes to organisation and e.g., grouping related tables together.
Tables with relations to oneother, in one way or another, would then get the same prefix to their name (e.g., HR.Employees, HR.Salaries, Sales.Employees, Sales.Orders, Sales.Products)

Schemas are also important for security reasons, where a database administrator can control access and permission to tables (based on their prefix) on
individual employee level. An admin could thus e.g., give hr_manager access to all HR tables.

*/


/*

What i dbo?

dbo stands for Database Owner.

It is the default schema for any object created without explicitly naming a schema, unless overriden by user settings

*/


-- This creates a table prefixed by 'dbo' schema, by default

CREATE TABLE Brands(
	EmployeeID INT PRIMARY KEY,
	Name NVARCHAR(100)
);


-- The above is thus equivalent to

CREATE TABLE dbo.Brands(
	EmployeeID INT PRIMARY KEY,
	Name NVARCHAR(100)
);


-- Hands on explicit schema creation in T-SQL

CREATE SCHEMA Accounting;

CREATE TABLE Accounting.Accounts(             -- NOTE: this create command wouldn't have worked if we hadn't created the schema prior
	AccountID INT PRIMARY KEY,
	AccountName NVARCHAR(100),
	AccountType NVARCHAR(50)
);

-- We can view all existing schemas using the following

SELECT * FROM sys.schemas;


/*

Can I delete a schema?

Yes - but only if it is empty (i.e., it contains no objects like tables, views, etc.).

*/

DROP SCHEMA Accounting;     -- won't work since the schema contains a table, but will work if we delete the associated table(s) and re-run the command


-- EXPLICIT TABLE RELATIONS

/*

We'll now begin modelling a university system with the following tables

	Courses

	Departments (each course belongs to a department)

*/

-- Step 1. Create a new schema: University

CREATE SCHEMA University;

CREATE TABLE University.Departments(
	DepartmentID INT PRIMARY KEY,
	DepartmentName NVARCHAR(100)
);

CREATE TABLE University.Courses(
	CourseID INT PRIMARY KEY,
	CourseName NVARCHAR(100),
	DepartmentID INT               -- FOREIGN KEY referencing the Departments table
);

INSERT INTO University.Departments VALUES
(1, 'Computer Science'),
(2, 'Mathematics'),
(3, 'History');

INSERT INTO University.Courses VALUES
(1001, 'Data Structures', 1),
(1002, 'Linear Algebra', 2),
(1003, 'World History', 3);


SELECT * FROM University.Departments;
SELECT * FROM University.Courses;

-- Great, let's do some joins

SELECT 
	*
FROM
	University.Departments d JOIN University.Courses c ON d.DepartmentID = c.DepartmentID;

-- Cool. Okey. But notice that the relationship is ambigious, i.e., we as creators know about it but SQL doesn't!
-- When trying to create a diagram, we see that SQL won't recognize the relationship


-- Alright. Let's now re-implement the tables, but in the proper way 

DROP TABLE University.Courses;
DROP TABLE University.Departments;

CREATE TABLE University.Departments(
	DepartmentID INT PRIMARY KEY,
	DepartmentName NVARCHAR(100)
);

CREATE TABLE University.Courses(
	CourseID INT PRIMARY KEY,
	CourseName NVARCHAR(100),
	DepartmentID INT FOREIGN KEY REFERENCES University.Departments(DepartmentID)               
);


INSERT INTO University.Departments VALUES
(1, 'Computer Science'),
(2, 'Mathematics'),
(3, 'History');

INSERT INTO University.Courses VALUES
(1001, 'Data Structures', 1),
(1002, 'Linear Algebra', 2),
(1003, 'World History', 3);

SELECT * FROM University.Departments;
SELECT * FROM University.Courses;


-- On first glance it doesn't look like anything is different - but try creating a diagram now. It works (almost always)!

/*

The primary benefit of formalizing and making explicit existing relationships (apart from cool diagrams)
is that it makes it impossible to e.g., in our case to have courses for non-existing departments.

*/

INSERT INTO University.Courses VALUES (1007, 'General Relativity', 4);

/*

The operation above failed since we have a FOREGIN KEY constraint on the DepartmentID column
in the Courses table referecing DepartmentID column in the Departments table, hindering us from
creating courses having DepartmentID's with no corresponding department.

*/

INSERT INTO University.Departments VALUES (4, 'Physics');

SELECT * FROM University.Departments;
SELECT * FROM University.Courses;

/*

Importantly, it is only the table which has the FOREGIN KEY reference that is restricted from adding arbitrary values.
The other table, in our case department (which is being referenced to), is not restricted and we can add new departments as we see fit, with no courses necessarily asigned.

*/


-- What heppens if we try to delete rows in either table?

DELETE FROM University.Departments WHERE DepartmentID = 3;   -- Well, that didn't work.
															 -- The reason being that the rows we're trying to eliminate has dependancies

-- On the other hand, deleting from the REFERENCING table (in this case Courses) is no problem at all

DELETE FROM University.Courses WHERE DepartmentID = 3;

SELECT * FROM University.Departments;
SELECT * FROM University.Courses;

-- Importantly, we are allowed to delete row from the REFERENCED table (in this case departments) if those rows have no depencies!

DELETE FROM University.Departments WHERE DepartmentID = 3;     -- This now works, because the dependencies were deleted above

SELECT * FROM University.Departments;
SELECT * FROM University.Courses;


DROP TABLE University.Courses;
DROP TABLE University.Departments;


/*

ON DELETE CASCADE

Let's add some more dynamics to our related tables. Sometimes we'd like to be able to delete from a REFERENCED table, even though it might have
a dependency from another table (which references to it via FOREGIN KEY). We'll implement something called a cascading delete here.

*/

CREATE TABLE University.Departments(
	DepartmentID INT PRIMARY KEY,
	DepartmentName NVARCHAR(100)
);

CREATE TABLE University.Courses(
	CourseID INT PRIMARY KEY,
	CourseName NVARCHAR(100),
	DepartmentID INT FOREIGN KEY REFERENCES University.Departments(DepartmentID) ON DELETE CASCADE -- This will now automatically delete all rows in the Courses table,
																								   -- if the corresponding DepartmentID is deleted from the Departments table
);


INSERT INTO University.Departments VALUES
(1, 'Computer Science'),
(2, 'Mathematics'),
(3, 'History');

INSERT INTO University.Courses VALUES
(1001, 'Data Structures', 1),
(1002, 'Linear Algebra', 2),
(1003, 'Statistics', 2),
(1004, 'World History', 3);


SELECT * FROM University.Departments;
SELECT * FROM University.Courses;

-- Let's now again try to directly delete a department with a course attached (this didn't work before)

DELETE FROM University.Departments WHERE DepartmentID = 2;

SELECT * FROM University.Departments;
SELECT * FROM University.Courses;

/*

Awesome. Now, let's delete our tables once again an start afresh with a complete end-to-end case.

We'll expand our University schema with additonal tables

	Students

	Courses       (each course belongs to a department)

	Enrollments   (many-to-many via FK to both Students and Courses)

	Departments   

*/


DROP TABLE University.Courses;
DROP TABLE University.Departments;



CREATE TABLE University.Departments(
	DepartmentID INT PRIMARY KEY,
	DepartmentName NVARCHAR(100)
);

CREATE TABLE University.Students(
	StudentID INT PRIMARY KEY,
	FirstName NVARCHAR(50),
	LastName NVARCHAR(50)
);

CREATE TABLE University.Courses(
	CourseID INT PRIMARY KEY,
	CourseName NVARCHAR(100),
	DepartmentID INT FOREIGN KEY REFERENCES University.Departments(DepartmentID) ON DELETE CASCADE																							   
);

CREATE TABLE University.Enrollments(
	EnrollmentID INT PRIMARY KEY,
	StudentID INT FOREIGN KEY REFERENCES University.Students(StudentID),
    CourseID INT FOREIGN KEY REFERENCES University.Courses(CourseID) ON DELETE CASCADE, 
    EnrollDate DATE
);


INSERT INTO University.Departments VALUES
(1, 'Computer Science'),
(2, 'Mathematics'),
(3, 'History');


INSERT INTO University.Students VALUES
(101, 'Alice', 'Wong'),
(102, 'Bob', 'Martinez'),
(103, 'Charlie', 'Smith');

INSERT INTO University.Courses VALUES
(1001, 'Data Structures', 1),
(1002, 'Linear Algebra', 2),
(1003, 'World History', 3);

INSERT INTO University.Enrollments VALUES
(1, 101, 1001, '2024-09-01'),
(2, 101, 1002, '2024-09-02'),
(3, 102, 1003, '2024-09-01'),
(4, 103, 1001, '2024-09-03');


SELECT * FROM University.Departments;
SELECT * FROM University.Students;
SELECT * FROM University.Courses;
SELECT * FROM University.Enrollments;

-- Go ahead and create a diagram to visualize the relationships

/*

Problem 1:

What happens if we  try to delete the course Linear Algebra from the Courses table?

*/

DELETE FROM University.Courses WHERE CourseName = 'Linear Algebra';

SELECT * FROM University.Departments;
SELECT * FROM University.Students;
SELECT * FROM University.Courses;
SELECT * FROM University.Enrollments;

-- It works, and the delete is cascaded into the Enrollments table!

/*

Problem 2:

What happens if we try to delete the whole Computer Science Department?

*/

DELETE FROM University.Departments WHERE DepartmentName = 'Computer Science';


SELECT * FROM University.Departments;
SELECT * FROM University.Students;
SELECT * FROM University.Courses;
SELECT * FROM University.Enrollments;

-- It also works, and the delete is cascaded onto both the Courses and the Enrollments tables!

/*

Problem 3.

What happens if we try to delete a Student?

3a. a student not currently enrolled in any course
3b. a student that is still enrolled in an existing course

*/

-- 3a

DELETE FROM University.Students WHERE StudentID = 101; -- Gick bra!

SELECT * FROM University.Departments;
SELECT * FROM University.Students;
SELECT * FROM University.Courses;
SELECT * FROM University.Enrollments;

-- 3b

DELETE FROM University.Students WHERE StudentID = 102; -- tillåts ej!

SELECT * FROM University.Departments;
SELECT * FROM University.Students;
SELECT * FROM University.Courses;
SELECT * FROM University.Enrollments;