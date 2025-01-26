# Library Management System using SQL Project --P2

## Project Overview

**Project Title**: Library Management System  
**Database**: `library_db`

This project demonstrates the implementation of a Library Management System using MSSQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup

- **Database Creation**: Created a database named `library_project_2`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE library_project_2;

-- -- Create table "Branch"
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

-- Create table "Employee"
DROP TABLE IF EXISTS Employees
CREATE TABLE Employees
	(
		emp_id VARCHAR(10) PRIMARY KEY,
		emp_name VARCHAR(25),
		position VARCHAR(15),
		salary INT,
		branch_id VARCHAR(25)	--Foreign Key
	)



-- Create table "Members"
DROP TABLE IF EXISTS Members
CREATE TABLE Members
	(
		member_id VARCHAR(10) PRIMARY KEY,
		member_name VARCHAR(25),
		member_address VARCHAR(75),
		reg_date DATE
	)


-- Create table "Books"
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

-- Create table "IssueStatus"
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

ALTER TABLE [Issued Status]
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES Members(member_id)


DROP TABLE IF EXISTS [Return Status]
CREATE TABLE [Return Status]
	(
		return_id VARCHAR(10) PRIMARY KEY,
		issued_id VARCHAR(10),
		return_book_name VARCHAR(75),
		return_date DATE,
		return_book_isbn VARCHAR(20)
	)

```

### 2. Add Constraint

```sql
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
```

### 3. Inserting Data

```sql
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
```

### 4. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
```sql
INSERT INTO Books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

SELECT * FROM Books
```
**Task 2: Update an Existing Member's Address**

```sql
UPDATE Members
SET member_address = '125 Main St'
WHERE member_id = 'C101'
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
DELETE FROM [dbo].[Issued Status]
WHERE issued_id = 'IS121'
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT *
FROM [dbo].[Issued Status]
WHERE issued_emp_id = 'E101'
```

**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT
	issued_emp_id,
	COUNT(issued_id) AS total_book_issued
FROM [Issued Status]
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1
```


- **Task 6: Generate Query Showing Each Book and Total Rental Count**

```sql
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM [dbo].[Issued Status] AS ist
JOIN Books AS b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title
```

### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql
SELECT *
FROM Books
WHERE category = 'Classic'
```

8. **Task 8: Find Total Rental Income by Category**:

```sql
SELECT 
	b.category,
	SUM(b.rental_price),
	COUNT(*) 
FROM [Issued Status] AS ist
JOIN Books AS b
ON b.isbn = ist.issued_book_isbn
GROUP BY category
```

9. **List Members Who Registered in the Last 300 Days**:
```sql

SELECT *
FROM Members
WHERE reg_date >= DATEADD(DAY, -300, GETDATE())
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
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
```

Task 11. **List Books with Rental Price Above Threshold**:
```sql
SELECT *
FROM Books
WHERE rental_price > 10
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
SELECT *
FROM [Issued Status] AS ist
LEFT JOIN [Return Status] AS rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL

```

## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, providing a solid foundation for data management and analysis.

## How to Use

1. **Clone the Repository**: Clone this repository to your local machine.
2. **Set Up the Database**: Execute the SQL scripts in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries in the `analysis_queries.sql` file to perform the analysis.
4. **Explore and Modify**: Customize the queries as needed to explore different aspects of the data or answer additional questions.
