-- Prodaja artikla Mountain Bike 100, Silver 40 po gradu i državi u valuti i komadima odvojeno

SELECT p.Name AS ProductName, ci.Name AS City, co.Name AS Country, SUM(oi.Quantity) AS TotalQuantity, SUM(oi.Quantity * oi.UnitPrice) AS TotalSalesAmount
FROM WebshopDB.dbo.OrderItem oi 
JOIN WebshopDB.dbo.Product p ON oi.ProductID = p.ProductID
JOIN WebshopDB.dbo.Orders o ON oi.OrderID = o.OrderID
JOIN WebshopDB.dbo.Address a ON o.AddressID = a.AddressID
JOIN WebshopDB.dbo.City ci ON a.CityID = ci.CityID
JOIN WebshopDB.dbo.Country co ON ci.CountryID = co.CountryID
--WHERE p.Name = 'Mountain-100 Silver, 40'
WHERE p.Name = 'Mountain-200 Silver, 38'
GROUP BY p.Name, ci.Name, co.Name
ORDER BY ci.Name, co.Name

-- Broj narudžbi za top 10 najprodavanijih artikala (najprodavaniji u komadima ne u novcu)

SELECT TOP 10 p.Name AS ProductName, COUNT(DISTINCT oi.OrderID) AS NumberOfOrders, SUM (oi.Quantity) AS TotalQuantitySold
FROM WebshopDB.dbo.OrderItem oi
JOIN WebshopDB.dbo.Product p ON oi.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalQuantitySold DESC

-- Prodaja koja je naplaæena po brendu, kao i posebna kolona preostalog iznosa za naplatu

SELECT b.Name AS BrandName, p.PaymentStatus, SUM(o.TotalAmount) AS TotalOrderAmount, ISNULL(SUM(paid.TotalAmount), 0) AS PaidTotalAmount, 
ISNULL(SUM(cancelled.TotalAmount), 0) AS Cancelled, ISNULL(SUM(pending.TotalAMount), 0) AS Panding
FROM WebshopDB.dbo.Orders o
JOIN WebshopDB.dbo.OrderItem oi ON o.OrderID = oi.OrderID
JOIN WebshopDB.dbo.Product pr ON oi.ProductID = pr.ProductID
JOIN WebshopDB.dbo.Brand b ON pr.BrandID = b.BrandID
LEFT JOIN WebshopDB.dbo.Payment p ON o.PaymentID = p.PaymentID
LEFT JOIN WebshopDB.dbo.Orders paid ON paid.OrderID = o.OrderID AND p.PaymentStatus = 'Completed'
LEFT JOIN WebshopDB.dbo.Orders cancelled ON cancelled.OrderID = o.OrderID AND p.PaymentStatus = 'Cancelled'
LEFT JOIN WebshopDB.dbo.Orders pending ON pending.OrderID = o.OrderID AND p.PaymentStatus = 'Pending'
GROUP BY b.Name, p.PaymentStatus
ORDER BY b.Name;

SELECT	b.Name AS BrandName,
	p.PaymentStatus,
	SUM(o.TotalAmount) AS TotalOrderAmount,
	SUM(case when p.PaymentStatus = 'Completed' then o2.TotalAmount else 0 end) AS PaidTotalAmount, 
	SUM(case when p.PaymentStatus = 'Cancelled' then o2.TotalAmount else 0 end) AS Cancelled,
	SUM(case when p.PaymentStatus = 'Pending' then o2.TotalAmount else 0 end) AS Pending
FROM	WebshopDB.dbo.Orders o
	JOIN WebshopDB.dbo.OrderItem oi
		ON o.OrderID = oi.OrderID
	JOIN WebshopDB.dbo.Product pr
		ON oi.ProductID = pr.ProductID
	JOIN WebshopDB.dbo.Brand b
		ON pr.BrandID = b.BrandID
	LEFT JOIN WebshopDB.dbo.Payment p
		ON o.PaymentID = p.PaymentID
	LEFT JOIN WebshopDB.dbo.Orders o2
		ON o2.OrderID = o.OrderID
GROUP BY b.Name, p.PaymentStatus
ORDER BY b.Name;

-- Top 5 korisnika sa najveæom finansijskom prodajom

SELECT TOP 5 u.UserID,(u.FirstName + ' ' + u.LastName) AS Name , SUM(o.TotalAmount) AS TotalSpent
FROM WebshopDB.dbo.Users u
JOIN WebshopDB.dbo.Orders o ON u.UserID = o.UserID
GROUP BY u.UserID, u.FirstName, u.LastName
ORDER BY TotalSpent DESC

-- Broj korisnika po državi koji su bar jednom kupili

SELECT co.Name AS Country, COUNT(DISTINCT u.UserID) AS NumberOfUsers
FROM WebshopDB.dbo.Users u
JOIN WebshopDB.dbo.Orders o ON u.UserID = o.UserID
JOIN WebshopDB.dbo.Address a ON o.AddressID = a.AddressID
JOIN WebshopDB.dbo.City ci ON a.CityID = ci.CityID
JOIN WebshopDB.dbo.Country co ON ci.CountryID = co.CountryID
GROUP BY co.Name
ORDER BY NumberOfUsers DESC

/* Eksport podataka za Pivot tabelu u Excelu radi slanja podataka dobavljaèu (prikazati kolone koje su bitne dobavljaèu: 
brend, kategorjia, podkategorija, grupa proizovda, šifra artikla, naziv artikla, prodaja u komadima, grad, država, 
vrsta plaæanja, iznos prodaje, broj narudžbi, prosjeèna kolièina po narudžbi)*/

SELECT b.Name AS Brand, c.Name AS Category, sc.Name AS Subcategory, pg.Name AS ProductGroup, p.ProductNumber AS ProductNumber, 
p.Name AS ProductName, SUM(oi.Quantity) AS TotalQuantitySold, ci.Name AS City, co.Name AS Country, pay.PaymentMethod AS PaymentMethod,
SUM(oi.Quantity * oi.UnitPrice) AS TotalSalesAmount, COUNT(oi.OrderID) AS NumberOfOrders,
AVG(oi.Quantity) AS AvgQuantity
FROM WebshopDB.dbo.Orders o
JOIN WebshopDB.dbo.OrderItem oi ON o.OrderID = oi.OrderID
JOIN WebshopDB.dbo.Product p ON oi.ProductID = p.ProductID
JOIN WebshopDB.dbo.Brand b ON p.BrandID = b.BrandID
JOIN WebshopDB.dbo.Category c ON p.CategoryID = c.CategoryID
JOIN WebshopDB.dbo.SubCategory sc ON p.SubCategoryID = sc.SubCategoryID
JOIN WebshopDB.dbo.ProductGroup pg ON p.ProductGroupID = pg.ProductGroupID
LEFT JOIN WebshopDB.dbo.Payment pay ON o.PaymentID = pay.PaymentID
LEFT JOIN WebshopDB.dbo.Address a ON o.AddressID = a.AddressID
LEFT JOIN WebshopDB.dbo.City ci ON a.CityID = ci.CityID
LEFT JOIN WebshopDB.dbo.Country co ON ci.CountryID = co.CountryID
GROUP BY b.Name, c.Name, sc.Name, pg.Name, p.ProductNumber, p.Name, ci.Name, co.Name, pay.PaymentMethod
ORDER BY b.Name, c.Name, sc.Name, p.Name;

/*
najprodavaniji artikl na narudžbama
koji je prvi sljedeæi artikl po prodaji koji se pojavljuje na narudžbama kada i najprodavaniji
da li su artikli iz istog brenda ili razlièitog (ovo možeš samo dodati kolone)
koji bi bio drugi artikl koji prati takoðer najprodavaniji
*/

SELECT p.Name AS Top1Product, b.Name AS Top1Brand, p2.Name AS Product, b2.Name AS Brand,
SUM(oi2.Quantity) AS TotalQuantityTogether, COUNT(DISTINCT oi2.OrderID) AS OrdersTogether
FROM WebshopDB.dbo.OrderItem oi
JOIN (
      SELECT TOP 1 ProductID
      FROM WebshopDB.dbo.OrderItem
      GROUP BY ProductID
      ORDER BY SUM(Quantity) DESC
     ) AS np ON oi.ProductID = np.ProductID
JOIN WebshopDB.dbo.Product p ON oi.ProductID = p.ProductID
JOIN WebshopDB.dbo.Brand b ON p.BrandID = b.BrandID
JOIN WebshopDB.dbo.OrderItem oi2 ON oi.OrderID = oi2.OrderID
JOIN WebshopDB.dbo.Product p2 ON oi2.ProductID = p2.ProductID
JOIN WebshopDB.dbo.Brand b2 ON p2.BrandID = b2.BrandID
WHERE p2.ProductID <> p.ProductID
GROUP BY p2.Name, b2.Name, p.Name, b.Name
ORDER BY TotalQuantityTogether DESC;

-- Najprodavaniji po novcu

SELECT p.Name AS Top1Product, b.Name AS Top1Brand, p2.Name AS Product, b2.Name AS Brand,
SUM(oi2.Quantity * p2.Price) AS TotalAmountTogether, SUM(oi2.Quantity) AS TotalQuantity,
COUNT(DISTINCT oi2.OrderID) AS OrdersTogether
FROM WebshopDB.dbo.OrderItem oi
JOIN (
      SELECT TOP 1 oii.ProductID
      FROM WebshopDB.dbo.OrderItem oii
	  JOIN WebshopDB.dbo.Product pi ON oii.ProductID = pi.ProductID
      GROUP BY oii.ProductID
      ORDER BY SUM(oii.Quantity * pi.Price) DESC
     ) AS np ON oi.ProductID = np.ProductID
JOIN WebshopDB.dbo.Product p ON oi.ProductID = p.ProductID
JOIN WebshopDB.dbo.Brand b ON p.BrandID = b.BrandID
JOIN WebshopDB.dbo.OrderItem oi2 ON oi.OrderID = oi2.OrderID
JOIN WebshopDB.dbo.Product p2 ON oi2.ProductID = p2.ProductID
JOIN WebshopDB.dbo.Brand b2 ON p2.BrandID = b2.BrandID
WHERE p2.ProductID <> p.ProductID AND oi2.Quantity > 1
GROUP BY p2.Name, b2.Name, p.Name, b.Name
ORDER BY TotalQuantity DESC;


SELECT *
FROM AdventureWorksLT2022.SalesLT.Product p
JOIN AdventureWorksLT2022.SalesLT.SalesOrderDetail sod ON p.ProductID = sod.ProductID and p.Color = 'Blue'

SELECT *
FROM AdventureWorksLT2022.SalesLT.Product p
JOIN AdventureWorksLT2022.SalesLT.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE p.Color = 'Blue'


SELECT p.ProductID, p.Name, p.Color, sod.SalesOrderID, sod.OrderQty
FROM AdventureWorksLT2022.SalesLT.Product p
LEFT JOIN AdventureWorksLT2022.SalesLT.SalesOrderDetail sod ON p.ProductID = sod.ProductID AND p.Color = 'Blue';

SELECT p.ProductID, p.Name, p.Color, sod.SalesOrderID, sod.OrderQty
FROM AdventureWorksLT2022.SalesLT.Product p
LEFT JOIN AdventureWorksLT2022.SalesLT.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE p.Color = 'Blue'


SELECT p.ProductID, p.Name, p.Color, sod.SalesOrderID, sod.OrderQty
FROM AdventureWorksLT2022.SalesLT.Product p
RIGHT JOIN AdventureWorksLT2022.SalesLT.SalesOrderDetail sod ON p.ProductID = sod.ProductID AND p.Color = 'Blue';

SELECT p.ProductID, p.Name, p.Color, sod.SalesOrderID, sod.OrderQty
FROM AdventureWorksLT2022.SalesLT.Product p
RIGHT JOIN AdventureWorksLT2022.SalesLT.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE p.Color = 'Blue'
