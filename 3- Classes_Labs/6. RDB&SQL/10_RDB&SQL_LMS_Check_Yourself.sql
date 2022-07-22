---------- CHECK YOURSELF (FUNCTIONS)

--- List the product names in ascending order where the part from the beginning to the first space character is "Samsung" in the 
--- product_name column.
--- (Use SampleRetail Database and paste your result in the box below.)

SELECT * FROM product.product

SELECT product_name    
FROM product.product
WHERE product_name LIKE 'Samsung %'
ORDER BY product_name;

--- Alternative
SELECT product_name
FROM product.product
WHERE LEFT (product_name, CHARINDEX(' ', product_name)) = 'Samsung'
ORDER BY product_name;

--- SUBSTRING(product_name, CHARINDEX(' ', product_name)+1, LEN(product_name)-CHARINDEX(' ', product_name)) product_brand

--- Write a query that returns streets in ascending order. The streets have an integer character lower than 5 after the "#" character end 
--- of the street. (use sale.customer table)
--- (Use SampleRetail Database and paste your result in the box below.)

SELECT * FROM sale.customer

--- Bu yanlýþ
SELECT street, SUBSTRING(street, CHARINDEX('#', street)+1, LEN(street)-CHARINDEX('#', street)) street_order
FROM sale.customer
ORDER BY street_order;

--- Nesrin Hoca
select street 
from sale.customer
where Substring(street, Charindex( '#', street), 1)= '#'
and Substring(street, Charindex( '#', street)+1 , len(street) ) < 5
order by 1


---------- CHECK YOURSELF (JOINS & VIEW)

--- Write a query that returns the order date of the product named "Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black".
--- (Use SampleRetail Database and paste your result in the box below.)

SELECT * FROM product.product
SELECT * FROM sale.orders
SELECT * FROM sale.order_item

SELECT 
    A.product_name,
	B.order_id,
	B.order_date
FROM product.product A
INNER JOIN sale.order_item C
	ON A.product_id = C.product_id
INNER JOIN sale.orders B
	ON B.order_id = C.order_id
WHERE product_name LIKE '%Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black%'
ORDER BY B.order_date;



--- Write a query that returns orders of the products branded "Seagate". It should be listed Product names and order IDs of all the products 
--- ordered or not ordered. (order_id in ascending order)
--- (Use SampleRetail Database and paste your result in the box below.)

SELECT * FROM product.product
SELECT * FROM product.brand
SELECT * FROM sale.orders
SELECT * FROM sale.order_item

SELECT 
    A.product_name,
	B.brand_name,
	C.order_id
FROM product.product A
INNER JOIN product.brand B
	ON A.brand_id = B.brand_id
INNER JOIN sale.order_item C
	ON A.product_id = C.product_id
WHERE B.brand_name LIKE '%Seagate%';

--- Nesrin Hoca
SELECT b.product_name,  c.order_id
from product.brand as a
left join product.product as b
	ON b.brand_id = a.brand_id
left join  sale.order_item as c
   ON b.product_id= c.product_id	
WHERE a.brand_name = 'Seagate'
ORDER BY c.order_id asc




---------- CHECK YOURSELF (ADVANCED GROUPING OPERATIONS)

--- Write a query that returns the count of orders of each day between '2020-01-19' and '2020-01-25'. Report the result using Pivot Table.
--- Note: The column names should be day names (Sun, Mon, etc.).
--- (Use SampleRetail DB on SQL Server and paste the result in the answer box.)

SELECT * FROM sale.orders

SELECT *
FROM (
		SELECT order_id, DATENAME(DW, order_date) AS date
		FROM sale.orders
		WHERE order_date >= '2020-01-19' and order_date <= '2020-01-25') A
PIVOT
(
COUNT(order_id)
FOR	date
IN	(
	[Monday],
    [Tuesday],
    [Wednesday],
    [Thursday],
    [Friday],
    [Saturday],
    [Sunday]
	)
) AS PIVOT_TABLE

--- ROW Olarak (Day)
SELECT 
    DATENAME(DW, order_date) AS date, 
    COUNT(order_id) AS count 
FROM sale.orders
    WHERE order_date >= '2020-01-19' and order_date <= '2020-01-25' 
GROUP BY 
    DATENAME(DW, order_date)

--- ROW Olarak (Tarih)
SELECT 
    DATEPART(DAY, order_date) AS date, 
    COUNT(order_id) AS count 
FROM sale.orders
    WHERE order_date >= '2020-01-19' and order_date <= '2020-01-25' 
GROUP BY 
    DATEPART(DAY, order_date)


--- Please write a query to return only the order ids that have an average amount of more than $2000. Your result set should include order_id. 
--- Sort the order_id in ascending order.
--- (Use SampleRetail DB on SQL Server and paste the result in the answer box.)

SELECT * FROM sale.order_item


SELECT order_id, AVG((list_price*(1-discount))*quantity) AS avg_amount
FROM sale.order_item
GROUP BY order_id
HAVING AVG((list_price*(1-discount))*quantity) > 2000
ORDER BY order_id ASC;

--- Satýþ fiyatý farklý hesaplama (Without Discount)
SELECT order_id, AVG(list_price*quantity) AS avg_amount
FROM sale.order_item
GROUP BY order_id
HAVING AVG(list_price*quantity) > 2000
ORDER BY order_id ASC;


---------- CHECK YOURSELF (SET OPERATORS)

--- Detect the store that does not have a product named "Samsung Galaxy Tab S3 Keyboard Cover" in its stock. (Paste the store name in 
--- the box below.)
--- (Use SampleRetail Database and paste your result in the box below.)

SELECT * FROM product.stock
SELECT * FROM product.product
SELECT * FROM sale.store

SELECT product_id 
FROM product.product
WHERE product_name = 'Samsung Galaxy Tab S3 Keyboard Cover'

SELECT store_name
FROM sale.store
WHERE store_id NOT IN (
						SELECT A.store_id
						FROM sale.store A, product.stock B
						WHERE A.store_id = B.store_id
						AND B.product_id = 320)

--- Alternative
SELECT store_name
FROM sale.store
WHERE store_id NOT IN (
						SELECT A.store_id
						FROM sale.store A, product.stock B, product.product C
						WHERE A.store_id = B.store_id
						AND B.product_id = C.product_id
						AND C.product_name = 'Samsung Galaxy Tab S3 Keyboard Cover')

--- Alternative
SELECT store_id, store_name
FROM sale.store
EXCEPT
SELECT A.store_id, store_name
FROM sale.store A, product.stock B, product.product C
WHERE A.store_id = B.store_id
AND B.product_id = C.product_id
AND C.product_name = 'Samsung Galaxy Tab S3 Keyboard Cover'


--- List in ascending order the stores where both "Samsung Galaxy Tab S3 Keyboard Cover" and "Apple - Pre-Owned iPad 3 - 64GB - Black" 
--- are stocked.
--- (Use SampleRetail Database and paste your result in the box below.)

SELECT product_id 
FROM product.product
WHERE product_name = 'Apple - Pre-Owned iPad 3 - 64GB - Black'

SELECT store_name
FROM sale.store
WHERE store_id IN (
				   SELECT A.store_id
				   FROM sale.store A, product.stock B, product.product C
				   WHERE A.store_id = B.store_id
						AND B.product_id = C.product_id
						AND C.product_name = 'Samsung Galaxy Tab S3 Keyboard Cover'
				   INTERSECT
				   SELECT A.store_id
				   FROM sale.store A, product.stock B, product.product C
				   WHERE A.store_id = B.store_id
						AND B.product_id = C.product_id
						AND C.product_name = 'Apple - Pre-Owned iPad 3 - 64GB - Black')
ORDER BY store_name;



---------- CHECK YOURSELF (CASE EXPRESSION)

--- List counts of orders on the weekend and weekdays. (First weekend)
--- (Use SampleRetail Database and paste your result in the box below.)

SELECT COUNT(order_id) TotalOrders,
	   COUNT(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Saturday' THEN 1 END) Saturday,
	   COUNT(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Sunday' THEN 1 END) Sunday,
	   COUNT(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Monday' THEN 1 END) Monday,
	   COUNT(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Tuesday' THEN 1 END) Tuesday,
	   COUNT(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Wednesday' THEN 1 END) Wednesday,
	   COUNT(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Thursday' THEN 1 END) Thursday,
	   COUNT(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Friday' THEN 1 END) Friday 
FROM sale.orders

--- Alternative
SELECT COUNT(order_id) TotalOrders,
	   COUNT(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Saturday' 
	                OR DATENAME(WEEKDAY, order_date) = 'Sunday' THEN 1 END) weekend,
	   COUNT(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Monday'
	                OR DATENAME(WEEKDAY, order_date) = 'Tuesday'
					OR DATENAME(WEEKDAY, order_date) = 'Wednesday'
					OR DATENAME(WEEKDAY, order_date) = 'Thursday'
					OR DATENAME(WEEKDAY, order_date) = 'Friday' THEN 1 END) weekday
FROM sale.orders

--- Alternative
SELECT * FROM sale.orders

SELECT	order_id,
		order_date,
		DATENAME(DW, order_date) AS day_of_week,
		(CHOOSE(DATEPART(DW, order_date),'Weekend','Weekday','Weekday','Weekday','Weekday','Weekday','Weekend')) AS order_day
INTO sale_orders
FROM sale.orders

SELECT * FROM dbo.sale_orders

SELECT COUNT(DISTINCT order_id) TotalOrders,
	   COUNT(CASE WHEN Order_Day = 'WEEKEND' THEN 1 END) WeekEnd,
	   COUNT(CASE WHEN Order_Day = 'Weekday' THEN 1 END) WeekDay
FROM dbo.sale_orders


---Nesrin Hoca
with T1 as
(
select distinct order_date, a.order_id,
case 
    when datename(DW, order_date)= 'Saturday' then 'Weekend'
	when datename(DW, order_date)= 'Sunday' then 'Weekend'
	else 'Weekdays'
end as  weekly
from sale.orders a, sale.order_item b
where a.order_id= b.order_id
)
SELECT COUNT(DISTINCT order_id) TotalOrders,
	   COUNT(CASE WHEN weekly = 'Weekend' THEN 1 END) WeekEnd,
	   COUNT(CASE WHEN weekly = 'Weekdays' THEN 1 END) WeekDay
FROM T1

--- OWEN HOCA

SELECT *
FROM (
	SELECT	CASE 
			WHEN DATENAME(weekday, order_date) IN ('SATURDAY', 'SUNDAY') THEN 'WEEKEND' ELSE 'WEEKDAY' END WEEKD, order_id
	FROM SALE.orders
	) A
PIVOT
(
COUNT (order_id)
FOR WEEKD
IN ([weekend], [weekday])
) AS pivot_table


--- Classify staff according to the count of orders they receive as follows:
--- a) 'High-Performance Employee' if the number of orders is greater than 400
--- b) 'Normal-Performance Employee' if the number of orders is between 100 and 400
--- c) 'Low-Performance Employee' if the number of orders is between 1 and 100
--- d) 'No Order' if the number of orders is 0
--- Then, list the staff's first name, last name, employee class, and count of orders.  (Count of orders and first names in ascending order)

SELECT * FROM sale.staff
SELECT * FROM sale.orders

SELECT	A.staff_id, 
		A.first_name, 
		A.last_name,
		COUNT(B.order_id) AS order_count,
		CASE 
			WHEN COUNT(B.order_id) > 400 THEN 'High-Performance Employee'
			WHEN COUNT(B.order_id) > 100 AND COUNT(B.order_id) <= 400 THEN 'Normal_Performance_Employee'
			WHEN COUNT(B.order_id) >= 1 AND COUNT(B.order_id) <= 400 THEN 'Low_Performance_Employee'
			WHEN COUNT(B.order_id) = 0 THEN 'No_Order'			
		END employee_class
FROM sale.staff A
LEFT JOIN sale.orders B
ON A.staff_id = B.staff_id
GROUP BY A.staff_id, A.first_name, A.last_name
ORDER BY COUNT(B.order_id)


SELECT	A.staff_id, 
		A.first_name, 
		A.last_name,
		COUNT(DISTINCT B.order_id) AS order_count
FROM sale.staff A
LEFT JOIN sale.orders B
ON A.staff_id = B.staff_id
GROUP BY A.staff_id, A.first_name, A.last_name
ORDER BY COUNT(B.order_id)

--- OWEN HOCA
select first_name, last_name, 
case when cnt_order > 400 then 'High-Performance Employee'
 when cnt_order between 100 and 400 then 'Normal-Performance Employee'
  when cnt_order between 1 and 100 then 'Low-Performance Employee'
 else 'No Order' end as employeeclass, cnt_order
from
(
SELECT	a.staff_id, a.first_name, a.last_name, count(b.order_id) cnt_order
FROM	SALE.staff A left join SALE.orders B
on	A.staff_id = b.staff_id 
group by a.staff_id,a.first_name, a.last_name
) a
order by cnt_order, first_name



---------- CHECK YOURSELF (SUBQUERIES AND CTE)

--- List the store names in ascending order that did not have an order between "2018-07-22" and "2018-07-28".
--- (Use SampleRetail Database and paste your result in the box below.)

SELECT * FROM sale.store
SELECT * FROM sale.orders

SELECT store_name
FROM sale.store
WHERE store_id NOT IN (
						SELECT A.store_id
						FROM sale.store A, sale.orders B
						WHERE A.store_id = B.store_id
						AND	B.order_date BETWEEN '2018-07-22' AND '2018-07-28')
ORDER BY store_name ASC;

--- Eftal Hoca
WITH T1 AS(SELECT DISTINCT S.store_id, S.store_name, O.order_id, O.order_dateFROM	sale.orders O, sale.store SWHERE	O.store_id = S.store_idAND	O.order_date BETWEEN  '2018-07-22' AND '2018-07-28')SELECT store_name FROM sale.store WHERE store_name NOT IN (SELECT store_name FROM T1)

		

--- List customers with each order over 500$ and reside in the city of Charleston. List customers' first name and last name 
--- (both of the last name and first name in ascending order). 
--- (Use SampleRetail Database and paste your result in the box below.)
SELECT * FROM sale.customer


--- OWEN HOCA
SELECT DISTINCT x.customer_id, x.first_name, x.last_name
FROM (
	SELECT A.customer_id, A.first_name, A.last_name
	FROM sale.customer A, sale.orders B, sale.order_item C
	WHERE A.customer_id = B.customer_id
	AND A.city = 'Charleston'
	) x
WHERE NOT EXISTS (
				  SELECT A.customer_id, C.order_id, SUM(quantity*list_price) sum_price
				  FROM sale.customer A, sale.orders B, sale.order_item C
				  WHERE  A.customer_id = B.customer_id
				  AND B.order_id = C.order_id
				  AND x.customer_id = A.customer_id
				  GROUP BY A.customer_id, C.order_id
				  HAVING SUM(quantity*list_price) < 500
				  )
ORDER BY 2,1

--- Eftal Hoca
WITH T1 AS(SELECT	C.customer_id,  C.first_name, C.last_name, C.city, O.order_id, SUM(I.quantity* I.list_price) OVER(PARTITION BY O.order_id, C.customer_id) sum_priceFROM	sale.customer C, sale.orders O, sale.order_item IWHERE	C.customer_id = O.customer_idAND		O.order_id = I.order_idAND		C.city = 'Charleston')SELECT DISTINCT customer_id, first_name, last_nameFROM T1WHERE	customer_id IN (SELECT DISTINCT customer_id FROM T1  GROUP BY customer_id HAVING MIN(sum_price) > 500)ORDER BY 3,2





---------- CHECK YOURSELF (WINDOW FUNCTIONS)
--- Write a query using the window function that returns staffs' first name, last name, and their total net amount of orders in descending order.
--- (Use SampleRetail Database and paste your result in the box below.)
SELECT * FROM sale.staff
SELECT * FROM sale.orders
SELECT * FROM sale.order_item

--- GROUP BY ile
SELECT A.first_name, A.last_name, SUM(C.quantity * C.list_price * (1 - C.discount)) AS total_net_amount
FROM sale.staff A, sale.orders B, sale.order_item C
WHERE A.staff_id = B.staff_id 
AND B.order_id = C.order_id
GROUP BY A.first_name, A.last_name
ORDER BY SUM(C.quantity * C.list_price * (1 - C.discount)) DESC;

--- WF ile
SELECT DISTINCT A.first_name, A.last_name, SUM(C.quantity*C.list_price*(1-C.discount)) OVER (PARTITION BY A.staff_id) AS total_net_amount
FROM sale.staff A, sale.orders B, sale.order_item C
WHERE A.staff_id = B.staff_id 
AND B.order_id = C.order_id
ORDER BY 3 DESC;



--- List the employee's first order dates by month in 2020. Expected columns are: first name, last name, month and the first order date. 
--- (last name and month in ascending order)
--- (Use SampleRetail Database and paste your result in the box below.)

--- GROUP BY ile
SELECT A.first_name, A.last_name, MONTH(B.order_date)
FROM sale.staff A, sale.orders B, sale.order_item C
WHERE A.staff_id = B.staff_id 
AND B.order_id = C.order_id
AND YEAR(B.order_date) = 2020
GROUP BY A.first_name, A.last_name, MONTH(B.order_date)
ORDER BY 2,3 ASC;

--- WF ile
SELECT DISTINCT A.first_name, A.last_name,  MONTH(B.order_date) AS month,
FIRST_VALUE(B.order_date) OVER (PARTITION BY A.staff_id, MONTH(B.order_date) ORDER BY B.order_id) AS first_order_date
FROM sale.staff A, sale.orders B, sale.order_item C
WHERE A.staff_id = B.staff_id 
AND B.order_id = C.order_id
AND YEAR(B.order_date) = 2020
ORDER BY 2,3 ASC;

--- Write a query using the window function that returns the cumulative total turnovers of the Burkes Outlet by order date 
--- between "2019-04-01" and "2019-04-30".
--- Columns that should be listed are: 'order_date' in ascending order and 'Cumulative_Total_Price'.

SELECT DISTINCT A.order_date, SUM(B.quantity*B.list_price) OVER (ORDER BY A.order_date) AS Cumulative_Total_Price
FROM sale.orders A, sale.order_item B, sale.store C
WHERE A.order_id = B.order_id 
AND	A.store_id = C.store_id
AND C.store_name= 'Burkes Outlet'
AND A.order_date BETWEEN '2019-04-01' AND '2019-04-30'
ORDER BY 1

--- GROUP BY ile
SELECT DISTINCT A.order_date, SUM(B.quantity*B.list_price) AS total_price
FROM sale.orders A, sale.order_item B, sale.store C
WHERE A.order_id = B.order_id 
AND	A.store_id = C.store_id
AND C.store_name= 'Burkes Outlet'
AND A.order_date BETWEEN '2019-04-01' AND '2019-04-30'
GROUP BY A.order_date
ORDER BY 1



--- ÝLAVE
--List the employee's first order dates and the first product they sold. --Expected columns are: "first_name", "last_name" in ascending order, "order_date" and "product_name".--(Use SampleRetail Database and paste your result in the box below.)SELECT	DISTINCT S.first_name, S.last_name,		FIRST_VALUE (O.order_date) OVER (PARTITION BY O.staff_id ORDER BY O.order_date) first_order_date, 		FIRST_VALUE (P.product_name) OVER (PARTITION BY O.staff_id ORDER BY O.order_date) first_product_nameFROM	sale.staff S, sale.orders O, sale.order_item I, product.product PWHERE	S.staff_id = O.staff_idAND		I.order_id = O.order_idAND		I.product_id = P.product_idORDER BY 1 ASC, 2 ASC

