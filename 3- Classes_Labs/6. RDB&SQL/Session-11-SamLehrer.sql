 ----- S E S S I O N - 1 1 -----

 --- lead

 ID
 1
 6
 5
 3
 2
 4

 --- istenilen
 ID

 1 2 
 2 3 
 3 4
 4 5
 5 6 
 6 null

--- bir sonraki
 SELECT LEAD(ID) OVER (ORDER BY ID)

 --- bir önceki

 1 null
 2 1
 3 2
 4 3
 5 4
 6 5

 SELECT LAG(ID) OVER (ORDER BY ID)


 SELECT order_date, customer_id 
 FROM sale.orders

 SELECT order_date, customer_id 
 FROM sale.orders

 SELECT order_date, customer_id, LEAD(customer_id) OVER (ORDER BY order_date)
 FROM sale.orders


 --- Müþterilerin sipariþinden sonraki sipariþi veren müþteriyi bulunuz.

 SELECT order_id, customer_id
 FROM sale.orders

 SELECT order_id, customer_id, 
		LEAD(customer_id) OVER (ORDER BY order_id) next_cust,
		LAG(customer_id) OVER (ORDER BY order_id) pre_cust
 FROM sale.orders
 ORDER BY order_id

 SELECT order_id, customer_id, 
		LEAD(customer_id, 3) OVER (ORDER BY order_id) next_cust,
		LAG(customer_id, 3) OVER (ORDER BY order_id) pre_cust
 FROM sale.orders
 ORDER BY order_id


 ----- QUESTION : List customers whose have at least 2 consecutive orders are not shipped.

SELECT * FROM sale.order_item
SELECT * FROM sale.orders

--- sipariþin kargolanýp kargolanmadýðýný nasýl anlarým?
SELECT *
FROM sale.orders
WHERE shipped_date IS NULL

--- shipped_date NULL ise kargolanmamýþtýr.

--- Her bir sipariþin kargolanýp kargolanmadýðý bilgisini yazdýrýnýz

SELECT
	customer_id,
	order_id,
	order_date,
	CASE WHEN shipped_date IS NOT NULL THEN 'Yes' ELSE 'No' END AS is_shipped
FROM sale.orders

SELECT
	customer_id,
	order_id,
	order_date,
	CASE WHEN shipped_date IS NOT NULL THEN 'Yes' ELSE 'No' END AS is_shipped
FROM sale.orders
ORDER BY customer_id

--- Müþterilerin  her bir sipariþi için bir sonraki sipariþin kargolanýp kargolanmadýðý bilgisini yeni bir sütunda yazdýrýnýz

WITH T1 AS
(
SELECT
	customer_id,
	order_id,
	order_date,
	CASE WHEN shipped_date IS NOT NULL THEN 'Yes' ELSE 'No' END AS is_shipped
FROM sale.orders
)
SELECT *,
	LEAD(is_shipped) OVER (PARTITION BY customer_id ORDER BY order_id) AS next_order_shipping
FROM T1
WHERE is_shipped = 'No'



SELECT *
FROM (
		SELECT *,
			LEAD(is_shipped) OVER (PARTITION BY customer_id ORDER BY order_id) AS next_order_shipping
		FROM (
				SELECT
					customer_id,
					order_id,
					order_date,
					CASE WHEN shipped_date IS NOT NULL THEN 'Yes' ELSE 'No' END AS is_shipped
				FROM sale.orders
			) A
	) B
WHERE is_shipped = 'No'
AND next_order_shipping = 'No'


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




----- QUESTION : Calculate 7-day moving average of the number of products sold between 2018-03-12 and 2018-04-12


SELECT	*,
		ROUND(AVG (sum_quantity) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),1) AS sales_moving_average_7
FROM (
		SELECT	A.order_date,
				CAST(SUM (B.quantity)AS NUMERIC(3,1)) AS sum_quantity
		FROM sale.orders A, sale.order_item B
		WHERE A.order_id = B.order_id
		AND A.order_date BETWEEN '2018-03-12' AND '2018-04-12'
		GROUP BY A.order_date
	) A


WITH T1 AS
(
SELECT	order_date, SUM(quantity) cnt_product
FROM	sale.orders A, sale.order_item B
WHERE	A.order_id = B.order_id
AND		a.order_date BETWEEN '2018-03-12' AND '2018-04-12'
GROUP BY order_date
)
SELECT	order_date, cnt_product,
		ROUND (CAST(AVG(cnt_product) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS NUMERIC (3,1)), 1)
FROM	T1


----- QUESTION : Write a query that returns the highest turnover amount for each week on yearly basis

SELECT	*,
		MAX(total_turnover_by_day) OVER (PARTITION BY ord_year, ord_week) max_weekly_turnover
FROM (
		SELECT	DISTINCT B.order_date, 
				YEAR(order_date) ord_year, 
				DATEPART(ISO_WEEK, order_date) ord_week,
				SUM(quantity * list_price * (1-discount)) OVER (PARTITION BY b.order_date) total_turnover_by_day
		FROM sale.order_item A, sale_orders B
		WHERE A.order_id = B.order_id
	) A


SELECT	DISTINCT 		
		ord_year,
		ord_week,
		MAX(total_turnover_by_day) OVER (PARTITION BY ord_year, ord_week) max_weekly_turnover
FROM (
		SELECT	DISTINCT B.order_date, 
				YEAR(order_date) ord_year, 
				DATEPART(ISO_WEEK, order_date) ord_week,
				SUM(quantity * list_price * (1-discount)) OVER (PARTITION BY b.order_date) total_turnover_by_day
		FROM sale.order_item A, sale_orders B
		WHERE A.order_id = B.order_id
	) A



SELECT
		ord_year,
		ord_week,
		order_date,
		total_turnover_by_day
FROM	(
		SELECT	 
				*,
				ROW_NUMBER() OVER (PARTITION BY ord_year, ord_week ORDER BY total_turnover_by_day DESC) row_num
		FROM	(
				SELECT	DISTINCT B.order_date, 
				YEAR(order_date) ord_year, 
				DATEPART(ISO_WEEK, order_date) ord_week,
				SUM(quantity * list_price * (1-discount)) OVER (PARTITION BY b.order_date) total_turnover_by_day
				FROM sale.order_item A, sale_orders B
				WHERE A.order_id = B.order_id
				) A
		) B
WHERE row_num = 1