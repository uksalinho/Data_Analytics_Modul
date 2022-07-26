--Üstte gönderdiğim Ass-2 nin join li kısmı
SELECT *
FROM
	(
	SELECT sc.customer_id, sc.first_name, sc.last_name
	FROM sale.customer sc, sale.orders so, sale.order_item soi, product.product pp
	WHERE sc.customer_id = so.customer_id
	AND	 so.order_id = soi.order_id
	AND soi.product_id = pp.product_id
	AND pp.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
	) AS J1
LEFT JOIN
	(SELECT sc.first_name,sc.customer_id
	FROM sale.customer sc, sale.orders so, sale.order_item soi, product.product pp
	WHERE sc.customer_id = so.customer_id
	AND	 so.order_id = soi.order_id
	AND soi.product_id = pp.product_id
	AND pp.product_name = 'Polk Audio - 50 W Woofer - Black'
	) AS J2
ON J1.customer_id = J2.customer_id
LEFT JOIN
	(SELECT sc.first_name,sc.customer_id
	FROM sale.customer sc, sale.orders so, sale.order_item soi, product.product pp
	WHERE sc.customer_id = so.customer_id
	AND	 so.order_id = soi.order_id
	AND soi.product_id = pp.product_id
	AND pp.product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)'
	) AS J3
ON J1.customer_id = J3.customer_id
LEFT JOIN
	(SELECT sc.first_name,sc.customer_id
	FROM sale.customer sc, sale.orders so, sale.order_item soi, product.product pp
	WHERE sc.customer_id = so.customer_id
	AND	 so.order_id = soi.order_id
	AND soi.product_id = pp.product_id
	AND pp.product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)'
	) AS J4
ON J1.customer_id = J4.customer_id


-------------------------------------------------------------------------------------------------------

--Altta gönderdiğim Ass-2


SELECT DISTINCT J1.customer_id, J1.first_name, J1.last_name, 
		ISNULL(NULLIF(ISNULL(J2.first_name, 'NO'),J1.first_name),'YES') AS First_product, 
		ISNULL(NULLIF(ISNULL(J3.first_name, 'NO'),J1.first_name),'YES') AS Second_product, 
		ISNULL(NULLIF(ISNULL(J4.first_name, 'NO'),J1.first_name),'YES') AS Third_product
FROM
	(
	SELECT sc.customer_id, sc.first_name, sc.last_name
	FROM sale.customer sc, sale.orders so, sale.order_item soi, product.product pp
	WHERE sc.customer_id = so.customer_id
	AND	 so.order_id = soi.order_id
	AND soi.product_id = pp.product_id
	AND pp.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
	) AS J1

LEFT JOIN

	(SELECT sc.first_name,sc.customer_id
	FROM sale.customer sc, sale.orders so, sale.order_item soi, product.product pp
	WHERE sc.customer_id = so.customer_id
	AND	 so.order_id = soi.order_id
	AND soi.product_id = pp.product_id
	AND pp.product_name = 'Polk Audio - 50 W Woofer - Black'
	) AS J2

ON J1.customer_id = J2.customer_id

LEFT JOIN

	(SELECT sc.first_name,sc.customer_id
	FROM sale.customer sc, sale.orders so, sale.order_item soi, product.product pp
	WHERE sc.customer_id = so.customer_id
	AND	 so.order_id = soi.order_id
	AND soi.product_id = pp.product_id
	AND pp.product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)'
	) AS J3

ON J1.customer_id = J3.customer_id

LEFT JOIN

	(SELECT sc.first_name,sc.customer_id
	FROM sale.customer sc, sale.orders so, sale.order_item soi, product.product pp
	WHERE sc.customer_id = so.customer_id
	AND	 so.order_id = soi.order_id
	AND soi.product_id = pp.product_id
	AND pp.product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)'
	) AS J4

ON J1.customer_id = J4.customer_id

ORDER BY customer_id