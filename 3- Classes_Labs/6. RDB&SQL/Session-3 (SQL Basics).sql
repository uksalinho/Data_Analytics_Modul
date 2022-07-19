


--Yeni kay�tlar� yeni s�tun isimleriyle Select kullanarak �a��rabiliriz.
SELECT 1 AS ID, 'ZEYNEP' AS [NAME], '2022-01-01' AS BIRTH_DATE

----

--Top ile yap�lan s�ralama kural�na g�re ilk n sat�r�/kayd� �a��rabiliriz
SELECT	top 30 store_id , product_id, quantity
FROM	product.stock
ORDER BY product_id -- Asc



--order by ile istedi�imiz s�tun/s�tunlara g�re descending veya ascending s�ralama yapabiliriz.
SELECT	top 30 store_id , product_id, quantity
FROM	product.stock
ORDER BY store_id -- Asc



--Where ile bir veya daha fazla condition olu�turabiliriz. 
--Farkl� Condition'lar aras�nda or veya and kullanmam�z gerekiyor.

SELECT *
FROM sale.customer
WHERE city = 'Buffalo' AND first_name = 'Daniel'

























