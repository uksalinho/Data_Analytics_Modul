


--Joins

--inner join


-- Make a list of products showing the product ID, product name, category ID, and category name.

-- Ürünleri kategori isimleri ile birlikte listeleyin
-- Ürün IDsi, ürün adý, kategori IDsi ve kategori adlarýný seçin


SELECT *
FROM product.category



SELECT distinct category_id
FROM product.product




SELECT		A.product_id, A.product_name, B.category_id, B.category_name
FROM		product.product AS A 
INNER JOIN	product.category AS B
ON			A.category_id = B.category_id


--DÝÐER YÖNTEM (INNER JOIN ÝÇÝN)


SELECT		A.product_id, A.product_name, B.category_id, B.category_name
FROM		product.product AS A 
JOIN		product.category AS B
ON			A.category_id = B.category_id



SELECT		A.product_id, A.product_name, B.category_id, B.category_name
FROM		product.product AS A , product.category AS B
WHERE		A.category_id = B.category_id
--AND			product_id= 1




------///////////


--List employees of stores with their store information.

--Select first name, last name, store name



-- Maðaza çalýþanlarýný çalýþtýklarý maðaza bilgileriyle birlikte listeleyin
-- Çalýþan adý, soyadý, maðaza adlarýný seçin


SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff A, sale.store B
WHERE	A.store_id = B.store_id



------ LEFT JOIN ------

--Write a query that returns products that have never been ordered
--Select product ID, product name, orderID


-- Hiç sipariþ verilmemiþ ürünleri listeleyin


SELECT	COUNT (product_id)
FROM	product.product



SELECT	COUNT(product_id), count(distinct product_id)
FROM	sale.order_item



SELECT		A.product_id, A.product_name, B.order_id, B.product_id
FROM		product.product A
LEFT JOIN	sale.order_item B
ON			A.product_id = B.product_id
WHERE		B.order_id IS NULL




SELECT		A.product_id, A.product_name, B.order_id, B.product_id
FROM		product.product A, sale.order_item B
WHERE		A.product_id = B.product_id
AND			B.order_id IS NULL



------////////

--Report the stock status of the products that product id greater than 310 in the stores.
--Expected columns: product_id, product_name, store_id, product_id, quantity



-- Ürün bilgilerini stok miktarlarý ile birlikte listeleyin
---beklenen: product tablosunda olup stok bilgisi olmayan ürünleri de görmek.



SELECT COUNT (product_id)
FROM	product.product

SELECT COUNT (DISTINCT product_id)
FROM	product.stock



SELECT		A.product_id, product_name, B.*
FROM		product.product A
LEFT JOIN	product.stock B
ON			A.product_id = B.product_id
WHERE		A.product_id > 310




------ RIGHT JOIN ------

--Report (AGAIN WITH RIGHT JOIN) the stock status of the products that product id greater than 310 in the stores.

--Expected columns: product_id, product_name, store_id, quantity



-- Stok miktarlarý ile ilgili LEFT JOIN ile yaptýðýnýz sorguyu RIGHT JOIN ile yapýn



SELECT		A.product_id, product_name, B.*
FROM		product.stock B
RIGHT JOIN	product.product A
ON			A.product_id = B.product_id
WHERE		A.product_id > 310


--//////

---Report the order information made by all staffs.

--Expected columns: staff_id, first_name, last_name, all the information about orders


-- Maðaza çalýþanlarýný yaptýklarý satýþlar ile birlikte listeleyin


SELECT *
FROM	sale.staff

SELECT	DISTINCT staff_id
FROM	sale.orders



SELECT		B.staff_id, B.first_name, B.last_name, A. order_id
FROM		sale.orders A
RIGHT JOIN	sale.staff B
ON			A.staff_id = B.staff_id
ORDER BY	order_id, staff_id




------ FULL OUTER JOIN ------

--Write a query that returns stock and order information together for all products . Return only top 100 rows.

--Expected columns: Product_id, store_id, quantity, order_id, list_price



-- Ürünlerin stok miktarlarý ve sipariþ bilgilerini birlikte listeleyin


SELECT	DISTINCT TOP 100 A.product_id, A.product_name, B.*, C.order_id
FROM	product.product A
FULL OUTER JOIN product.stock B ON A.product_id = B.product_id
FULL OUTER JOIN sale.order_item C ON A.product_id = C.product_id
ORDER BY order_id, store_id


------ CROSS JOIN ------

/*
In the stocks table, there are not all products held on the product table and you want to insert these products into the stock table.

You have to insert all these products for every three stores with “0 (zero)” quantity.

Write a query to prepare this data.

*/


--stock tablosunda olmayýp product tablosunda mevcut olan ürünlerin stock tablosuna tüm storelar için kayýt edilmesi gerekiyor. 
--stoðu olmadýðý için quantity leri 0 olmak zorunda
--Ve bir product id tüm store' larýn stockuna eklenmesi gerektiði için cross join yapmamýz gerekiyor.


SELECT	DISTINCT A.product_id, B.store_id, 0 AS quantity
FROM	product.product A
CROSS JOIN product.stock B
WHERE	A.product_id NOT IN (SELECT product_id FROM product.stock)
order by product_id


--INSERT INTO product.stock
--SELECT		DISTINCT store_id, A.product_id, quantity
--FROM		product.product A
--CROSS JOIN	product.stock B
--WHERE		A.product_id NOT IN (SELECT product_id FROM product.stock)
--order by	product_id



------ SELF JOIN ------

--Write a query that returns the staff names with their manager names.
--Expected columns: staff first name, staff last name, manager name



-- Personelleri ve þeflerini listeleyin
-- Çalýþan adý ve yönetici adý bilgilerini getirin



--INNER JOIN ÝLE TÜM ÇALIÞANLARIN BÝLGÝSÝ GELMÝYOR. BU YÜZDEN LEFT JOIN KULLANIYORUZ.

SELECT	A.staff_id, A.first_name AS staff_name, B.first_name AS manager_name
FROM	sale.staff A
INNER JOIN sale.staff B 
ON	A.manager_id = B.staff_id


SELECT	A.staff_id, A.first_name AS staff_name, B.first_name AS manager_name
FROM	sale.staff A
LEFT JOIN sale.staff B 
ON	A.manager_id = B.staff_id



--//////

--Write a query that returns both the names of staff and the names of their 1st and 2nd managers

-- Bir önceki sorgu sonucunda gelen þeflerin yanýna onlarýn da þeflerini getiriniz
-- Çalýþan adý, þef adý, þefin þefinin adý bilgilerini getirin



SELECT	A.staff_id, A.first_name AS staff_name, B.first_name AS first_manager_name, c.first_name AS second_manager_name
FROM	sale.staff A
LEFT JOIN sale.staff B 
ON	A.manager_id = B.staff_id
LEFT JOIN	sale.staff C
ON B.manager_id = C.staff_id


SELECT *
FROM sale.staff



---Views


---müþterilerin sipariþ ettiði ürünleri gösteren bir view oluþturun


CREATE or ALTER VIEW v_customers_and_products AS
SELECT	  DISTINCT A.customer_id, A.first_name, A.last_name, B.order_id, C.product_id, D.product_name
FROM	  sale.customer A
LEFT JOIN sale.orders B ON A.customer_id = B.customer_id
LEFT JOIN sale.order_item C ON B.order_id = C.order_id
LEFT JOIN product.product D ON C.product_id = D.product_id





select *
from v_customers_and_products








