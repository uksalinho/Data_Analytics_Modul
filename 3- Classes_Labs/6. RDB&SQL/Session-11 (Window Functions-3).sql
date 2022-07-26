



ID
1  6
6  5
5  3
3  2
2
4


--istenilen
ID
1  2
2  3
3  4
4  5
5  6
6  null

--bir sonraki
SELECT lead(ID) OVER (ORDER BY ID)





ID
1  null
2  1
3  2
4  3
5  4
6  5


--bir önceki
SELECT LAG(ID) OVER (ORDER BY ID)



--Müþterilerin sipariþinden sonraki sipariþi veren müþteriyi bulunuz.



SELECT	order_id, customer_id,
		LEAD(customer_id) OVER (ORDER BY order_id) next_cust
FROM	sale.orders
order by order_id





---Müþterilerin sipariþinden 3 önceki sipariþi veren müþteriyi bulunuz.

SELECT	order_id, customer_id, LAG (customer_id, 3) OVER (ORDER BY order_id)
FROM	sale.orders



SELECT	order_id, customer_id, LAG (customer_id, 3) OVER (ORDER BY order_id desc)
FROM	sale.orders



------------------


---Peþpeþe en az iki sipariþi kargolanmayan müþterileri getiriniz.

--1. Sipariþin kargolanýp kargolanmadýðýný nasýl anlarýz?

SELECT *
FROM	sale.orders
WHERE	shipped_date IS NULL




--Shipped date null ise sipariþ kargolanmamýþtýr.

--2. Her bir sipariþin kargolanýp kargolanmadýðý bilgisini yazdýrýnýz.

--customer_id, order_id, is_shipping


select customer_id, order_id,
		case
		when shipped_date IS NULL then 'Negative' else 'Positive' end is_shipping
from sale.orders
ORDER BY customer_id, order_id



--Müþterilerin her bir sipariþi için bir sonraki sipariþin kargolanýp kargolanmadýðý bilgisini yeni bir sütunda belirtiniz.


WITH T1 AS 
(
select customer_id, order_id,
		case	when shipped_date IS NULL then 'Negative' else 'Positive' end is_shipping
from sale.orders
), T2 AS
(
SELECT *,  LEAD(is_shipping) OVER (PARTITION BY customer_id ORDER BY order_id)  as next_order_shipping
FROM T1
) 
SELECT	DISTINCT t2.*
FROM	T2
WHERE	is_shipping = 'Negative'
AND		next_order_shipping = 'Negative'
ORDER BY customer_id, order_id



-------------



with T1 AS
(
select customer_id, order_id,
		case
		when shipped_date IS NULL then 'Negative' else 'Positive' end is_shipping
from sale.orders
), T2 AS
(
select *,
Lead (is_shipping) OVER (Partition by customer_id ORDER BY order_id) AS next_shipping_status
from T1
)
select customer_id, order_id, is_shipping, t2.next_shipping_status
from T2
where is_shipping='Negative'
and next_shipping_status='Negative'
order by customer_id, order_id



-----/////


--Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'.
--'2018-03-12' ve '2018-04-12' arasýnda satýlan ürün sayýsýnýn 7 günlük hareketli ortalamasýný hesaplayýn.

WITH T1 AS
(
SELECT	order_date, SUM(quantity) cnt_product
FROM	sale.orders A, sale.order_item B
WHERE	A.order_id = B.order_id
AND		a.order_date BETWEEN '2018-03-12' AND '2018-04-12'
GROUP BY order_date
) 
SELECT	order_date, cnt_product,
		ROUND (AVG(CAST(cnt_product AS FLOAT)) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 1) moving_avg
FROM	T1



;
---with default window frame
WITH T1 AS
(
SELECT	order_date, SUM(quantity) cnt_product
FROM	sale.orders A, sale.order_item B
WHERE	A.order_id = B.order_id
AND		a.order_date BETWEEN '2018-03-12' AND '2018-04-12'
GROUP BY order_date
) 
SELECT	order_date, cnt_product,
		ROUND (AVG(CAST(cnt_product AS FLOAT)) OVER (ORDER BY order_date), 1) moving_avg
FROM	T1





------Yýl bazýnda her haftaya ait en yüksek ciro miktarýný döndüren bir sorgu yazýnýz.


--her güne ait toplam ciroyu bulunuz. (quantity * list_price* (1-discount))


--SELECT	b.order_date, YEAR(order_date) ord_year, DATEPART(ISO_WEEK, order_date) ord_week,
--		SUM(quantity * list_price* (1-discount)) total_turnover_by_day
--FROM	sale.order_item A, sale.orders B
--WHERE	A.order_id = B.order_id
--GROUP BY b.order_date
--ORDER BY 1



SELECT	DISTINCT b.order_date, YEAR(order_date) ord_year, DATEPART(ISO_WEEK, order_date) ord_week,
		SUM(quantity * list_price* (1-discount)) OVER (PARTITION BY b.order_date) total_turnover_by_day
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
ORDER BY 1


WITH T1 AS
(
SELECT	DISTINCT b.order_date, YEAR(order_date) ord_year, DATEPART(ISO_WEEK, order_date) ord_week,
		SUM(quantity * list_price* (1-discount)) OVER (PARTITION BY b.order_date) total_turnover_by_day
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
)
SELECT	DISTINCT ord_year, ord_week, MAX (total_turnover_by_day) OVER (PARTITION BY ord_year , ord_week) max_turnover_by_week
FROM	 T1


--ÖDEV!

---EN YÜKSEK TURNOVERIN HAFTANIN HANGÝ GÜNÜNE AÝT OLDUÐUNU YUKARIDAKÝ TABLOYA EKLEYÝNÝZ.















