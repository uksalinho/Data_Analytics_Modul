





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



-------------------------------


--Insert
--Update
--Delete
--Select into
--Truncate
--Drop



--------- INSERT ----------



----!!! ilgili kolonun �zelliklerine ve k�s�tlar�na uygun veri girilmeli !!!


-- Insert i�lemi yapaca��n�z tablo s�tunlar�n� a�a��daki gibi parantez i�inde belirtebilirsiniz.
-- Bu kullan�mda sadece belirtti�iniz s�tunlara de�er girmek zorundas�n�z. S�tun s�ras� �nem arz etmektedir.

INSERT INTO person.person (SSN, Person_FirstName, Person_LastName)
VALUES	(56648652365, 'Zeynep', 'Tekin')	



INSERT person.person (SSN, Person_FirstName, Person_LastName)
VALUES	(56648652375, 'Ahmet', 'Tekin')	


--Insert edece�im de�erler tablo k�s�tlar�na ve s�tun veri tiplerine uygun olmazsa a�a��daki gibi i�lemi ger�ekle�tirmez.


--Insert keywordunden sonra Into kullanman�za gerek yoktur.
--Ayr�ca A�a��da oldu�u gibi insert etmek istedi�iniz s�tunlar� belirtmeyebilirsiniz. 
--Buna ra�men s�tun s�ras�na ve yukar�daki kurallara dikkat etmelisiniz.
--Bu kullan�mda tablonun t�m s�tunlar�na insert edilece�i farz edilir ve sizden t�m s�tunlar i�in de�er ister.




--Insert keywordunden sonra Into kullanman�za gerek yoktur.
--Ayr�ca A�a��da oldu�u gibi insert etmek istedi�iniz s�tunlar� belirtmeyebilirsiniz. 
--Buna ra�men s�tun s�ras�na ve yukar�daki kurallara dikkat etmelisiniz.
--Bu kullan�mda tablonun t�m s�tunlar�na insert edilece�i farz edilir ve sizden t�m s�tunlar i�in de�er ister.


INSERT person.person --(SSN, Person_FirstName, Person_LastName)
VALUES	(56549652375, 'Veli', 'Tekin')	




--E�er de�eri bilinmeyen s�tunlar varsa bunlar yerine Null yazabilirsiniz. 
--Tabiki Null yazmak istedi�iniz bu s�tunlar Nullable olmal�d�r.

INSERT person.person --(SSN, Person_FirstName, Person_LastName)
VALUES	(56549782375, null, null)	


--hatal�
INSERT person.person --(SSN, Person_FirstName, Person_LastName)
VALUES	(null, null, 56549782344)


--E�er bir tablodaki t�m s�tunlara insert etmeyecekseniz, se�ti�iniz s�tunlar�n haricindeki s�tunlar Nullable olmal�.
--E�er Not Null constrainti uygulanm�� s�tun varsa hata verecektir.


--A�a��da Person_LastName s�tununa de�er girilmemi�tir. 
--Person_LastName s�tunu Nullable oldu�u i�in Person_LastName yerine Null de�er atayarak i�lemi tamamlar.

INSERT person.person (SSN, Person_FirstName)
VALUES	(96849782375, 'Zeki')	



--E�er de�eri bilinmeyen s�tunlar varsa bunlar yerine Null yazabilirsiniz. 
--Tabiki Null yazmak istedi�iniz bu s�tunlar Nullable olmal�d�r

INSERT person.person --(SSN, Person_FirstName)
VALUES	(96777782375, 'Metin', Null)


--Ayn� tablonun ayn� s�tunlar�na bir�ok kay�t insert etmek isterseniz a�a��daki syntax� kullanabilirsiniz.


INSERT Person.Person_Phone
VALUES (5056759985, 87569854423),
		(5056656985, 87569814123),
		(5056659385, 87519854123)



SELECT *
FROM	person.Person_Phone

----


---INSERT WITH DEFAULT VALUES

--A�a��daki syntaxda g�rece�iniz �zere hi�bir de�er belirtilmemi�. 
--Bu �ekilde tabloya tablonun default de�erleriyle insert i�lemi yap�lacakt�r.
--Tabiki s�tun constraintleri buna elveri�li olmal�. Buradaki gibi elveri�siz ise hata al�n�r.

INSERT Person.Person_Mail
DEFAULT VALUES


-----

--Burada dikkat edece�iniz di�er bir konu Mail_ID s�tununa de�er atanmad���d�r.
--Mail_ID s�tunu tablo olu�turulurken identity olarak tan�mland��� i�in otomatik artan de�erler i�erir.
--Otomatik artan bir s�tuna de�er insert edilmesine izin verilmez.

INSERT Person.Person_Mail (Mail, SSN)
VALUES ('zeyneptekin@gmail.com', 56648652365)



INSERT Person.Person_Mail (Mail, SSN)
VALUES ('metin44@gmail.com', 96777782375)


SELECT *
FROM	Person.Person_Mail


-----------------


---INSERT INTO SELECT


CREATE TABLE person_new
(
SSN BIGINT, 
First_Name VARCHAR(50),
Last_Name VARCHAR (50)
);




INSERT INTO person_new --(SSN, First_Name, Last_Name)
SELECT * 
FROM Person.Person
WHERE Person.Person_LastName IS NOT NULL



SELECT * FROM person_new



---UPDATE

--Update i�leminde ko�ul tan�mlamaya dikkat ediniz. E�er herhangi bir ko�ul tan�mlamazsan�z 
--S�tundaki t�m de�erlere de�i�iklik uygulanacakt�r.

UPDATE Person.Person_Mail
SET		Mail = 'metin45@gmail.com'



UPDATE Person.Person_Mail
SET		Mail = 'zeyneptekin@gmail.com'
WHERE	SSN = 56648652365





SELECT *
FROM	Person.Person_Mail



-------------



---DELETE


--tablodaki t�m de�erler siliniyor. Ancak tabloya format at�lm�yor. Delete' yi bu �ekilde kullanmay� tercih etmiyoruz.
DELETE FROM Person.Person_Mail

--T�m tabloyu delete ile silip yeni bir de�er insert etti�imizde a�a��daki gibi id s�tununa tablonun eski halindeki kald��� de�erden bir sonraki de�eri at�yor.

INSERT Person.Person_Mail (Mail, SSN)
VALUES ('metin44@gmail.com', 96777782375)




SELECT *
FROM	 Person.Person


--Spesifik kay�t/kay�tlar� silmek i�in Where ile condition ekliyoruz ve Delete' yi genelde bu �ekilde kullan�yoruz.
DELETE FROM Person.Person WHERE person.Person_FirstName IS NULL


-----

--SELECT INTO 



--A�a��daki syntax ile farkl� bir tablodaki de�erleri daha �nceden olu�turmu� oldu�unuz farkl� bir tabloya insert edebilirsiniz.
--S�tun s�ras�, tipi, constraintler ve di�er kurallar yine �nemli.

SELECT	Person_FirstName, Person_LastName
INTO	person_2 -- TARGET
FROM	Person.Person --SOURCE
WHERE	Person_LastName IS NULL


SELECT *
FROM	person_2



--TRUNCATE



--sonraki k�s�mda Constraint ve Alter Table �rnekleri yap�lacakt�r.
--Yapaca��m�z i�lemlerin tutarl� olmas� i�in �ncelikle yukar�da �rnek olarak veri insert etti�imiz tablolar�m�z� bo�altal�m.

TRUNCATE TABLE Person.Person_Mail;
TRUNCATE TABLE Person.Person;
TRUNCATE TABLE Person_Phone;


---DROP

DROP TABLE PERSON_2


----


----ALTER TABLE 


---book.Author

--Author tablosundaki Author_ID s�tununu primary key yapmam�z gerek. Fakat bu s�tun nullable oldu�u i�in primary key yap�lam�yor. 
--Bu y�zden �ncelikle Author tablosundaki Author_ID s�tununu not null yapmam�z ve sonras�nda primary key olarak atamam�z gerek.

ALTER TABLE Book.Author
ALTER COLUMN Author_ID INT NOT NULL 


ALTER TABLE Book.Author
ADD CONSTRAINT PK_1 PRIMARY KEY (Author_ID)



-----Book.Book

--Foreign key

ALTER TABLE Book.Book
ADD CONSTRAINT FK_AUTHOR FOREIGN KEY (Author_ID) REFERENCES Book.Author (Author_ID)


ALTER TABLE Book.Book
ADD CONSTRAINT FK_publisher FOREIGN KEY (Publisher_ID) REFERENCES Book.Publisher (Publisher_ID)



----Person.Loan

--Foreign key

ALTER TABLE Person.Loan
ADD CONSTRAINT FK_SSN FOREIGN KEY (SSN) REFERENCES Person.Person (SSN)


ALTER TABLE Person.Loan
ADD CONSTRAINT FK_Book FOREIGN KEY (Book_ID) REFERENCES Book.Book (Book_ID)


--Person.Person_Mail

--Foreign key



ALTER TABLE Person.Person_Mail
ADD CONSTRAINT FK_SSN_2 FOREIGN KEY (SSN) REFERENCES Person.Person (SSN)



--Person.Person_Phone

--Foreign key



ALTER TABLE Person.Person_Phone
ADD CONSTRAINT FK_SSN3 FOREIGN KEY (SSN) REFERENCES Person.Person (SSN)






