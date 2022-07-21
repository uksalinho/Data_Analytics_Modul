

---
--Write a query that returns the total stock amount of each product in the stock table.
--ürünlerin stock sayýlarýný bulunuz


SELECT	product_id, SUM(quantity) total_quantity
FROM	product.stock
GROUP BY product_id
ORDER BY 1


SELECT	product_id
FROM	product.stock
GROUP BY product_id



---WINDOW FUNCTION


SELECT	product_id, 
		SUM(quantity) OVER (PARTITION BY product_id) product_quantity
FROM	product.stock
ORDER BY product_id




SELECT	DISTINCT product_id, 
		SUM(quantity) OVER (PARTITION BY product_id) product_quantity
FROM	product.stock
ORDER BY product_id




SELECT	*, 
		SUM(quantity) OVER (PARTITION BY product_id) product_quantity,
		SUM (quantity) OVER () total_quantity
FROM	product.stock
ORDER BY product_id



SELECT *
FROM	product.stock
ORDER BY product_id



-- Write a query that returns average product prices of brands. 

-- Markalara göre ortalama ürün fiyatlarýný hem Group By hem de Window Functions ile hesaplayýnýz


SELECT	brand_id, AVG(list_price)
FROM	product.product
GROUP BY brand_id




SELECT	DISTINCT brand_id, AVG(list_price) OVER(PARTITION BY brand_id)
FROM	product.product




----WINDOW FRAMES

-- Window Frames

-- Windows frame i anlamak için birkaç örnek:
-- Herbir satýrda iþlem yapýlacak olan frame in büyüklüðünü (satýr sayýsýný) tespit edip window frame in nasýl oluþtuðunu aþaðýdaki sorgu sonucuna göre konuþalým.


SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,
		COUNT(*) OVER(PARTITION BY category_id) countofprod_by_cat,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) countofprod_by_cat_2,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2
FROM	product.product
ORDER BY category_id, product_id

;

------------////////////////




-- 1. ANALYTIC AGGREGATE FUNCTIONS --


--MIN() - MAX() - AVG() - SUM() - COUNT()




--///

-- What is the cheapest product price for each category?
-- Herbir kategorideki en ucuz ürünün fiyatý


SELECT category_id, MIN (list_price)
FROM	product.product
GROUP BY category_id


SELECT	DISTINCT category_id, MIN (list_price) OVER (PARTITION BY category_id) min_price
FROM	product.product


--///


-- How many different product in the product table?
-- Product tablosunda toplam kaç faklý product bulunduðu



SELECT DISTINCT COUNT (product_id) OVER ()
FROM product.product


---////

-- How many different product in the order_item table?
-- Order_item tablosunda kaç farklý ürün bulunmaktadýr?


SELECT	 COUNT (product_id) 
FROM	sale.order_item

--SONUÇ
SELECT	 COUNT (DISTINCT product_id) 
FROM	sale.order_item

--WF ÝLE

SELECT	DISTINCT COUNT (product_id) OVER ()
FROM	(
		SELECT		DISTINCT product_id
		FROM		sale.order_item
		) A





		
----/////
-- Write a query that returns how many products are in each order?
-- Her sipariþte kaç ürün olduðunu döndüren bir sorgu yazýn?


SELECT	DISTINCT order_id, COUNT (product_id) OVER (PARTITION BY order_id)
FROM	sale.order_item



SELECT	DISTINCT order_id, MAX (item_id) OVER (PARTITION BY order_id)
FROM	sale.order_item

SELECT	*
FROM	sale.order_item





SELECT	DISTINCT order_id, item_id , product_id, COUNT (product_id) OVER (PARTITION BY order_id ORDER BY item_id)
FROM	sale.order_item



SELECT	DISTINCT order_id, item_id , product_id, 
		COUNT (product_id) OVER (PARTITION BY order_id ORDER BY item_id ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)
FROM	sale.order_item




--////

-- How many different product are in each brand in each category?
-- Herbir kategorideki herbir markada kaç farklý ürünün bulunduðu


SELECT	DISTINCT brand_id, category_id, COUNT (product_id) OVER (PARTITION BY brand_id, category_id)
FROM	product.product
ORDER BY brand_id, category_id




-- 2. ANALYTIC NAVIGATION FUNCTIONS --





--FIRST_VALUE() - 

--Write a query that returns one of the most stocked product in each store.

--CAUTION! There are more than one product has same quantity in each store.


SELECT	DISTINCT store_id, 
		FIRST_VALUE (product_id) OVER (PARTITION BY store_id ORDER BY quantity DESC) most_stock_product
FROM	product.stock




-----////


--Write a query that returns customers and their most valuable order with total amount of it.


SELECT	DISTINCT A.customer_id, A.order_id, 
		SUM (quantity*list_price* (1-discount)) OVER (PARTITION BY A.customer_id, A.order_id) total_net_amount
FROM	sale.orders A, sale.order_item B
WHERE	A.order_id = B.order_id
order by 1,3 desc


----------------------------///////////////////////////



WITH T1 AS 
(
SELECT	DISTINCT A.customer_id, A.order_id, 
		SUM (quantity*list_price* (1-discount)) OVER (PARTITION BY A.customer_id, A.order_id) total_net_amount
FROM	sale.orders A, sale.order_item B
WHERE	A.order_id = B.order_id
)
SELECT	DISTINCT customer_id, 
		FIRST_VALUE(order_id) OVER (PARTITION BY customer_id ORDER BY total_net_amount DESC) mv_order,
		FIRST_VALUE(total_net_amount) OVER (PARTITION BY customer_id ORDER BY total_net_amount DESC) mv_order_amount
FROM	T1


























