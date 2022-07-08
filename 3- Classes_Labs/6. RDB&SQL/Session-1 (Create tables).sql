





CREATE DATABASE Librarydatabase;

Use Librarydatabase;


--Create Two Schemas
CREATE SCHEMA Book;
---
CREATE SCHEMA Person;





--create Book.Book table
CREATE TABLE [Book].[Book]
(
	[Book_ID] [int] PRIMARY KEY NOT NULL,
	[Book_Name] [nvarchar](50) NOT NULL,
	Author_ID INT NOT NULL,
	Publisher_ID INT NOT NULL
	);


--create Book.Author table

CREATE TABLE [Book].[Author]
(
	[Author_ID] [int],
	[Author_FirstName] [nvarchar](50) Not NULL,
	[Author_LastName] [nvarchar](50) Not NULL
	);



--create Publisher Table

CREATE TABLE [Book].[Publisher](
	[Publisher_ID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Publisher_Name] [nvarchar](100) NULL
	);



--create Person.Person table

CREATE TABLE [Person].[Person](
	[SSN] [bigint] PRIMARY KEY ,
	[Person_FirstName] [nvarchar](50) NULL,
	[Person_LastName] [nvarchar](50) NULL
	);





--create Person.Loan table

CREATE TABLE [Person].[Loan](
	[SSN] BIGINT NOT NULL,
	[Book_ID] INT NOT NULL,
	PRIMARY KEY ([SSN], [Book_ID])
	);




--cretae Person.Person_Phone table

CREATE TABLE [Person].[Person_Phone](
	[Phone_Number] [bigint] PRIMARY KEY NOT NULL,
	[SSN] [bigint] NOT NULL	
	);


--cretae Person.Person_Mail table

CREATE TABLE [Person].[Person_Mail](
	[Mail_ID] INT PRIMARY KEY IDENTITY (1,1),
	[Mail] NVARCHAR(MAX) NOT NULL,
	[SSN] BIGINT UNIQUE NOT NULL	
	);












