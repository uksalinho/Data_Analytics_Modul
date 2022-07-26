CREATE DATABASE ASSIGMENT3;

CREATE TABLE ecommerz
(
	Visitor_ID int PRIMARY KEY NOT NULL,
	Adv_Type nvarchar(50) NOT NULL,
	Action nvarchar(50) NOT NULL,

	);


INSERT INTO ASSIGMENT3.dbo.ecommerz(Visitor_ID, Adv_Type, Action)
VALUES
(1,'A','Left'),
(2,'A','Order'),
(3,'B','Left'),
(4,'A','Order'),
(5,'A','Review'),
(6,'A','Left'),
(7,'B','Left'),
(8,'B','Order'),
(9,'B','Review'),
(10,'A','Review')


SELECT *
FROM ecommerz;

SELECT
		Adv_Type,
		SUM(CASE WHEN Action = 'Order' THEN 1 ELSE 0 END) AS Ord,
		SUM(CASE WHEN Action = 'Left' THEN 1 ELSE 0 END) AS Lef,
		SUM(CASE WHEN Action = 'Review' THEN 1 ELSE 0 END) AS Rev
INTO Conversion_Rate
FROM ecommerz
GROUP BY Adv_Type

SELECT *
FROM Conversion_Rate;

SELECT COUNT(*)      --2
FROM Conversion_Rate;

SELECT
		Adv_Type,
		CAST((1.0 * Ord / (Ord + Lef + Rev)) AS NUMERIC(3,2)) AS 'Conversion_Rate'
FROM Conversion_Rate
