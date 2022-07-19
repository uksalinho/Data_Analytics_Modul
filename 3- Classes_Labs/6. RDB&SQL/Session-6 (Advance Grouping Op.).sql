



--- Advanced Grouping Operations

--Having



----Write a query that checks if any product id is duplicated in product table.

----product tablosunda herhangi bir product id' nin �oklay�p �oklamad���n� kontrol ediniz.


SELECT	product_id, COUNT (*) cnt_row
FROM	product.product
GROUP BY product_id
HAVING  COUNT (*) >1



SELECT	product_name, COUNT (*) cnt_row
FROM	product.product
GROUP BY product_name
HAVING  COUNT (*) >1


SELECT category_id
FROM	product.product
GROUP BY category_id



---------


--Write a query that returns category ids with conditions max list price above 4000 or a min list price below 500.

--maximum list price' � 4000' in �zerinde olan veya minimum list price' � 500' �n alt�nda olan categori id' leri getiriniz


SELECT	category_id, MAX(list_price) max_price, MIN (list_price) min_price
FROM	product.product
GROUP BY category_id
HAVING	MAX(list_price) > 4000 OR MIN(list_price) < 500



SELECT	category_id, MAX(list_price) max_price, MIN (list_price) min_price
FROM	product.product
GROUP BY category_id
HAVING	MAX(list_price) > 4000 AND MIN(list_price) < 500




---/////

--Find the average product prices of the brands. Display brand name and average prices in descending order.

--Markalara ait ortalama �r�n fiyatlar�n� bulunuz.
--ortalama fiyatlara g�re azalan s�rayla g�steriniz.



SELECT B.brand_id, B.brand_name, AVG(list_price) Avg_product_price
FROM product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
GROUP BY B.brand_id, B.brand_name
ORDER BY Avg_product_price DESC


--RIGHT JOIN
SELECT B.brand_id, B.brand_name, AVG(list_price) Avg_product_price
FROM product.product A RIGHT JOIN product.brand B ON A.brand_id = B.brand_id
GROUP BY B.brand_id, B.brand_name


--------------//////////////


--Write a query that returns the list of brands whose average product prices are more than 1000

---ortalama �r�n fiyat� 1000' den y�ksek olan MARKALARI getiriniz

SELECT		B.brand_name, AVG(list_price) Avg_product_price
FROM		product.product A, product.brand B
WHERE		A.brand_id = B.brand_id
GROUP BY	B.brand_id, B.brand_name
HAVING		AVG(list_price) > 1000
ORDER BY	Avg_product_price DESC



----------////////////////


--Write a query that returns the list of each order id and that order's total net price 
--(please take into consideration of discounts and quantities)


--bir sipari�in toplam net tutar�n� getiriniz. (m��terinin sipari� i�in �dedi�i tutar)
--discount' � ve quantity' yi ihmal etmeyiniz.


SELECT	order_id, SUM(quantity*list_price*(1-discount)) net_price
FROM	sale.order_item
GROUP BY order_id



-------------/////////////////////


--Write a query that returns monthly order counts of the States.

--State' lerin ayl�k sipari� say�lar�n� hesaplay�n�z


SELECT DISTINCT state
FROM sale.customer


SELECT DISTINCT YEAR(order_date) ord_year, MONTH(order_date) ord_month
FROM sale.orders
order by 1,2


SELECT	B.[state], YEAR(order_date) AS ord_year, MONTH(order_date) AS ord_month, COUNT (DISTINCT order_id) CNT_ORDER
FROM	sale.orders AS A, sale.customer AS B
WHERE	A.customer_id = B.customer_id
GROUP BY B.[state], YEAR(order_date), MONTH(order_date)
order by 2,3



---------/////////////////////////


/*
select * into .... from ....
*/

SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year, 
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary

FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year




SELECT *
FROM	sale.sales_summary




-----///////////////////////------

--GRUPING SETS

--1. Calculate the total sales price.

--1. Toplam sales miktar�n� hesaplay�n�z.


SELECT SUM (total_sales_price)
FROM sale.sales_summary



--2. Calculate the total sales price of the brands

--2. Markalar�n toplam sales miktar�n� hesaplay�n�z


SELECT	brand, SUM(total_sales_price)
FROM	sale.sales_summary 
GROUP BY Brand



--3. Calculate the total sales price of the categories

--3. Kategori baz�nda yap�lan toplam sales miktar�n� hesaplay�n�z

SELECT	Category, SUM(total_sales_price)
FROM	sale.sales_summary 
GROUP BY Category



--4. Calculate the total sales price by brands and categories.

--4. Marka ve kategori k�r�l�m�ndaki toplam sales miktar�n� hesaplay�n�z


SELECT	brand, Category, SUM(total_sales_price)
FROM	sale.sales_summary 
GROUP BY brand, Category



--Perform the above four variations in a single query using 'Grouping Sets'.

--Yukar�daki 4 maddede istenileni tek bir sorguda getirmek i�in Grouping sets kullan�labilir

--Yani brand, Category, brand + category, total


SELECT brand, category, SUM(total_sales_price) turnover
FROM	sale.sales_summary
GROUP BY 
	GROUPING SETS (
					(Brand),
					(Category),
					(Brand,Category),
					()
				)
ORDER BY CASE WHEN brand is not null and category is null then brand end,
			CASE WHEN brand is null and category is not null then category end






---------////////////////////////----------




---------- ROLLUP ---------

--Generate different grouping variations that can be produced with the brand and category columns using 'ROLLUP'.
-- Calculate sum total_sales_price


--brand, category, model_year s�tunlar� i�in Rollup kullanarak total sales hesaplamas� yap�n.



SELECT brand, category, model_year, SUM(total_sales_price) turnover
FROM	sale.sales_summary
GROUP BY 
	ROLLUP (Brand, Category, Model_Year)
ORDER BY 
	Brand Desc, Category Desc



	
	-------////////////////////////----------

------------ CUBE ------------


--Generate different grouping variations that can be produced with the brand and category columns using 'CUBE'.
-- Calculate sum total_sales_price


--brand, category, model_year s�tunlar� i�in cube kullanarak total sales hesaplamas� yap�n.



SELECT brand, category, model_year, SUM(total_sales_price) turnover
FROM	sale.sales_summary
GROUP BY 
	CUBE (Brand, Category, Model_Year)
ORDER BY 
	Brand Desc, Category Desc




--SADECE CATEGORY VE MODEL YILI KIRILIMLARINDA KAZANCI G�STER�N



--------- PIVOT ----------

--Generate a query that you use its result as basic table for PIVOT.
--pivot table olu�turaca��n�z kaynak tabloyu belirleyin

-- that is what:

--Question: Write a query using summary table that returns the total turnover from each category by model year. (in pivot table format)
--kategorilere ve model y�l�na g�re toplam ciro miktar�n� summary tablosu �zerinden hesaplay�n


SELECT	Category, Model_Year, SUM (total_sales_price) turnover
FROM	sale.sales_summary
GROUP BY Category, Model_Year
order by 1,2


---

SELECT *
FROM
	(
	SELECT	Category, model_year, total_sales_price
	FROM	sale.sales_summary
	) AS subquery
PIVOT
	(
		SUM (total_sales_price)
		FOR	category 
		IN	(
			[Audio & Video Accessories]
			,[Bluetooth]
			,[Car Electronics]
			,[Computer Accessories]
			,[Earbud]
			,[gps]
			,[Hi-Fi Systems]
			,[Home Theater]
			,[mp4 player]
			,[Receivers Amplifiers]
			,[Speakers]
			,[Televisions & Accessories]
			)	
	) AS pvt_table




	-----------///////////////////////



--Write a query that returns count of the orders day by day in a pivot table format that has been shipped two days later.
-- �ki g�nden ge� kargolanan sipari�lerin haftan�n g�nlerine g�re da��l�m�n� hesaplay�n�z.


SELECT	DATENAME(WEEKDAY, order_date) AS ORD_DAY, COUNT (order_id) AS CNT_ORDER
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2
GROUP BY 
		DATENAME(WEEKDAY, order_date)



---------

SELECT *
FROM
	(
	SELECT	DATENAME(WEEKDAY, order_date) AS ORD_DAY, order_id
	FROM	sale.orders
	WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2
	) AS A
PIVOT 
(
COUNT (order_id)
FOR	ORD_DAY
IN (
	[Monday], -- K��EL� PARANTEZ ZORUNLU
    [Tuesday], 
    [Wednesday], 
    [Thursday], 
    [Friday], 
    [Saturday], 
    [Sunday]
	)
) AS PVT_TABLE




