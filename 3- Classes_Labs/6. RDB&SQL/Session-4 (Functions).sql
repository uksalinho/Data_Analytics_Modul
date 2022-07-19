



------------/////////////////////----------


--Date Functions 

--Data Types


CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)


select * from t_date_time


select getdate()

INSERT t_date_time VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())



INSERT t_date_time VALUES ('12:52:10', '2022-07-14',  '2022-07-14' ,'2022-07-14' ,'2022-07-14' ,'2022-07-14')


----Return Date or Time Parts

SELECT DATENAME (DW, GETDATE()),
		DATENAME (DAYOFYEAR, GETDATE()),
		DATENAME (MONTH, GETDATE()),
		DATEPART(DW, GETDATE()),
		DATEPART(WEEKDAY, GETDATE()),
		DATEPART(MINUTE, GETDATE()),
		DAY(GETDATE()),
		MONTH(GETDATE()),
		YEAR(GETDATE())



----DATEDIFF

SELECT DATEDIFF(DAY, '2021-07-14', GETDATE()),
		DATEDIFF(SECOND, '2021-07-14', GETDATE())



SELECT	*, DATEDIFF(SECOND, A_smalldatetime, GETDATE())
FROM	t_date_time


---DATEADD - EOMONTH

SELECT DATEADD(MONTH, 5, GETDATE()),
		DATEADD(DAY, -5, GETDATE()),
		EOMONTH(GETDATE()), 
		EOMONTH(GETDATE(), 2)


--ISDATE

SELECT ISDATE('2022-02-12'),
		ISDATE('2022/02/12')
		,ISDATE('12-02-2022'),
		ISDATE('12022022')

------------


--Write a query returns orders that are shipped more than two days after the order date. 
--2 günden geç kargolanan sipariþlerin bilgilerini getiriniz.


SELECT	*, DATEDIFF(DAY, order_date, shipped_date) AS shipping_time
FROM	SALE.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2



---------------/////////////////////////------------------




--STRING FUNCTIONS

--DATA TYPES


SELECT CAST ('86963254896' AS CHAR(11))



SELECT CAST ('Reinvent yourself' AS VARCHAR(10))



---LEN


SELECT LEN('CHARACTER'),
		LEN('CHARACTERS'),
		LEN('CHARACTERS '),
		LEN(' CHARACTERS')


--CHARINDEX

SELECT CHARINDEX('H', 'CHARACTER'),
		CHARINDEX('C', 'CHARACTER'),
		CHARINDEX('C', 'CHARACTER',3),
		CHARINDEX('cte', 'CHARACTER')


--PATINDEX ----  % / _

SELECT PATINDEX('CH%', 'CHARACTER'),
		PATINDEX('CH_', 'CHARACTER'),
		PATINDEX('%TE_', 'CHARACTER')



--LEFT

SELECT LEFT('CHARACTER', 3)

--RIGHT
SELECT RIGHT('CHARACTER', 3)

--SUBSTRING

SELECT SUBSTRING('CHARACTER', 3, 4)

SELECT SUBSTRING('CHARACTER', 0, 4)

SELECT SUBSTRING('CHARACTER', -1, 4)


--LOWER

SELECT LOWER('CHARACTER')


--UPPER
SELECT UPPER('character')

--STRING_SPILIT

SELECT *
FROM	string_split('OWEN,SAM,BÝRGÜL,PAKÝZE', ',')



--TRIM

SELECT TRIM('  CHARACTER   ')


SELECT TRIM('!' FROM '!CHARACTER')

--LTRIM

SELECT LTRIM('  CHARACTER   ')

CHARACTER   


--RTRIM

SELECT RTRIM('  CHARACTER   ')

  CHARACTER



---EXAMPLE

--character kelimesinin ilk harfi büyük diðerleri küçük olsun. 'Character'

--select 'ali' + ' ' + 'zeki'


SELECT UPPER( LEFT('character', 1))

SELECT SUBSTRING('character', 2, LEN('character'))

SELECT UPPER( LEFT('character', 1)) + SUBSTRING('character', 2, LEN('character'))


SELECT UPPER('c') + 'haracter'


SELECT *, UPPER( LEFT(first_name, 1)) + SUBSTRING(first_name, 2, LEN('character'))
FROM	sale.customer


-----REPLACE

SELECT REPLACE('CHARACTER STRING', ' ','/')

SELECT REPLACE('   CHARACTER STRING   ', ' ','')


--STR

SELECT STR(525660)

SELECT STR(525660, 6)

SELECT STR(525.879, 6)

SELECT STR(525.879, 3)

SELECT STR(525.879, 7, 2)



-------------


---CONVERT

SELECT GETDATE()


SELECT CONVERT(VARCHAR, GETDATE(), 6)


SELECT CONVERT (DATE, '14 Jul 22', 6)



--CAST

SELECT CAST(12345 AS VARCHAR)


SELECT 12345 + 'OWEN'


SELECT CAST(12345 AS VARCHAR) + 'OWEN'


----ROUND

SELECT ROUND(213456.569, 2)

SELECT ROUND(213456.569, 2, 1) -- optional arguement may be 0 or 1. Default 0

SELECT ROUND(213456.569, 1, 1)

SELECT ROUND(213456.569, 1)


---ISNULL


SELECT ISNULL('Ahmet', 'Veli')


SELECT ISNULL(Null, 'Veli')

--isnull fonksiyonu null deðerlerin yerine istediðimiz farklý bir deðer yazdýrmak için kullanýlýyor
SELECT *, ISNULL (phone, 'no phone')
FROM	sale.customer


--COALESCE

--Null olmayan ilk deðeri yazdýrmak için kullanýlýyor.

SELECT COALESCE(NULL, NULL, 'ALÝ', 'VELÝ', NULL)

--NULLIF

SELECT NULLIF (0, 0)


SELECT phone, NULLIF (phone, '+1-90 - 740 - 7404')
FROM sale.customer


--ISNUMERIC

SELECT ISNUMERIC(0)

SELECT ISNUMERIC('5646')

SELECT ISNUMERIC('OWEN')

SELECT ISNUMERIC('5646M')


SELECT ISNUMERIC('5646/')



---------------

-- How many customers have yahoo mail?

--yahoo mailine sahip kaç müþteri vardýr?


SELECT TOP 100 *
FROM	sale.customer


SELECT	customer_id, first_name, last_name, email
FROM	sale.customer
WHERE	email LIKE '%yahoo%'
ORDER BY 2


--SELECT	COUNT(first_name) AS cnt_cust -- customer sayýsý
--FROM	sale.customer
--WHERE	email LIKE '%yahoo%'



--SELECT	COUNT(DISTINCT first_name) AS cnt_cust -- customer sayýsý
--FROM	sale.customer
--WHERE	email LIKE '%yahoo%'



SELECT	COUNT(customer_id) AS cnt_cust -- customer sayýsý
FROM	sale.customer
WHERE	email LIKE '%yahoo%'


SELECT	COUNT(DISTINCT customer_id) AS cnt_cust --unique customer_id' lerin sayýsý
FROM	sale.customer
WHERE	email LIKE '%yahoo%'


SELECT	COUNT(*) AS cnt_cust --* ile kayýt/satýr sayýlýr
FROM	sale.customer
WHERE	email LIKE '%yahoo%'


---Yukarýdaki sorguyu Patindex fonksiyonu kullanarak yapabilirsiniz.

--Write a query that returns the characters before the "@" character in the email column? 



SELECT	email, CHARINDEX('@', email)-1
FROM	sale.customer



SELECT	LEFT (email, CHARINDEX('@', email)-1) as SONUC
FROM	sale.customer



SELECT	email, CHARINDEX('@', email) AS [@ karakterinin indexi], LEFT(email, CHARINDEX('@', email)-1) AS SONUC
FROM	sale.customer



