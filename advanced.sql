USE AI24

-- Tables

CREATE TABLE Students (
				StudentID INT PRIMARY KEY,
				Firstname NVARCHAR(50),
				LastName NVARCHAR(50),
				GradeLevel INT
				      )

CREATE TABLE Courses (
	            CourseID INT PRIMARY KEY,
				CourseName NVARCHAR(100),
				Teacher NVARCHAR(100)
				     )

CREATE TABLE Enrollments (
                EnrollmentID INT PRIMARY KEY,
				StudentID INT,
				CourseID INT,
				Score INT
				         )


-- Insert Students
INSERT INTO Students VALUES
(1, 'Alice', 'Johnson', 10),
(2, 'Bob', 'Smith', 10),
(3, 'Charlie', 'Lee', 11),
(4, 'Diana', 'Garcia', 11),
(5, 'Ethan', 'White', 12),
(6, 'Fiona', 'Brown', 12);

-- Insert Courses
INSERT INTO Courses VALUES
(101, 'Mathematics', 'Mr. Adams'),
(102, 'History', 'Ms. Brooks'),
(103, 'Biology', 'Dr. Clark'),
(104, 'English', 'Mrs. Davis'),
(105, 'Physics', 'Dr. Evans');

-- Insert Enrollments
INSERT INTO Enrollments VALUES
(1, 1, 101, 85),
(2, 1, 102, 90),
(3, 1, 103, 75),
(4, 2, 101, 78),
(5, 2, 104, 82),
(6, 3, 103, 88),
(7, 3, 105, 91),
(8, 4, 102, 85),
(9, 4, 101, 89),
(10, 5, 104, 95),
(11, 5, 105, 87),
(12, 6, 102, 90),
(13, 6, 103, 92);

SELECT * FROM Students
SELECT * FROM Courses
SELECT * FROM Enrollments


-- Find students who have scored more than the average score

SELECT 
	FirstName, LastName
FROM
	Students
WHERE 
	StudentID IN (
				  SELECT StudentID
				  FROM Enrollments
				  WHERE Score > (
				                 SELECT AVG(Score) FROM Enrollments
								 )
				 )

-- Get average scores per student using subquery as a table

SELECT
	s.FirstName,
	s.LastName,
	avgScores.AverageScore
FROM
	Students s JOIN (
					 SELECT StudentID, 
	                 AVG(Score) AS AverageScore
					 FROM Enrollments
					 GROUP BY StudentID
					 ) avgScores ON s.StudentID = avgScores.StudentID


-- CTE

-- A CTE is a temporary result defined with WITH, used to simplify complex queries and improve readability.

/*

WITH CTE_Name AS (
    SELECT ...
)
SELECT * FROM CTE_Name;

*/


-- Use CTE to calculate average scores per student

WITH StudentAverages AS (
	SELECT StudentID, AVG(Score) AS AvgScore
	FROM Enrollments
	GROUP BY StudentID
	                    )

SELECT s.FirstName, s.LastName, sa.AvgScore
FROM Students s JOIN StudentAverages sa ON s.StudentID = sa.StudentID


-- Find students with average score > 85

WITH HighAchievers AS (
	SELECT StudentID, AVG(Score) AS AvgScore
	FROM Enrollments
	GROUP BY StudentID
	HAVING AVG(Score) > 85
	                   )
SELECT s.FirstName, s.LastName, h.AvgScore
FROM Students s JOIN HighAchievers h ON s.StudentID = h.StudentID


-- List students with the courses they took and their scores

WITH StudentCourses AS (
		SELECT
			s.FirstName,
			s.LastName,
			c.Coursename,
			e.Score
		FROM Students s  
		JOIN Enrollments e ON s.StudentID = e.StudentID
		JOIN Courses c ON e.CourseID = c.CourseID
		               )

SELECT * FROM StudentCourses
ORDER BY LastName

-- First, calculate per-course average, then find students who beat it

WITH CourseAverages AS (
	SELECT CourseID, AVG(Score) AS AvgScore
	FROM Enrollments
	GROUP BY CourseID
	                   ),
    AboveAverageScores AS (
	SELECT e.StudentID, e.courseID, e.Score, ca.AvgScore
	FROM Enrollments e JOIN CourseAverages ca on e.CourseID = ca.CourseID
	                      )

SELECT 
	s.Firstname, s.LastName, c.CourseName, aas.StudentID, aas.CourseID, aas.Score, aas.AvgScore
FROM 
	AboveAverageScores aas 
	JOIN Students s ON aas.StudentID = s.StudentID
	JOIN Courses c ON aas.CourseID = c.CourseID
WHERE
	aas.Score > aas.AvgScore



-- Excercises can be solved using either SUBQUERIES OR CTE, up to you



-- Ecxercise 1: Find Students Enrolled in More Than two Courses

-- CTE

WITH Attendance AS (
	SELECT StudentID, COUNT(StudentID) AS NumCourses
	FROM Enrollments
	GROUP BY StudentID)

SELECT s.StudentID, s.Firstname, s.LastName, a.NumCourses
FROM Students s
	 JOIN Attendance a ON s.StudentID = a.StudentID
WHERE NumCourses > 2



-- Excercise 2: Show average score per course, along with teacher name

-- Subquery

SELECT c.CourseID, c.CourseName, acs.AvgScore, c.Teacher
FROM Courses c
	 JOIN (
		SELECT CourseID, ROUND(AVG(CAST(Score AS float)), 2) AS AvgScore
		FROM Enrollments
		GROUP BY CourseID) AS acs ON c.CourseID = acs.CourseID

-- CTE

WITH AvgCourseScore AS (
	SELECT CourseID, ROUND(AVG(CAST(Score AS float)), 2) AS AvgScore
	FROM Enrollments
	GROUP BY CourseID)

SELECT c.CourseID, c.CourseName, a.AvgScore, c.Teacher
FROM Courses c
	 JOIN AvgCourseScore a ON c.CourseID = a.CourseID



-- Excercise 3: Find students whose score is below the course average

-- Subquery

SELECT c.CourseID, c.CourseName, acvss.AvgScore, s.Firstname + ' ' + s.LastName AS [Name], e.Score
FROM Enrollments e
	JOIN (
		SELECT CourseID, ROUND(AVG(CAST(Score AS FLOAT)), 2) AS AvgScore
		FROM Enrollments
		GROUP BY CourseID
		) AS acvss ON e.CourseID = acvss.CourseID
	JOIN Courses c ON acvss.CourseID = c.CourseID
	JOIN Students s ON e.StudentID = s.StudentID
WHERE acvss.AvgScore > e.Score

-- CTE

WITH AvgCourseVsStudentScore AS (
	SELECT CourseID, ROUND(AVG(CAST(Score AS FLOAT)), 2) AS AvgScore
	FROM Enrollments
	GROUP BY CourseID)

SELECT c.CourseID, c.CourseName, acvss.AvgScore, s.Firstname + ' ' + s.LastName AS [Name], e.Score
FROM Enrollments e
	JOIN AvgCourseVsStudentScore acvss ON e.CourseID = acvss.CourseID
	JOIN Courses c ON acvss.CourseID = c.CourseID
	JOIN Students s ON e.StudentID = s.StudentID
WHERE acvss.AvgScore > e.Score



-- Excercise 4: List students who took 'Physics' and scored above 85.

-- Neither

SELECT s.Firstname, s.LastName, c.CourseName, e.Score
FROM Enrollments e
	JOIN Courses c ON e.CourseID = c.CourseID
	JOIN Students s ON e.StudentID = s.StudentID
WHERE c.CourseName = 'Physics' AND e.Score > 85



WITH FullNames AS (
	SELECT StudentID, Firstname + ' ' + LastName AS [Name]
	FROM Students)

SELECT c.CourseName, fn.Name, SUM(e.Score) AS TotalScore
FROM Enrollments e
	JOIN Courses c ON e.CourseID = c.CourseID
	JOIN FullNames fn ON e.StudentID = fn.StudentID
GROUP BY ROLLUP([Name], c.CourseName)
UNION
SELECT c.CourseName, fn.Name, SUM(e.Score) AS TotalScore
FROM Enrollments e
	JOIN Courses c ON e.CourseID = c.CourseID
	JOIN FullNames fn ON e.StudentID = fn.StudentID
GROUP BY ROLLUP(c.CourseName, [Name])