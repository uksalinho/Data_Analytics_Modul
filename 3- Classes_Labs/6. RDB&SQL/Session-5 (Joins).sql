


--Joins

--inner join


-- Make a list of products showing the product ID, product name, category ID, and category name.

-- �r�nleri kategori isimleri ile birlikte listeleyin
-- �r�n IDsi, �r�n ad�, kategori IDsi ve kategori adlar�n� se�in


SELECT *
FROM product.category



SELECT distinct category_id
FROM product.product




SELECT		A.product_id, A.product_name, B.category_id, B.category_name
FROM		product.product AS A 
INNER JOIN	product.category AS B
ON			A.category_id = B.category_id


--D��ER Y�NTEM (INNER JOIN ���N)


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



-- Ma�aza �al��anlar�n� �al��t�klar� ma�aza bilgileriyle birlikte listeleyin
-- �al��an ad�, soyad�, ma�aza adlar�n� se�in


SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff A, sale.store B
WHERE	A.store_id = B.store_id



------ LEFT JOIN ------

--Write a query that returns products that have never been ordered
--Select product ID, product name, orderID


-- Hi� sipari� verilmemi� �r�nleri listeleyin


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



-- �r�n bilgilerini stok miktarlar� ile birlikte listeleyin
---beklenen: product tablosunda olup stok bilgisi olmayan �r�nleri de g�rmek.



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



-- Stok miktarlar� ile ilgili LEFT JOIN ile yapt���n�z sorguyu RIGHT JOIN ile yap�n



SELECT		A.product_id, product_name, B.*
FROM		product.stock B
RIGHT JOIN	product.product A
ON			A.product_id = B.product_id
WHERE		A.product_id > 310


--//////

---Report the order information made by all staffs.

--Expected columns: staff_id, first_name, last_name, all the information about orders


-- Ma�aza �al��anlar�n� yapt�klar� sat��lar ile birlikte listeleyin


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



-- �r�nlerin stok miktarlar� ve sipari� bilgilerini birlikte listeleyin


SELECT	DISTINCT TOP 100 A.product_id, A.product_name, B.*, C.order_id
FROM	product.product A
FULL OUTER JOIN product.stock B ON A.product_id = B.product_id
FULL OUTER JOIN sale.order_item C ON A.product_id = C.product_id
ORDER BY order_id, store_id


------ CROSS JOIN ------

/*
In the stocks table, there are not all products held on the product table and you want to insert these products into the stock table.

You have to insert all these products for every three stores with �0 (zero)� quantity.

Write a query to prepare this data.

*/


--stock tablosunda olmay�p product tablosunda mevcut olan �r�nlerin stock tablosuna t�m storelar i�in kay�t edilmesi gerekiyor. 
--sto�u olmad��� i�in quantity leri 0 olmak zorunda
--Ve bir product id t�m store' lar�n stockuna eklenmesi gerekti�i i�in cross join yapmam�z gerekiyor.


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



-- Personelleri ve �eflerini listeleyin
-- �al��an ad� ve y�netici ad� bilgilerini getirin



--INNER JOIN �LE T�M �ALI�ANLARIN B�LG�S� GELM�YOR. BU Y�ZDEN LEFT JOIN KULLANIYORUZ.

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

-- Bir �nceki sorgu sonucunda gelen �eflerin yan�na onlar�n da �eflerini getiriniz
-- �al��an ad�, �ef ad�, �efin �efinin ad� bilgilerini getirin



SELECT	A.staff_id, A.first_name AS staff_name, B.first_name AS first_manager_name, c.first_name AS second_manager_name
FROM	sale.staff A
LEFT JOIN sale.staff B 
ON	A.manager_id = B.staff_id
LEFT JOIN	sale.staff C
ON B.manager_id = C.staff_id


SELECT *
FROM sale.staff



---Views


---m��terilerin sipari� etti�i �r�nleri g�steren bir view olu�turun


CREATE or ALTER VIEW v_customers_and_products AS
SELECT	  DISTINCT A.customer_id, A.first_name, A.last_name, B.order_id, C.product_id, D.product_name
FROM	  sale.customer A
LEFT JOIN sale.orders B ON A.customer_id = B.customer_id
LEFT JOIN sale.order_item C ON B.order_id = C.order_id
LEFT JOIN product.product D ON C.product_id = D.product_id





select *
from v_customers_and_products








