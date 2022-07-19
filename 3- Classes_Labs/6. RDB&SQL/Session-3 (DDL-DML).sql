





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



----!!! ilgili kolonun özelliklerine ve kýsýtlarýna uygun veri girilmeli !!!


-- Insert iþlemi yapacaðýnýz tablo sütunlarýný aþaðýdaki gibi parantez içinde belirtebilirsiniz.
-- Bu kullanýmda sadece belirttiðiniz sütunlara deðer girmek zorundasýnýz. Sütun sýrasý önem arz etmektedir.

INSERT INTO person.person (SSN, Person_FirstName, Person_LastName)
VALUES	(56648652365, 'Zeynep', 'Tekin')	



INSERT person.person (SSN, Person_FirstName, Person_LastName)
VALUES	(56648652375, 'Ahmet', 'Tekin')	


--Insert edeceðim deðerler tablo kýsýtlarýna ve sütun veri tiplerine uygun olmazsa aþaðýdaki gibi iþlemi gerçekleþtirmez.


--Insert keywordunden sonra Into kullanmanýza gerek yoktur.
--Ayrýca Aþaðýda olduðu gibi insert etmek istediðiniz sütunlarý belirtmeyebilirsiniz. 
--Buna raðmen sütun sýrasýna ve yukarýdaki kurallara dikkat etmelisiniz.
--Bu kullanýmda tablonun tüm sütunlarýna insert edileceði farz edilir ve sizden tüm sütunlar için deðer ister.




--Insert keywordunden sonra Into kullanmanýza gerek yoktur.
--Ayrýca Aþaðýda olduðu gibi insert etmek istediðiniz sütunlarý belirtmeyebilirsiniz. 
--Buna raðmen sütun sýrasýna ve yukarýdaki kurallara dikkat etmelisiniz.
--Bu kullanýmda tablonun tüm sütunlarýna insert edileceði farz edilir ve sizden tüm sütunlar için deðer ister.


INSERT person.person --(SSN, Person_FirstName, Person_LastName)
VALUES	(56549652375, 'Veli', 'Tekin')	




--Eðer deðeri bilinmeyen sütunlar varsa bunlar yerine Null yazabilirsiniz. 
--Tabiki Null yazmak istediðiniz bu sütunlar Nullable olmalýdýr.

INSERT person.person --(SSN, Person_FirstName, Person_LastName)
VALUES	(56549782375, null, null)	


--hatalý
INSERT person.person --(SSN, Person_FirstName, Person_LastName)
VALUES	(null, null, 56549782344)


--Eðer bir tablodaki tüm sütunlara insert etmeyecekseniz, seçtiðiniz sütunlarýn haricindeki sütunlar Nullable olmalý.
--Eðer Not Null constrainti uygulanmýþ sütun varsa hata verecektir.


--Aþaðýda Person_LastName sütununa deðer girilmemiþtir. 
--Person_LastName sütunu Nullable olduðu için Person_LastName yerine Null deðer atayarak iþlemi tamamlar.

INSERT person.person (SSN, Person_FirstName)
VALUES	(96849782375, 'Zeki')	



--Eðer deðeri bilinmeyen sütunlar varsa bunlar yerine Null yazabilirsiniz. 
--Tabiki Null yazmak istediðiniz bu sütunlar Nullable olmalýdýr

INSERT person.person --(SSN, Person_FirstName)
VALUES	(96777782375, 'Metin', Null)


--Ayný tablonun ayný sütunlarýna birçok kayýt insert etmek isterseniz aþaðýdaki syntaxý kullanabilirsiniz.


INSERT Person.Person_Phone
VALUES (5056759985, 87569854423),
		(5056656985, 87569814123),
		(5056659385, 87519854123)



SELECT *
FROM	person.Person_Phone

----


---INSERT WITH DEFAULT VALUES

--Aþaðýdaki syntaxda göreceðiniz üzere hiçbir deðer belirtilmemiþ. 
--Bu þekilde tabloya tablonun default deðerleriyle insert iþlemi yapýlacaktýr.
--Tabiki sütun constraintleri buna elveriþli olmalý. Buradaki gibi elveriþsiz ise hata alýnýr.

INSERT Person.Person_Mail
DEFAULT VALUES


-----

--Burada dikkat edeceðiniz diðer bir konu Mail_ID sütununa deðer atanmadýðýdýr.
--Mail_ID sütunu tablo oluþturulurken identity olarak tanýmlandýðý için otomatik artan deðerler içerir.
--Otomatik artan bir sütuna deðer insert edilmesine izin verilmez.

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

--Update iþleminde koþul tanýmlamaya dikkat ediniz. Eðer herhangi bir koþul tanýmlamazsanýz 
--Sütundaki tüm deðerlere deðiþiklik uygulanacaktýr.

UPDATE Person.Person_Mail
SET		Mail = 'metin45@gmail.com'



UPDATE Person.Person_Mail
SET		Mail = 'zeyneptekin@gmail.com'
WHERE	SSN = 56648652365





SELECT *
FROM	Person.Person_Mail



-------------



---DELETE


--tablodaki tüm deðerler siliniyor. Ancak tabloya format atýlmýyor. Delete' yi bu þekilde kullanmayý tercih etmiyoruz.
DELETE FROM Person.Person_Mail

--Tüm tabloyu delete ile silip yeni bir deðer insert ettiðimizde aþaðýdaki gibi id sütununa tablonun eski halindeki kaldýðý deðerden bir sonraki deðeri atýyor.

INSERT Person.Person_Mail (Mail, SSN)
VALUES ('metin44@gmail.com', 96777782375)




SELECT *
FROM	 Person.Person


--Spesifik kayýt/kayýtlarý silmek için Where ile condition ekliyoruz ve Delete' yi genelde bu þekilde kullanýyoruz.
DELETE FROM Person.Person WHERE person.Person_FirstName IS NULL


-----

--SELECT INTO 



--Aþaðýdaki syntax ile farklý bir tablodaki deðerleri daha önceden oluþturmuþ olduðunuz farklý bir tabloya insert edebilirsiniz.
--Sütun sýrasý, tipi, constraintler ve diðer kurallar yine önemli.

SELECT	Person_FirstName, Person_LastName
INTO	person_2 -- TARGET
FROM	Person.Person --SOURCE
WHERE	Person_LastName IS NULL


SELECT *
FROM	person_2



--TRUNCATE



--sonraki kýsýmda Constraint ve Alter Table örnekleri yapýlacaktýr.
--Yapacaðýmýz iþlemlerin tutarlý olmasý için öncelikle yukarýda örnek olarak veri insert ettiðimiz tablolarýmýzý boþaltalým.

TRUNCATE TABLE Person.Person_Mail;
TRUNCATE TABLE Person.Person;
TRUNCATE TABLE Person_Phone;


---DROP

DROP TABLE PERSON_2


----


----ALTER TABLE 


---book.Author

--Author tablosundaki Author_ID sütununu primary key yapmamýz gerek. Fakat bu sütun nullable olduðu için primary key yapýlamýyor. 
--Bu yüzden öncelikle Author tablosundaki Author_ID sütununu not null yapmamýz ve sonrasýnda primary key olarak atamamýz gerek.

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






