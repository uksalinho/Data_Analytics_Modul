




----WF TEKRAR



----
SELECT * FROM sale.orders


SELECT * FROM sale.order_item

---Çalýþanlarýn günlük kümülatif sipariþ sayýlarýný bulunuz.



2  2018-01-01  3
2  2018-01-02  4
2  2018-01-03  9


SELECT staff_id, order_date, COUNT (order_id) cnt_order
FROM	sale.orders
GROUP BY staff_id, order_date
ORDER BY staff_id, order_date


--ÇALIÞANLARIN HER GÜN ÝÇÝN ALDIKLARI SÝPARÝÞ SAYILARI
SELECT  DISTINCT staff_id, order_date, COUNT (order_id) OVER (PARTITION BY staff_id, order_date)
FROM	sale.orders
ORDER BY staff_id, order_date





--çalýþanlarýn günlere göre kümülatif sipariþ sayýlarý

WITH T1 AS
(
SELECT  DISTINCT staff_id, order_date, COUNT (order_id) OVER (PARTITION BY staff_id, order_date) cnt_ordr
FROM	sale.orders
)
SELECT staff_id, order_date, SUM(cnt_ordr) OVER (PARTITION BY staff_id ORDER BY order_date)
FROM	T1


---------

SELECT  DISTINCT staff_id, order_date, 
		COUNT (order_id) OVER (PARTITION BY staff_id, order_date) cnt_ord,
		COUNT (order_id) OVER (PARTITION BY staff_id ORDER BY order_date) cum_total_order
FROM	sale.orders


---Günlük kümülatif ciro

















--------------- SQL Programming ---------------


CREATE PROCEDURE sp_sample1 AS

SELECT 'Welcome' as [Message]



sp_sample1

EXEC sp_sample1


EXECUTE sp_sample1

-----

; 

ALTER PROC sp_sample1 AS

PRINT 'Welcome' 




sp_sample1


ALTER PROC sp_sample1 AS
BEGIN
	PRINT 'Welcome' 
END

DROP PROC sp_sample1



---------------//////////////////////////
DROP TABLE  ORDER_TBL 
CREATE TABLE ORDER_TBL 
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date
);



INSERT ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 7, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 8, 'Johnson',GETDATE(), GETDATE()+5 )




SELECT *
FROM ORDER_TBL



CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- tamamlanan delivery date
);



INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
				(2, GETDATE()-2 ),
				(3, GETDATE()-2 ),
				(4, GETDATE() ),
				(5, GETDATE()+2 ),
				(6, GETDATE()+3 ),
				(7, GETDATE()+5 ),
				(8, GETDATE()+5 )


SELECT *
FROM ORDER_DELIVERY


---belirtilen tarihe kadar alýnan sipariþ sayýsýný raporlayýn.


ALTER PROC sp_daily_order AS
BEGIN
	SELECT	MAX(ORDER_ID) daily_order_count
	FROM	ORDER_TBL
	WHERE	ORDER_DATE = CAST(GETDATE() AS DATE)
END




EXEC sp_daily_order



INSERT ORDER_TBL VALUES (9, 9, 'Sam', GETDATE()+2, GETDATE()+5)



---istenilen günde istenilen müþteriye ait sipariþ sayýsýný döndüren bir procedure yazýn

CREATE PROC sp_cust_order_report ( @DAY DATE , @CUSTOMER NVARCHAR(MAX) )
AS
BEGIN
	SELECT	COUNT (ORDER_ID)
	FROM	ORDER_TBL
	WHERE	CUSTOMER_NAME = @CUSTOMER
	AND		ORDER_DATE = @DAY

END


EXECUTE sp_cust_order_report '2022-07-27', 'Jack'


----------------////////

--istenilen iki sayýnýn toplamýný döndüren deðiþkenli bir sorgu yazýnýz.



DECLARE @V1 INT , @V2 INT , @RESULT INT

SET @V1 = 5
SET @V2 = 10
SET @RESULT = @V1 + @V2

--SELECT @RESULT

PRINT @V1 + @V2

; 

DECLARE @V1 INT = 10 , @V2 INT = 10 ,  @RESULT INT

SET @RESULT = @V1 + @V2

--SELECT @RESULT = @V1 + @V2


SELECT @RESULT


------------

DECLARE @V1 INT , @V2 INT , @RESULT INT

SELECT @V1 = 10 , @V2 = 20 , @RESULT = @V1+@V2

SELECT @RESULT AS RESULT


-----


--order_tbl tablosundan istenilen sipariþe ait tüm bilgileri döndüren deðiþkenli bir sorgu yazýn.


DECLARE @ORDER INT
SET @ORDER = 7

SELECT *
FROM	ORDER_TBL
WHERE	ORDER_ID = @ORDER


--------- ////////////////////////


--IF ELSE

IF CONDITION 
	SELECT *...
ELSE 
	SELECT *...

----

IF CONDITION1

	SELECT *...

ELSE IF CONDITION2

	SELECT *...

ELSE IF CONDITION3

	SELECT *...

ELSE

	SELECT *...


----------------IF ELSE SAMPLES

SELECT *
FROM ORDER_TBL
WHERE EXISTS (SELECT 1)



SELECT *
FROM ORDER_TBL
WHERE NOT EXISTS (SELECT 1)




IF EXISTS (SELECT * FROM ORDER_TBL WHERE ORDER_DATE = CAST (GETDATE() AS DATE))
	SELECT * FROM ORDER_TBL




IF NOT EXISTS (SELECT * FROM ORDER_TBL WHERE ORDER_DATE = CAST (GETDATE() AS DATE))
	SELECT * FROM ORDER_TBL




---Yazýlan müþteri 2022-07-25 tarihinden önce sipariþ vermiþ ise müþterinin adýný, 
--Eðer bu tarihte veya sonrasýnda sipariþ vermiþse 'Aradýðýnýz müþteri deðil' mesajýný döndüren bir sorgu yazýnýz


DECLARE @CUSTOMER INT

SET @CUSTOMER = 9

IF EXISTS (
			SELECT 1 
			FROM ORDER_TBL 
			WHERE CUSTOMER_ID = @CUSTOMER 
			AND		ORDER_DATE < '2022-07-25'
			)
	SELECT CUSTOMER_NAME
	FROM ORDER_TBL
	WHERE CUSTOMER_ID = @CUSTOMER

ELSE
	PRINT 'Aradýðýnýz müþteri deðil!'



--------


DECLARE @V1 INT = 7

IF @V1 = 7
	SELECT *
	FROM ORDER_TBL
	WHERE ORDER_ID = 7

ELSE IF @V1 <> 7
	PRINT 'Number is not equal to 7'
	
	----------------


DECLARE @V1 INT = 8

IF @V1 = 7
	SELECT *
	FROM ORDER_TBL
	WHERE ORDER_ID = 7

ELSE
	PRINT 'Number is not equal to 7'


---------------------------------------




-- iki deðiþken tanýmlayýn, 
-- eðer biri diðerine eþitse iki deðeri çarpýn
-- eðer deðiþken 1 deðiþken 2 ' den küçükse iki deðiþkeni toplayýn
-- deðiþken 2 deðiþken 1 ' den küçükse çýkarýn.



DECLARE @V1 INT , @V2 INT 

SET @V1 = 5
SET @V2 = 5

IF @V1 = @V2 
	SELECT @V1 * @V2 AS Carpim
ELSE IF @V1 < @V2 
	SELECT @V1 + @V2 AS Toplam
ELSE IF @V2 < @V1 
	SELECT @V1 - @V2 AS Fark



---Ýstenilen tarihte verilen sipariþ sayýsý 5 ten küçükse 'lower than 5',
-- 5 ile 10 arasýndaysa sipariþ sayýsý, 
-- 10' dan büyükse 'upper than 10' yazdýran bir sorgu yazýnýz.

DECLARE @ORDERDATE DATE 
SET @ORDERDATE = '2022-07-26'

SELECT	COUNT (ORDER_ID)
FROM	ORDER_TBL
WHERE	ORDER_DATE = @ORDERDATE



	--------------


DECLARE @ORDERDATE DATE 
SET @ORDERDATE = '2022-07-27'


IF	(SELECT	COUNT (ORDER_ID)
	FROM	ORDER_TBL
	WHERE	ORDER_DATE = @ORDERDATE) < 5

	PRINT 'lower than 5'



-------



DECLARE @ORDERDATE DATE 
SET @ORDERDATE = '2022-07-27'

DECLARE @CNTORDER INT
SET @CNTORDER = (	SELECT	COUNT (ORDER_ID)
					FROM	ORDER_TBL
					WHERE	ORDER_DATE = @ORDERDATE)


SELECT @CNTORDER

----

DECLARE @ORDERDATE DATE , @CNTORDER INT

SET @ORDERDATE = '2022-07-27'

SET @CNTORDER	= (	SELECT	COUNT (ORDER_ID)
					FROM	ORDER_TBL
					WHERE	ORDER_DATE = @ORDERDATE
					)

IF @CNTORDER < 5

	PRINT 'lower than 5'

ELSE IF @CNTORDER BETWEEN 5 AND 10

	PRINT @CNTORDER

ELSE 

	PRINT 'upper than 10'



----

DECLARE @ORDERDATE DATE , @CNTORDER INT
SET @ORDERDATE = '2022-07-27'
SET @CNTORDER	= (	SELECT	COUNT (ORDER_ID)
					FROM	ORDER_TBL
					WHERE	ORDER_DATE = @ORDERDATE
					)
IF @CNTORDER < 2
	PRINT 'lower than 2'
ELSE IF @CNTORDER BETWEEN 2 AND 5
	PRINT @CNTORDER
ELSE 
	PRINT 'upper than 5'



----------------------------------

--WHILE



DECLARE @SAYI INT = 1

WHILE @SAYI < 50
BEGIN

	SELECT @SAYI

	SET @SAYI +=1
END


-----------------////////////////////////

--ORDER TABLOSUNDAKÝ HER SÝPARÝÞ ÝÇÝN AYRI SORGULARDA SÝPARÝÞ BÝLGÝSÝNÝ GETÝRÝNÝZ.
DECLARE @SAYI INT = 1

WHILE @SAYI < (SELECT MAX(ORDER_ID) from ORDER_TBL)
BEGIN

	SELECT * from ORDER_TBL WHERE ORDER_ID = @SAYI

	SET @SAYI +=1
END



---ORDER_TBL TABLOSUNA 10 TANE MÜÞTERÝ EKLEYÝN


DECLARE @NWCUST INT = (SELECT MAX(CUSTOMER_ID) from ORDER_TBL) + 1

DECLARE @NWORDER INT = (SELECT MAX(ORDER_ID) from ORDER_TBL) + 1

DECLARE @LIMIT INT = @NWCUST + 11

WHILE @NWCUST < @LIMIT
BEGIN
		INSERT ORDER_TBL VALUES (@NWORDER, @NWCUST, NULL, NULL, NULL)

		SET @NWCUST +=1 -- SET @NWCUST =  @NWCUST+1
		SET @NWORDER +=1
END


SELECT * from ORDER_TBL

------------------------////////////////////////////


--User Valued Functions

--Scalar Valued Functions

CREATE FUNCTION fn_sample1()
RETURNS INT--INT = SONUÇ DEÐERÝNÝN VERÝ TÝPÝ
AS
BEGIN
	DECLARE @V1 INT = 50, @V2 INT = 20, @RESULT INT
	
	IF @V1 > @V2 
		SET @RESULT = @V1 -@V2


RETURN @RESULT
END


SELECT dbo.fn_sample1()


--Aldýðý kelimenin ilk harfini küçük diðerlerini büyük hale getiren bir fonksiyon yazýnýz


SELECT LOWER (LEFT('Sam', 1)) + UPPER (RIGHT('Sam', LEN('Sam')-1))


ALTER FUNCTION fn_upperlower( @V1 NVARCHAR(MAX) = 'Sam')
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @RESULT NVARCHAR(MAX)

	SET @RESULT = LOWER (LEFT(@V1, 1)) + UPPER (RIGHT(@V1, LEN(@V1)-1))

RETURN @RESULT
END;



SELECT dbo.fn_upperlower('OWEN')


SELECT dbo.fn_upperlower(default)

-----------


SELECT CUSTOMER_NAME, dbo.fn_upperlower(CUSTOMER_NAME)
FROM ORDER_TBL

----------------///////////////////////



---Table-Valued Functions

CREATE FUNCTION fn_sampletablefun1()
RETURNS TABLE -- TABLE = TABLO DÖNDÜRECEK
AS
	--BEGIN END BLOÐU YOK
RETURN SELECT * FROM ORDER_TBL WHERE ORDER_DATE = CAST(GETDATE()-2 AS DATE )


SELECT *
FROM dbo.fn_sampletablefun1()



CREATE FUNCTION fn_sampletablefun2( @DATE DATE )
RETURNS TABLE -- TABLE = TABLO DÖNDÜRECEK
AS
	RETURN SELECT * FROM ORDER_TBL WHERE ORDER_DATE = @DATE



SELECT *
FROM fn_sampletablefun2('2022-07-23')



----------------////////////

DECLARE @V1 INT 

---TABLO DEÐÝÞKENÝ OLUÞTURMA

DECLARE @TABLE1 TABLE (col1 int, col2 int)

	INSERT @TABLE1 VALUES(5,10)

SELECT *
FROM	@TABLE1


------------//////


SELECT * FROM ORDER_DELIVERY

---EÐER BÝR SÝPARÝÞ TAHMÝN EDÝLEN ZAMANDA TESLÝM EDÝLMEMÝÞSE BU SÝPARÝÞLERÝ 'NOT ON TIME' ETÝKETÝYLE YENÝ BÝR TABLOYA ATIP 
---BU TABLOYU DÖNDÜREN BÝR FONKSÝYON YAZIN.


ALTER FUNCTION fn_order_time( @ORDER_ID  INT)
RETURNS @TABLE1 TABLE (order_id int, isontime varchar (10))
AS
BEGIN
	INSERT	@TABLE1
	SELECT	A.ORDER_ID , 'NO'
	FROM	ORDER_TBL A, ORDER_DELIVERY B
	WHERE	A.ORDER_ID = B.ORDER_ID
	AND		A.EST_DELIVERY_DATE <> B.DELIVERY_DATE
	AND		A.ORDER_ID = @ORDER_ID

RETURN
END;


SELECT *
FROM	dbo.fn_order_time(3)






SELECT	a.ORDER_ID, A.EST_DELIVERY_DATE, B.DELIVERY_DATE
	FROM	ORDER_TBL A, ORDER_DELIVERY B
	WHERE	A.ORDER_ID = B.ORDER_ID









CREATE FUNCTION fn_sampletablevalued1()
RETURNS table
AS
	RETURN SELECT * FROM ORDER_TBL



SELECT * 
FROM dbo.fn_sampletablevalued1()



------------



CREATE FUNCTION fn_sampletablevalued2(@date DATE)
RETURNS table
AS
	RETURN SELECT * FROM ORDER_TBL WHERE ORDER_DATE = @date


SELECT * 
FROM dbo.fn_sampletablevalued2('2022-02-24')


------------------


declare @v1 int


declare @table TABLE (column1 int, column2 varchar(20))

	INSERT @table VALUES (1, 'Adam')

select * from @table


---------------


ALTER FUNCTION fn_sampletablevalued3 (@ORDER_ID INT)
RETURNS @table TABLE (ORDER_ID INT, DEL_TYPE VARCHAR(20) )
AS
BEGIN
	INSERT	@table 
	SELECT	A.ORDER_ID, 'ON TIME' 
	FROM	ORDER_TBL A, ORDER_DELIVERY B
	WHERE	A.EST_DELIVERY_DATE = B.DELIVERY_DATE
	AND		A.ORDER_ID = B.ORDER_ID
	AND		A.ORDER_ID = @ORDER_ID
	
	RETURN 
END


SELECT * FROM dbo.fn_sampletablevalued3(3)




