DROP TABLE courses

CREATE TABLE courses
(
	id INT,
	name NVARCHAR(MAX)
);

INSERT INTO courses VALUES (1, 'Python');
INSERT INTO courses VALUES (2, 'Algebra');
INSERT INTO courses VALUES (3, 'Databaser');
INSERT INTO courses VALUES (4, 'AI');

SELECT * FROM courses

DROP TABLE students

CREATE TABLE students
(
	id INT,
	name NVARCHAR(MAX)
);

INSERT INTO students VALUES (1, 'Arvid')
INSERT INTO students VALUES (2, 'Julian')
INSERT INTO students VALUES (3, 'Johan')
INSERT INTO students VALUES (4, 'Olha')
INSERT INTO students VALUES (5, 'Wijdan')

SELECT * FROM students

DROP TABLE coursesStudents

CREATE TABLE coursesStudents
(
	courseId INT,
	studentId INT
)

INSERT INTO coursesStudents VALUES (1, 1);
INSERT INTO coursesStudents VALUES (1, 2);
INSERT INTO coursesStudents VALUES (1, 3);
INSERT INTO coursesStudents VALUES (2, 1);
INSERT INTO coursesStudents VALUES (2, 2);
INSERT INTO coursesStudents VALUES (2, 3);
INSERT INTO coursesStudents VALUES (2, 4);
INSERT INTO coursesStudents VALUES (3, 2);
INSERT INTO coursesStudents VALUES (3, 4);

SELECT * FROM courses;
SELECT * FROM students;
SELECT * FROM coursesStudents;

SELECT
	*
FROM
	courses c 
	JOIN coursesStudents cs ON c.id = cs.courseId
	RIGHT JOIN students s ON s.id = cs.studentId


SELECT
	c.name AS 'Course',
	s.name AS 'Student'
FROM
	courses c 
	JOIN coursesStudents cs ON c.id = cs.courseId
	RIGHT JOIN students s ON s.id = cs.studentId



-- Miniuppgift 1
-- Skriv ut en tabell med en rad f�r varje kurs (dvs 4 rader totalt)
-- inkludera en kolumn som visar totalt antal elever f�r respektive kurs


SELECT
    c.name kurs,
    COUNT(s.name) antal
FROM
    courses c
    LEFT JOIN coursesStudents cs ON cs.courseId = c.id
    LEFT JOIN students s ON s.id = cs.studentId
GROUP BY 
	c.name;


-- Miniuppgift 2
-- Skriv ut en tabell med en rad f�r varje elev
-- inkludera en kolumn som anger elevnamn
-- + en kolumn som visar antalet kurser eleven l�ser
-- samt en kolumn som anger vilka kurser eleven l�ser

SELECT
    s.name AS 'student',
    COUNT(c.name) AS [number of courses],
    ISNULL(STRING_AGG(c.name, ' ,'), ('-'))AS 'list of courses'
FROM
    students AS s LEFT JOIN coursesStudents AS cs ON s.id = cs.studentId
    LEFT JOIN courses AS c ON c.id = cs.courseId
GROUP BY s.name