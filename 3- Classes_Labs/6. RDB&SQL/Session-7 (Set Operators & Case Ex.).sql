

---------Set Operators


--Union - Union All

--List the products sold in the cities of Charlotte and Aurora


--Charlotte þehrinde satýlan ürünler ile Aurora þehrinde satýlan ürünleri listeleyin

--75 UNIQUE PRODUCT

SELECT	DISTINCT D.product_name
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE	A.customer_id = B.customer_id 
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		A.city = 'Charlotte'


--103 UNIQUE PRODUCT

SELECT	DISTINCT D.product_name
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE	A.customer_id = B.customer_id 
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		A.city = 'Aurora'



--Result


SELECT	D.product_name
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE	A.customer_id = B.customer_id 
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		(A.city = 'Aurora' OR A.city = 'Charlotte')



SELECT	D.product_name
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE	A.customer_id = B.customer_id 
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		A.city IN ('Aurora' , 'Charlotte')






--UNION

SELECT	D.product_name, 'Charlotte' AS city_1
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE	A.customer_id = B.customer_id 
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		A.city = 'Charlotte'
UNION
SELECT	D.product_name, 'Aurora' AS city_1
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE	A.customer_id = B.customer_id 
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		A.city = 'Aurora'
ORDER BY 1



--UNION ALL


SELECT	D.product_name
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE	A.customer_id = B.customer_id 
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		A.city = 'Charlotte'
UNION ALL
SELECT	D.product_name
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE	A.customer_id = B.customer_id 
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		A.city = 'Aurora'
ORDER BY 1




-----------------------------

-------------/////////////////


--Write a query that returns all customers whose  first or last name is Thomas.  (don't use 'OR')

--adý veya soyadý Thomas olan müþteriler

SELECT	first_name , last_name
FROM	sale.customer
WHERE	first_name = 'Thomas'
UNION ALL
SELECT	first_name, last_name
FROM	sale.customer
WHERE	last_name = 'Thomas'
ORDER BY first_name



-----INTERSECT

--Write a query that returns all brands with products for both 2018 and 2020 model year.


--37 BRAND
SELECT	DISTINCT B.brand_id, B.brand_name, A.model_year
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
AND		A.model_year = 2018


--31 BRAND
SELECT	DISTINCT B.brand_id, B.brand_name, A.model_year
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
AND		A.model_year = 2020


--RESULT

SELECT	B.brand_id, B.brand_name
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
AND		A.model_year = 2018
INTERSECT
SELECT	B.brand_id, B.brand_name
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
AND		A.model_year = 2020



-- Write a query that returns the first and the last names of the customers who placed orders in all of 2018, 2019, and 2020.


--Hem 2018 hem 2019 hem de 2020 yýllarýnda sipariþ vermiþ müþterilerin isim ve soyisimleri

--2018' de sipariþi olan müþteriler
SELECT	customer_id
FROM	SALE.orders
WHERE	order_date BETWEEN '2018-01-01' AND '2018-12-31' 

--2019' da sipariþi olan müþteriler
SELECT	customer_id
FROM	SALE.orders
WHERE	YEAR (order_date) = 2019


--2020' da sipariþi olan müþteriler
SELECT	customer_id
FROM	SALE.orders
WHERE	YEAR (order_date) = 2020


--result

SELECT first_name, last_name
FROM sale.customer 
WHERE customer_id IN (
						SELECT	customer_id
						FROM	SALE.orders
						WHERE	YEAR (order_date) = 2018
						INTERSECT
						SELECT	customer_id
						FROM	SALE.orders
						WHERE	YEAR (order_date) = 2019
						INTERSECT
						SELECT	customer_id
						FROM	SALE.orders
						WHERE	YEAR (order_date) = 2020
						)

----


--aþaðýdaki sorgu hatalý çünkü customer id ler üzerinden kesiþtirme yapýlmýyor. Ayný isme sahip birden fazla müþteri mevcut.

SELECT	 B.first_name, B.last_name
FROM	SALE.orders A, sale.customer B
WHERE	YEAR (order_date) = 2018
AND		A.customer_id = B.customer_id
INTERSECT
SELECT	 B.first_name, B.last_name
FROM	SALE.orders A, sale.customer B
WHERE	YEAR (order_date) = 2019
AND		A.customer_id = B.customer_id
INTERSECT
SELECT	 B.first_name, B.last_name
FROM	SALE.orders A, sale.customer B
WHERE	YEAR (order_date) = 2020
AND		A.customer_id = B.customer_id




SELECT	 a.*
FROM	SALE.orders A, sale.customer B
WHERE	A.customer_id = B.customer_id
AND		first_name = 'james' and last_name = 'Rodriguez'


SELECT	 a.*
FROM	SALE.orders A, sale.customer B
WHERE	A.customer_id = B.customer_id
AND		first_name = 'william' and last_name = 'williams'


------------------/////////////////


---EXCEPT


-- Write a query that returns the brands have  2018 model products but not 2019 model products.


SELECT *
FROM	product.brand
WHERE	brand_id IN (

					SELECT	brand_id
					FROM	product.product
					WHERE	model_year = 2018
					EXCEPT
					SELECT	brand_id
					FROM	product.product
					WHERE	model_year = 2019
					)


-- Write a query that contains only products ordered in 2019 (Result not include products ordered in other years)


SELECT	DISTINCT a.product_id
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
AND		YEAR(order_date) = 2019
EXCEPT
SELECT	DISTINCT a.product_id
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
AND		YEAR(order_date) <> 2019




----------------//////////////////////////


---CASE EXPRESSION


------ Simple Case Expression -----

-- Create  a new column with the meaning of the  values in the Order_Status column. 
--Order_Status isimli alandaki deðerlerin ne anlama geldiðini içeren yeni bir alan oluþturun.


-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed


SELECT	order_id, order_status,

		CASE order_status
				WHEN 4 THEN 'Completed' 
				WHEN 3 THEN 'Rejected'
				WHEN 2 THEN 'Processing'
				WHEN 1 THEN 'Pending'
		END AS status_exp
		
		
FROM	SALE.orders


SELECT	order_id, order_status,

		CASE order_status
				WHEN 4 THEN 'Completed' 
				WHEN 3 THEN 'Rejected'
				WHEN 2 THEN 'Processing'
				ELSE 'Pending'
		END AS status_exp
		
FROM	SALE.orders



---

--Create a new column with the names of the stores to be consistent with the values in the store_ids column
--Staff tablosuna çalýþanlarýn maðaza isimlerini ekleyin.



SELECT first_name, last_name, store_id, 
		CASE store_id 
			WHEN 1 THEN 'Davi techno Retail'
			WHEN 2 THEN 'The BFLO Store'
			ELSE 'Burkes Outlet'
		END	AS store_name
FROM	sale.staff



------ Searched Case Expression -----



--Create  a new column with the meaning of the  values in the Order_Status column.  (use searched case ex.)
-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed




SELECT	order_id, order_status,

		CASE
				WHEN order_status = 4 THEN 'Completed' 
				WHEN order_status = 3 THEN 'Rejected'
				WHEN order_status = 2 THEN 'Processing'
				ELSE 'Pending'
		END AS status_exp
		
FROM	SALE.orders


----//////////////////



-- Create a new column that shows which email service provider ("Gmail", "Hotmail", "Yahoo" or "Other" ).
--MüþterilERÝN e-mail adreslerindeki servis saðlayýcýlarýný yeni bir sütun oluþturarak belirtiniz.


SELECT customer_id, first_name, last_name, email,
		CASE 
			WHEN email LIKE '%gmail%' THEN 'Gmail'
			WHEN email LIKE '%hotmail%' THEN 'Hotmail'
			WHEN email LIKE '%yahoo%' THEN 'Yahoo'
			ELSE 'Others'
		END AS email_service_provider
			
FROM sale.customer


---------

-- Write a query that gives the first and last names of customers who have ordered products from the computer accessories, speakers, and mp4 player categories in the same order.
-- Ayný sipariþte hem mp4 player, hem Computer Accessories hem de Speakers kategorilerinde ürün sipariþ veren müþterileri bulunuz.



---Intersect ile yapýn

SELECT	A.customer_id, A.first_name, A.last_name, B.order_id,
		SUM( CASE WHEN E.category_name = 'mp4 player' THEN 1 ELSE 0 END) mp4_player,
		SUM(CASE WHEN E.category_name = 'Computer Accessories' THEN 1 ELSE 0 END) ComputerAccessories,
		SUM(CASE WHEN E.category_name = 'Speakers' THEN 1 ELSE 0 END) Speakers

FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D, product.category E
WHERE	A.customer_id = B.customer_id
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		D.category_id = E.category_id
GROUP BY A.customer_id, A.first_name, A.last_name, B.order_id
HAVING	SUM( CASE WHEN E.category_name = 'mp4 player' THEN 1 ELSE 0 END) > 0
		AND
		SUM(CASE WHEN E.category_name = 'Computer Accessories' THEN 1 ELSE 0 END) > 0
		AND
		SUM(CASE WHEN E.category_name = 'Speakers' THEN 1 ELSE 0 END) > 0
ORDER BY 1,4









