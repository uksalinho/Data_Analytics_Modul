


--Yeni kayýtlarý yeni sütun isimleriyle Select kullanarak çaðýrabiliriz.
SELECT 1 AS ID, 'ZEYNEP' AS [NAME], '2022-01-01' AS BIRTH_DATE

----

--Top ile yapýlan sýralama kuralýna göre ilk n satýrý/kaydý çaðýrabiliriz
SELECT	top 30 store_id , product_id, quantity
FROM	product.stock
ORDER BY product_id -- Asc



--order by ile istediðimiz sütun/sütunlara göre descending veya ascending sýralama yapabiliriz.
SELECT	top 30 store_id , product_id, quantity
FROM	product.stock
ORDER BY store_id -- Asc



--Where ile bir veya daha fazla condition oluþturabiliriz. 
--Farklý Condition'lar arasýnda or veya and kullanmamýz gerekiyor.

SELECT *
FROM sale.customer
WHERE city = 'Buffalo' AND first_name = 'Daniel'

























