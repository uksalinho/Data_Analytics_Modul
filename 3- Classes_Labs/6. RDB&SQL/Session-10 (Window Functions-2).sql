



------------- Window Functions - 2


---Write a query that returns first order date by month
---Her ay için ilk sipariþ tarihini belirtiniz.


SELECT	DISTINCT YEAR(order_date) ord_year, MONTH(order_date) ord_month,
		FIRST_VALUE(order_date) OVER (PARTITION BY YEAR(order_date), MONTH(order_date) ORDER BY order_date ASC)
FROM	sale.orders




--LAST VALUE

--Write a query that returns most stocked product in each store. (Use Last_Value)

--CAUTION! There are more than one product has same quantity in each store.


SELECT *
FROM	product.stock
ORDER BY 1, 3



SELECT	DISTINCT store_id, 
		LAST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM	product.stock




--LAG() - LEAD()


--Write a query that returns the order date of the one previous sale of each staff (use the LAG function)
--1. Herbir personelin bir önceki satýþýnýn sipariþ tarihini yazdýrýnýz (LAG fonksiyonunu kullanýnýz)



SELECT	A.staff_id, A.first_name, A.last_name, B.order_id, B.order_date,
		LAG(order_date) OVER (PARTITION BY A.staff_id ORDER BY order_date ASC)
FROM	sale.staff A, sale.orders B
WHERE	A.staff_id = B.staff_id


--null deðerlerin yerine ilk sipariþ tarihini yazdýrdýk

--ikinci argüman kaç önceki veya kaç sonraki deðeri almak istediðimizi belirtir
--ikinci ve üçüncü argümanlar opsiyonel

SELECT	A.staff_id, A.first_name, A.last_name, B.order_id, B.order_date,
		LAG(order_date, 1, order_date) OVER (PARTITION BY A.staff_id ORDER BY order_date ASC)
FROM	sale.staff A, sale.orders B
WHERE	A.staff_id = B.staff_id



--Write a query that returns the order date of the one next sale of each staff (use the LEAD function)
--2. Herbir personelin bir sonraki satýþýnýn sipariþ tarihini yazdýrýnýz (LEAD fonksiyonunu kullanýnýz)


SELECT	A.staff_id, A.first_name, A.last_name, B.order_id, B.order_date,
		LEAD(order_date) OVER (PARTITION BY A.staff_id ORDER BY order_date ASC)
FROM	sale.staff A, sale.orders B
WHERE	A.staff_id = B.staff_id





-- 3. ANALYTIC NUMBERING FUNCTIONS --

	
--ROW_NUMBER() - RANK() - DENSE_RANK() - CUME_DIST() - PERCENT_RANK() - NTILE()



--Assign an ordinal number to the product prices for each category in ascending order

--1. Herbir kategori içinde ürünlerin fiyat sýralamasýný yapýnýz (artan fiyata göre 1'den baþlayýp birer birer artacak)


SELECT	category_id, list_price,
		ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price) as ROW_NUM,
		RANK() OVER (PARTITION BY category_id ORDER BY list_price) as RANK_NUM,
		DENSE_RANK() OVER (PARTITION BY category_id ORDER BY list_price) as DENSE_NUM
FROM	product.product
ORDER BY category_id, list_price



--------------------------


--/////


-- Write a query that returns the cumulative distribution of the list price in product table by brand.

-- product tablosundaki list price' larýn kümülatif daðýlýmýný marka kýrýlýmýnda hesaplayýnýz



SELECT	brand_id, list_price,
		ROUND(CUME_DIST() OVER (PARTITION BY brand_id ORDER BY list_price) , 2) Cume_Dist
FROM	product.product



---//////////////////


--Write a query that returns the relative standing of the list price in product table by brand.



SELECT	brand_id, list_price,
		ROUND(PERCENT_RANK() OVER (PARTITION BY brand_id ORDER BY list_price) , 2) Per_Rank
FROM	product.product





-----------///////////////


--Write a query that returns both of the followings:
--Average product price.
--The average product price of orders.



--Aþaðýdakilerin her ikisini de döndüren bir sorgu yazýn:
--Sipariþlerin ortalama ürün fiyatý.
--ortalama ürün fiyatý.

WITH T1 AS
(
SELECT	DISTINCT AVG(list_price) OVER () avg_price_for_table,
		order_id,
		AVG(list_price) OVER (PARTITION BY order_id) avg_price_for_orders
FROM	sale.order_item
)
SELECT *
FROM	T1
WHERE	avg_price_for_table > avg_price_for_orders
ORDER BY avg_price_for_orders DESC



-------------//////////////


--Calculate the stores' weekly cumulative number of orders for 2018


--maðazalarýn 2018 yýlýna ait haftalýk kümülatif sipariþ sayýlarýný hesaplayýnýz

SELECT DATEPART(ISO_WEEK, order_date), cOUNT (order_id)
FROM sale.orders
where	 YEAR(order_date) = 2018
and		store_id = 1
GROUP BY DATEPART(ISO_WEEK, order_date)




SELECT	DISTINCT A.store_id, A.store_name, 
		DATEPART(ISO_WEEK, order_date) AS weeks,
		COUNT (*) OVER (PARTITION BY A.store_id, DATEPART(ISO_WEEK, order_date)) CNT_ORDER_BY_WEEK,

		COUNT (*) OVER (PARTITION BY A.store_id ORDER BY DATEPART(ISO_WEEK, order_date)) Cumulative_order_total
FROM	sale.store A, sale.orders B
WHERE	A.store_id = B.store_id
AND		YEAR(order_date) = 2018














