-- Library Management Project 2
CREATE DATABASE library_project_2

-- Creating Branch Table

DROP TABLE IF EXISTS Branch
CREATE TABLE Branch
	(
		branch_id VARCHAR(25) PRIMARY KEY,
		manager_id VARCHAR(10),
		branch_address VARCHAR(55),
		contact_no VARCHAR(20)
	)

ALTER TABLE Branch
ALTER COLUMN contact_no NVARCHAR(30)

DROP TABLE IF EXISTS Employees
CREATE TABLE Employees
	(
		emp_id VARCHAR(10) PRIMARY KEY,
		emp_name VARCHAR(25),
		position VARCHAR(15),
		salary INT,
		branch_id VARCHAR(25)	--Foreign Key
	)

DROP TABLE IF EXISTS Books
CREATE TABLE Books
	(
		isbn VARCHAR(50) PRIMARY KEY,
		book_title VARCHAR(80),
		category NVARCHAR(30),
		rental_price FLOAT,
		status VARCHAR(10),
		author VARCHAR(30),
		publisher VARCHAR(30)
	)

ALTER TABLE Books
ALTER COLUMN category NVARCHAR(100)

DROP TABLE IF EXISTS Members
CREATE TABLE Members
	(
		member_id VARCHAR(10) PRIMARY KEY,
		member_name VARCHAR(25),
		member_address VARCHAR(75),
		reg_date DATE
	)

DROP TABLE IF EXISTS [Issued Status]
CREATE TABLE [Issued Status]
	(
		issued_id VARCHAR(10) PRIMARY KEY,
		issued_member_id VARCHAR(10),	--Foreign Key
		issued_book_name VARCHAR(75),
		issued_date DATE,
		issued_book_isbn VARCHAR(50),	--Foreign Key
		issued_emp_id VARCHAR(10)	--Foreign Key
	)

DROP TABLE IF EXISTS [Return Status]
CREATE TABLE [Return Status]
	(
		return_id VARCHAR(10) PRIMARY KEY,
		issued_id VARCHAR(10),
		return_book_name VARCHAR(75),
		return_date DATE,
		return_book_isbn VARCHAR(20)
	)

ALTER TABLE [Issued Status]
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES Members(member_id)

ALTER TABLE [Issued Status]
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES Books(isbn)

ALTER TABLE [Issued Status]
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES Employees(emp_id)

ALTER TABLE Employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES Branch(branch_id)

ALTER TABLE [Return Status]
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES [Issued Status](issued_id)


-- INSERTING DATA

INSERT INTO [dbo].[Books]
SELECT *
FROM [dbo].[books_csv]


INSERT INTO [dbo].[Branch]
SELECT *
FROM [dbo].[branch_csv]

INSERT INTO [dbo].[Employees]
SELECT *
FROM [dbo].[employees_csv]

INSERT INTO [dbo].[Issued Status]
SELECT *
FROM [dbo].[issued_status_csv]

INSERT INTO [dbo].[Members]
SELECT *
FROM [dbo].[members_csv]


INSERT INTO [dbo].[Return Status]
SELECT *
FROM [dbo].[return_status_csv]


-- TASKS:

-- Task 1. Create a New Book Record "('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO Books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

-- Task 2: Update an Existing Member's Address

UPDATE Members
SET member_address = '125 Main St'
WHERE member_id = 'C101'

-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM [dbo].[Issued Status]
WHERE issued_id = 'IS121'

-- Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT *
FROM [dbo].[Issued Status]
WHERE issued_emp_id = 'E101'

-- Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT
	issued_emp_id,
	COUNT(issued_id) AS total_book_issued
FROM [Issued Status]
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1

-- Task 6: Generate Query Showing Each Book and Total Rental Count

SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM [dbo].[Issued Status] AS ist
JOIN Books AS b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title

-- Task 7. Retrieve All Books in a Specific Category:

SELECT *
FROM Books
WHERE category = 'Classic'

-- Task 8: Find Total Rental Income by Category:

SELECT 
	b.category,
	SUM(b.rental_price),
	COUNT(*) 
FROM [Issued Status] AS ist
JOIN Books AS b
ON b.isbn = ist.issued_book_isbn
GROUP BY category

-- Task 9: List Members Who Registered in the Last 300 Days:

SELECT *
FROM Members
WHERE reg_date >= DATEADD(DAY, -300, GETDATE())

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:

SELECT
	e1.emp_id,
	e1.emp_name,
	e1.position,
	e1.salary,
	b.*,
	e2.emp_name AS manager

FROM Employees AS e1
JOIN Branch AS b
ON e1.branch_id = b.branch_id
JOIN Employees AS e2
ON e2.emp_id = b.manager_id

-- Task 11: List Books with Rental Price Above Threshold

SELECT *
FROM Books
WHERE rental_price > 10

-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT *
FROM [Issued Status] AS ist
LEFT JOIN [Return Status] AS rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL



