




----WF TEKRAR



----
SELECT * FROM sale.orders


SELECT * FROM sale.order_item

---�al��anlar�n g�nl�k k�m�latif sipari� say�lar�n� bulunuz.



2  2018-01-01  3
2  2018-01-02  4
2  2018-01-03  9


SELECT staff_id, order_date, COUNT (order_id) cnt_order
FROM	sale.orders
GROUP BY staff_id, order_date
ORDER BY staff_id, order_date


--�ALI�ANLARIN HER G�N ���N ALDIKLARI S�PAR�� SAYILARI
SELECT  DISTINCT staff_id, order_date, COUNT (order_id) OVER (PARTITION BY staff_id, order_date)
FROM	sale.orders
ORDER BY staff_id, order_date





--�al��anlar�n g�nlere g�re k�m�latif sipari� say�lar�

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


---G�nl�k k�m�latif ciro

















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


---belirtilen tarihe kadar al�nan sipari� say�s�n� raporlay�n.


ALTER PROC sp_daily_order AS
BEGIN
	SELECT	MAX(ORDER_ID) daily_order_count
	FROM	ORDER_TBL
	WHERE	ORDER_DATE = CAST(GETDATE() AS DATE)
END




EXEC sp_daily_order



INSERT ORDER_TBL VALUES (9, 9, 'Sam', GETDATE()+2, GETDATE()+5)



---istenilen g�nde istenilen m��teriye ait sipari� say�s�n� d�nd�ren bir procedure yaz�n

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

--istenilen iki say�n�n toplam�n� d�nd�ren de�i�kenli bir sorgu yaz�n�z.



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


--order_tbl tablosundan istenilen sipari�e ait t�m bilgileri d�nd�ren de�i�kenli bir sorgu yaz�n.


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




---Yaz�lan m��teri 2022-07-25 tarihinden �nce sipari� vermi� ise m��terinin ad�n�, 
--E�er bu tarihte veya sonras�nda sipari� vermi�se 'Arad���n�z m��teri de�il' mesaj�n� d�nd�ren bir sorgu yaz�n�z


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
	PRINT 'Arad���n�z m��teri de�il!'



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




-- iki de�i�ken tan�mlay�n, 
-- e�er biri di�erine e�itse iki de�eri �arp�n
-- e�er de�i�ken 1 de�i�ken 2 ' den k���kse iki de�i�keni toplay�n
-- de�i�ken 2 de�i�ken 1 ' den k���kse ��kar�n.



DECLARE @V1 INT , @V2 INT 

SET @V1 = 5
SET @V2 = 5

IF @V1 = @V2 
	SELECT @V1 * @V2 AS Carpim
ELSE IF @V1 < @V2 
	SELECT @V1 + @V2 AS Toplam
ELSE IF @V2 < @V1 
	SELECT @V1 - @V2 AS Fark



---�stenilen tarihte verilen sipari� say�s� 5 ten k���kse 'lower than 5',
-- 5 ile 10 aras�ndaysa sipari� say�s�, 
-- 10' dan b�y�kse 'upper than 10' yazd�ran bir sorgu yaz�n�z.

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

--ORDER TABLOSUNDAK� HER S�PAR�� ���N AYRI SORGULARDA S�PAR�� B�LG�S�N� GET�R�N�Z.
DECLARE @SAYI INT = 1

WHILE @SAYI < (SELECT MAX(ORDER_ID) from ORDER_TBL)
BEGIN

	SELECT * from ORDER_TBL WHERE ORDER_ID = @SAYI

	SET @SAYI +=1
END



---ORDER_TBL TABLOSUNA 10 TANE M��TER� EKLEY�N


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
RETURNS INT--INT = SONU� DE�ER�N�N VER� T�P�
AS
BEGIN
	DECLARE @V1 INT = 50, @V2 INT = 20, @RESULT INT
	
	IF @V1 > @V2 
		SET @RESULT = @V1 -@V2


RETURN @RESULT
END


SELECT dbo.fn_sample1()


--Ald��� kelimenin ilk harfini k���k di�erlerini b�y�k hale getiren bir fonksiyon yaz�n�z


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
RETURNS TABLE -- TABLE = TABLO D�ND�RECEK
AS
	--BEGIN END BLO�U YOK
RETURN SELECT * FROM ORDER_TBL WHERE ORDER_DATE = CAST(GETDATE()-2 AS DATE )


SELECT *
FROM dbo.fn_sampletablefun1()



CREATE FUNCTION fn_sampletablefun2( @DATE DATE )
RETURNS TABLE -- TABLE = TABLO D�ND�RECEK
AS
	RETURN SELECT * FROM ORDER_TBL WHERE ORDER_DATE = @DATE



SELECT *
FROM fn_sampletablefun2('2022-07-23')



----------------////////////

DECLARE @V1 INT 

---TABLO DE���KEN� OLU�TURMA

DECLARE @TABLE1 TABLE (col1 int, col2 int)

	INSERT @TABLE1 VALUES(5,10)

SELECT *
FROM	@TABLE1


------------//////


SELECT * FROM ORDER_DELIVERY

---E�ER B�R S�PAR�� TAHM�N ED�LEN ZAMANDA TESL�M ED�LMEM��SE BU S�PAR��LER� 'NOT ON TIME' ET�KET�YLE YEN� B�R TABLOYA ATIP 
---BU TABLOYU D�ND�REN B�R FONKS�YON YAZIN.


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




