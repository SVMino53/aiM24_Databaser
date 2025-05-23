/*

Företagets totala produktkatalog består av 77 unika produkter.
Om vi kollar bland våra ordrar, hur stor andel av dessa produkter
har vi någon gång leverarat till London?

*/

select * from company.products
select * from company.orders
select * from company.order_details

select * from company.products

SELECT 
    CAST(
        100.0 * COUNT(DISTINCT CASE WHEN co.ShipCity = 'London' THEN cp.Id END) / NULLIF(COUNT(DISTINCT cp.Id), 0) AS FLOAT
		) AS PercentageDeliveredToLondon
FROM 
    company.orders AS co
JOIN 
    company.order_details AS cd ON cd.OrderId = co.Id
JOIN 
    company.products AS cp ON cp.Id = cd.ProductId


SELECT 

		COUNT(DISTINCT(productid)) /

       (SELECT CAST(COUNT(*) AS FLOAT) 
		FROM company.products) AS unique_products_london_delivered
FROM company.order_details AS od
JOIN company.orders AS o
ON od.orderid = o.id
WHERE shipcity = 'London';


/*
Till vilken stad har vi levererat flest unika produkter?
*/

SELECT
-- SELECT TOP 1         används för att endast få den stad som vi har levererat flest produkter till
    co.ShipCity,
    COUNT(DISTINCT cp.Id) AS UniqueProducts
FROM 
    company.orders AS co
JOIN 
    company.order_details AS cd ON cd.OrderId = co.Id
JOIN 
    company.products AS cp ON cp.Id = cd.ProductId
GROUP BY 
    co.ShipCity
ORDER BY 
	UniqueProducts DESC

/*

Av de produkter som inte längre finns I vårat sortiment,
hur mycket har vi sålt för totalt till Tyskland?

*/

select * from company.products

SELECT
	*
FROM 
    company.orders AS co
JOIN 
    company.order_details AS cd ON cd.OrderId = co.Id
JOIN 
    company.products AS cp ON cp.Id = cd.ProductId
WHERE 
	cp.Discontinued = 1 AND co.ShipCountry = 'Germany'



SELECT
    SUM(OD.UnitPrice * OD.Quantity * (1 - Discount)) AS TotalRevenue-- Multiplicera styckpriset med antalet sålda produkter och dra sedan av eventuell rabatt
FROM 
    company.order_details AS OD
JOIN 
    company.orders AS O ON OD.OrderId = O.Id
JOIN 
    company.products AS P ON OD.ProductId = P.Id
WHERE 
    P.Discontinued = 1
    AND O.ShipCountry LIKE 'Germany';



SELECT 
    SUM((od.UnitPrice * Quantity) * (1 - Discount)) AS [Summa försäljning]
FROM company.order_details od
JOIN company.orders o ON o.Id = od.OrderId
JOIN company.products p ON od.ProductId = p.Id
WHERE Discontinued = 1 AND ShipCountry = 'Germany'


/*

För vilken produktkategori har vi högst lagervärde?

*/


select categoryid from company.products

SELECT TOP 1
	   categoryid, 
       SUM(unitsinstock * unitprice) AS stock_value 
FROM company.products
GROUP BY categoryid
ORDER BY stock_value DESC;


/*

Från vilken leverantör har vi sålt flest produkter totalt?

*/

SELECT
	*
FROM 
    company.order_details AS OD
JOIN 
    company.orders AS O ON OD.OrderId = O.Id
JOIN 
    company.products AS P ON OD.ProductId = P.Id




SELECT
	P.SupplierId AS [Leverantörens ID],
	SUM(OD.Quantity) AS [Beställningar]
FROM 
    company.order_details AS OD
JOIN 
    company.orders AS O ON OD.OrderId = O.Id
JOIN 
    company.products AS P ON OD.ProductId = P.Id
GROUP BY
	P.SupplierId
ORDER BY
	[Beställningar] DESC

/*

Från vilken leverantör har vi sålt flest produkter totalt under sommaren
2013?

*/


SELECT
	*
FROM 
    company.order_details AS OD
JOIN 
    company.orders AS O ON OD.OrderId = O.Id
JOIN 
    company.products AS P ON OD.ProductId = P.Id


SELECT
	*
FROM 
    company.order_details AS OD
JOIN 
    company.orders AS O ON OD.OrderId = O.Id
JOIN 
    company.products AS P ON OD.ProductId = P.Id
WHERE
	YEAR(CAST(O.OrderDate AS DATE)) = 2013
	AND MONTH(CAST(O.OrderDate AS DATE)) IN (6, 7, 8)


SELECT
	P.SupplierId AS [Leverantörens ID],
	SUM(OD.Quantity) AS [Beställningar sommaren 2013]
FROM 
    company.order_details AS OD
JOIN 
    company.orders AS O ON OD.OrderId = O.Id
JOIN 
    company.products AS P ON OD.ProductId = P.Id
-- Ta bara med produkter som beställts i juni, juli eller augusti år 2013
WHERE
	YEAR(CAST(O.OrderDate AS DATE)) = 2013
	AND MONTH(CAST(O.OrderDate AS DATE)) IN (6, 7, 8)
GROUP BY
	P.SupplierId
ORDER BY
	[Beställningar sommaren 2013] DESC;