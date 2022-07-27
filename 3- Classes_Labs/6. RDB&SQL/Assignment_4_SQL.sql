
/***** Verilen tablolardan indirim etkisini saglikli hesaplamak icin; 
herbir 'indirim oranina' karsilik gelen 'g�nl�k ortalama' satilan �r�n sayilari hesaplanip, 
herbir �r�ne karsilik gelen g�nl�k satislarin tekrar ortalamasi hesaplanarak ortaya cikan sayi ile 
en az indirimin g�nl�k ortalama degeri karsilastirilarak bir karar verilebilir. 
*****/

/*Indirimlerin satisa etkisini tesbit edebilmek icin ihtiyac olan; 
-product_id
-order_date
-quantity
-list_price
-discount
bilgilerini alabilmek icin sale.orders ve sale.order_item tablolarini rahat kullanabilmek icin Join islemi yapip VIEW ini aliyoruz;
*/
CREATE VIEW disc_eff AS

SELECT  order_date,  so.order_id, soi.product_id, quantity, list_price, discount
FROM    sale.order_item soi, sale.orders so
WHERE   so.order_id = soi.order_id

/* 
product_id ve order_date lere g�re indirim  dagilimlarini g�rme amacli pivot table olusturup daha sonra kullanma adina VIEW aliyoruz;
*/
CREATE VIEW disc_pivot AS
SELECT  DISTINCT  order_date, order_id, product_id, [0.05], [0.07], [0.10], [0.20]
FROM    disc_eff
PIVOT
	(
		SUM(quantity)
		FOR discount
		IN ([0.05], [0.07], [0.10], [0.20])
	) AS pivot_table


/*
Her bir �r�n icin, her bir indirim oranina ait indirim yapilan g�nlere g�re ortalama satislarini hesaplarken
float degere d�n�st�rmek icin 1.0 ile carpip yeni tablonun VIEW ini aliyoruz;  
*/


CREATE VIEW per_day AS
SELECT  product_id,
		1.0*SUM([0.05])/COUNT([0.05]) per_day_05, 
		1.0*SUM([0.07])/COUNT([0.07]) per_day_07, 
		1.0*SUM([0.10])/COUNT([0.10]) per_day_10, 
		1.0*SUM([0.20])/COUNT([0.20]) per_day_20
FROM
        disc_pivot
GROUP BY product_id

SELECT * FROM effect_table


/*
Olusan tabloda indirimli satislarin ortalama degeri en d�s�k indirimli satistan;
fazla ise 'Positive',
esit ise 'Neutral',
az ise 'Negative'
olarak degerlendiriyoruz.
Heaplamada NULL degerlerin ortalamaya dahil olmayip saglikli bir ortalama almak icin ISNULL ve CASE WHEN fonksiyonlarini kullandik; 
*/


CREATE VIEW eff_table AS
SELECT product_id,
CASE 
WHEN 
	 (ISNULL(per_day_05, 0) + ISNULL(per_day_07, 0) + ISNULL(per_day_10, 0) + ISNULL(per_day_20, 0)) /
	
	 (( CASE WHEN per_day_05 IS NOT NULL THEN 1 ELSE 0 END ) +
	
	 ( CASE WHEN per_day_07 IS NOT NULL THEN 1 ELSE 0 END ) +
	
	 ( CASE WHEN per_day_10 IS NOT NULL THEN 1 ELSE 0 END ) +
	
	 ( CASE WHEN per_day_20 IS NOT NULL THEN 1 ELSE 0 END ))  > ISNULL(ISNULL(ISNULL(per_day_05, per_day_07),per_day_10),per_day_20) THEN 'Positive'

WHEN 
	 (ISNULL(per_day_05, 0) + ISNULL(per_day_07, 0) + ISNULL(per_day_10, 0) + ISNULL(per_day_20, 0)) / 
	 
	 (( CASE WHEN per_day_05 IS NOT NULL THEN 1 ELSE 0 END ) +
	 
	 ( CASE WHEN per_day_07 IS NOT NULL THEN 1 ELSE 0 END ) +
	 
	 ( CASE WHEN per_day_10 IS NOT NULL THEN 1 ELSE 0 END ) +
	 
	 ( CASE WHEN per_day_20 IS NOT NULL THEN 1 ELSE 0 END )) = ISNULL(ISNULL(ISNULL(per_day_05, per_day_07),per_day_10),per_day_20) THEN 'Neutral'
	
WHEN 
	 (ISNULL(per_day_05, 0) + ISNULL(per_day_07, 0) + ISNULL(per_day_10, 0) + ISNULL(per_day_20, 0)) / 
	 
	 (( CASE WHEN per_day_05 IS NOT NULL THEN 1 ELSE 0 END ) +
	 
	 ( CASE WHEN per_day_07 IS NOT NULL THEN 1 ELSE 0 END ) +
	 
	 ( CASE WHEN per_day_10 IS NOT NULL THEN 1 ELSE 0 END ) +
	 
	 ( CASE WHEN per_day_20 IS NOT NULL THEN 1 ELSE 0 END )) / 4 < ISNULL(ISNULL(ISNULL(per_day_05, per_day_07),per_day_10),per_day_20) THEN 'Negative'

END AS [Discount Effect]
FROM per_day


/*
Ortalama satis sayilari ve indirim  etkisini beraber g�r�p kontrol amacli per_day ve eff_table tablolarini join yapip kontrol ediyoruz;
*/


SELECT per_day.product_id, per_day_05, per_day_07, per_day_10, per_day_20, [Discount Effect]
FROM per_day, eff_table
WHERE per_day.product_id = eff_table.product_id