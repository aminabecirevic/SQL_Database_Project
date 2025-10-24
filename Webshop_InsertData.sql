USE WebshopDB;

INSERT INTO WebshopDB.dbo.Country (Name)
SELECT DISTINCT CountryRegion
FROM AdventureWorksLT2022.SalesLT.Address;

SELECT * FROM Country;

SELECT COUNT(CountryRegion) FROM AdventureWorksLT2022.SalesLT.Address;
SELECT COUNT(*) FROM WebshopDB.dbo.Country;


INSERT INTO WebshopDB.dbo.City (Name, CountryID)
SELECT DISTINCT a.City, c.CountryID
FROM AdventureWorksLT2022.SalesLT.Address a
JOIN WebshopDB.dbo.Country c ON a.CountryRegion COLLATE SQL_Latin1_General_CP1_CI_AS = c.Name COLLATE SQL_Latin1_General_CP1_CI_AS;

SELECT * FROM City;

SELECT COUNT(City) FROM AdventureWorksLT2022.SalesLT.Address;
SELECT COUNT(*) FROM WebshopDB.dbo.City;


INSERT INTO WebshopDB.dbo.Address (Street, ZipCode, CityID, AWAddressID)
SELECT a.AddressLine1, a.PostalCode, c.CityID, a.AddressID
FROM AdventureWorksLT2022.SalesLT.Address a 
JOIN WebshopDB.dbo.Country co ON a.CountryRegion COLLATE SQL_Latin1_General_CP1_CI_AS = co.Name COLLATE SQL_Latin1_General_CP1_CI_AS
JOIN WebshopDB.dbo.City c ON a.City COLLATE Croatian_CI_AS = c.Name
WHERE a.AddressLine1 IS NOT NULL;

SELECT * FROM Address;

SELECT COUNT(*) FROM AdventureWorksLT2022.SalesLT.Address;
SELECT COUNT(*) FROM WebshopDB.dbo.Address;

SELECT SUM(AddressID)
FROM AdventureWorksLT2022.SalesLT.Address;
SELECT SUM(AWAddressID)
FROM WebshopDB.dbo.Address;


INSERT INTO WebshopDB.dbo.Users (FirstName, LastName, Email, PasswordHash, Phone, CreatedAt, AddressID, AWCustomerID)
SELECT FirstName, LastName, EmailAddress, PasswordHash, Phone, GETDATE(), wa.AddressID, c.CustomerID
FROM AdventureWorksLT2022.SalesLT.Customer c
LEFT JOIN WebshopDB.dbo.Address wa ON wa.AWAddressID = c.CustomerID

SELECT * FROM Users;

SELECT COUNT(*) FROM AdventureWorksLT2022.SalesLT.Customer;
SELECT COUNT(*) FROM WebshopDB.dbo.Users;

SELECT SUM(CustomerID)
FROM AdventureWorksLT2022.SalesLT.Customer;
SELECT SUM(AWCustomerID)
FROM WebshopDB.dbo.Users;


INSERT INTO WebshopDB.dbo.Brand (Name, AWProductModelID)
SELECT Name, ProductModelID
FROM AdventureWorksLT2022.SalesLT.ProductModel;

SELECT * FROM Brand;

SELECT COUNT(*) FROM AdventureWorksLT2022.SalesLT.ProductModel;
SELECT COUNT(*) FROM WebshopDB.dbo.Brand;

SELECT SUM(ProductModelID) 
FROM AdventureWorksLT2022.SalesLT.ProductModel;
SELECT SUM(AWProductModelID) 
FROM WebshopDB.dbo.Brand;


INSERT INTO WebshopDB.dbo.Category (Name, BrandID, AWProductCategoryID)
SELECT DISTINCT pc.Name, b.BrandID, pc.ProductCategoryID
FROM AdventureWorksLT2022.SalesLT.ProductCategory pc
JOIN WebshopDB.dbo.Brand b ON pc.ProductCategoryID = b.AWProductModelID
WHERE pc.ParentProductCategoryID IS NULL;

SELECT * FROM Category;

SELECT COUNT(*) FROM AdventureWorksLT2022.SalesLT.ProductCategory
WHERE ParentProductCategoryID IS NULL;
SELECT COUNT(*) FROM WebshopDB.dbo.Category;

SELECT SUM(ProductCategoryID)
FROM AdventureWorksLT2022.SalesLT.ProductCategory
WHERE ParentProductCategoryID IS NULL;
SELECT SUM(AWProductCategoryID)
FROM WebshopDB.dbo.Category;


INSERT INTO WebshopDB.dbo.SubCategory (Name, CategoryID, AWProductCategoryID)
SELECT pc.Name, c.CategoryID, pc.ProductCategoryID
FROM AdventureWorksLT2022.SalesLT.ProductCategory pc
JOIN WebshopDB.dbo.Category c ON pc.ParentProductCategoryID = c.AWProductCategoryID;

SELECT * FROM SubCategory;

SELECT COUNT(ParentProductCategoryID) FROM AdventureWorksLT2022.SalesLT.ProductCategory;
SELECT COUNT(*) FROM WebshopDB.dbo.SubCategory;

SELECT SUM(ProductCategoryID)
FROM AdventureWorksLT2022.SalesLT.ProductCategory
WHERE ParentProductCategoryID IS NOT NULL;
SELECT SUM(AWProductCategoryID) 
FROM WebshopDB.dbo.SubCategory;


INSERT INTO WebshopDB.dbo.ProductGroup (Name, SubCategoryID)
VALUES
('Mountain-100', 1),
('Mountain-200', 1),
('Mountain-300', 1),
('Mountain-400-W', 1),
('Mountain-500', 1),

('Road-150', 2),
('Road-250', 2),
('Road-350-W', 2),
('Road-450', 2),
('Road-550-W', 2),
('Road-650', 2),
('Road-750', 2),

('Touring-1000', 3),
('Touring-2000', 3),
('Touring-3000', 3),

('HL Mountain Handlebars', 4),
('HL Road Handlebars', 4),
('HL Touring Handlebars', 4),
('LL Mountain Handlebars', 4),
('LL Road Handlebars', 4),
('LL Touring Handlebars', 4),
('ML Mountain Handlebars', 4),
('ML Road Handlebars', 4),

('HL Bottom Bracket', 5),
('LL Bottom Bracket', 5),
('ML Bottom Bracket', 5),

('Front Brakes', 6),
('Rear Brakes', 6),

('Chain', 7),

('HL Crankset', 8),
('LL Crankset', 8),
('ML Crankset', 8),

('Front Derailleur', 9),
('Rear Derailleur', 9),

('HL Fork', 10),
('LL Fork', 10),
('ML Fork', 10),

('HL Headset', 11),
('LL Headset', 11),
('ML Headset', 11),

('HL Mountain Frame', 12),
('LL Mountain Frame', 12),
('ML Mountain Frame', 12),

('HL Mountain Pedal', 13),
('HL Road Pedal', 13),
('LL Mountain Pedal', 13),
('LL Road Pedal', 13),
('ML Mountain Pedal', 13),
('ML Road Pedal', 13),
('Touring Pedal', 13),

('HL Road Frame', 14),
('LL Road Frame', 14),
('ML Road Frame', 14),

('HL Mountain Seat/Saddle', 15),
('HL Road Seat/Saddle', 15),
('HL Touring Seat/Saddle', 15),
('LL Mountain Seat/Saddle', 15),
('LL Road Seat/Saddle', 15),
('LL Touring Seat/Saddle', 15),
('ML Mountain Seat/Saddle', 15),
('ML Road Seat/Saddle', 15),
('ML Touring Seat/Saddle', 15),

('HL Touring Frame', 16),
('LL Touring Frame', 16),

('HL Mountain Front Wheel', 17),
('HL Mountain Rear Wheel', 17),
('HL Road Front Wheel', 17),
('HL Road Rear Wheel', 17),
('LL Mountain Front Wheel', 17),
('LL Mountain Rear Wheel', 17),
('LL Road Front Wheel', 17),
('LL Road Rear Wheel', 17),
('ML Mountain Front Wheel', 17),
('ML Mountain Rear Wheel', 17),
('ML Road Front Wheel', 17),
('ML Road Rear Wheel', 17),
('Touring Front Wheel', 17),
('Touring Rear Wheel', 21),

('Men''s Bib-Shorts', 18),

('AWC Logo Cap', 19),

('Full-Finger Gloves', 20),
('Half-Finger Gloves', 20),

('Long-Sleeve Logo Jersey', 21),
('Short-Sleeve Classic Jersey', 21),

('Men''s Sports Shorts', 22),
('Women''s Mountain Shorts', 22),

('Mountain Bike Socks', 23),
('Racing Socks', 23),

('Women''s Tights', 24),

('Classic Vest', 25),

('Hitch Rack - 4-Bike', 26),

('All-Purpose Bike Stand', 27),

('Mountain Bottle Cage', 28),
('Road Bottle Cage', 28),
('Water Bottle - 30 oz.', 28),

('Bike Wash - Dissolver', 29),

('Fender Set - Mountain', 30),

('Sport-100 Helmet', 31),

('Hydration Pack - 70 oz.', 32),

('Headlights - Dual-Beam', 33),
('Headlights - Weatherproof', 33),
('Taillights - Battery-Powered', 33),

('Cable Lock', 34),

('Touring-Panniers, Large', 35),

('Minipump', 36),
('Mountain Pump', 36),

('HL Mountain Tire', 37),
('HL Road Tire', 37),
('LL Mountain Tire', 37),
('LL Road Tire', 37),
('ML Mountain Tire', 37),
('ML Road Tire', 37),
('Mountain Tire Tube', 37),
('Patch Kit/8 Patches', 37),
('Road Tire Tube', 37),
('Touring Tire', 37);

SELECT * FROM ProductGroup;

INSERT INTO WebshopDB.dbo.Product (Name, ProductNumber, Price, CreatedAt, BrandID, CategoryID, SubCategoryID,ProductGroupID, AWProductID, AWProductCategoryID, AWProductModelID)
SELECT p.Name, p.ProductNumber, p.ListPrice, GETDATE(), b.BrandID, c.CategoryID, sc.SubCategoryID, pg.ProductGroupID, p.ProductID, p.ProductCategoryID, p.ProductModelID
FROM AdventureWorksLT2022.SalesLT.Product p
LEFT JOIN WebshopDB.dbo.Brand b ON b.AWProductModelID = p.ProductModelID
LEFT JOIN AdventureWorksLT2022.SalesLT.ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID
LEFT JOIN WebshopDB.dbo.Category c ON c.AWProductCategoryID = pc.ParentProductCategoryID 
LEFT JOIN WebshopDB.dbo.SubCategory sc ON sc.AWProductCategoryID = p.ProductCategoryID
LEFT JOIN WebshopDB.dbo.ProductGroup pg ON pg.SubCategoryID = sc.SubCategoryID AND p.Name LIKE pg.Name COLLATE SQL_Latin1_General_CP1_CI_AS + '%';

UPDATE Product
SET Stock = FLOOR(RAND() * ProductID * AWProductID)
FROM Product

SELECT * FROM Product;

SELECT COUNT(*) FROM AdventureWorksLT2022.SalesLT.Product;
SELECT COUNT(*) FROM WebshopDB.dbo.Product;

SELECT SUM(ProductID) 
FROM AdventureWorksLT2022.SalesLT.Product;
SELECT SUM(AWProductID)
FROM WebshopDB.dbo.Product;


INSERT INTO WebshopDB.dbo.Orders (OrderDate, Status, TotalAmount, FinalAmount, UserID, AddressID, AWSalesOrderID, AWCustomerID)
SELECT soh.OrderDate, soh.Status, soh.TotalDue, soh.TotalDue * 1.17 AS FinalAmount, u.UserID, a.AddressID, soh.SalesOrderID, u.AWCustomerID
FROM AdventureWorksLT2022.SalesLT.SalesOrderHeader soh
JOIN WebshopDB.dbo.Users u ON u.AWCustomerID = soh.CustomerID
JOIN WebshopDB.dbo.Address a ON a.AWAddressID = soh.ShipToAddressID;

SELECT * FROM Orders;

INSERT INTO Payment VALUES ('Credit Card', 'Completed', '2025-06-01');
INSERT INTO Payment VALUES ('PayPal', 'Pending', NULL);
INSERT INTO Payment VALUES ('Credit Card', 'Completed', '2025-06-06');
INSERT INTO Payment VALUES ('Cash', 'Cancelled', NULL);
INSERT INTO Payment VALUES ('Credit Card', 'Completed', '2025-07-07');
INSERT INTO Payment VALUES ('PayPal', 'Completed', '2025-01-25');
INSERT INTO Payment VALUES ('Credit Card', 'Pending', NULL);
INSERT INTO Payment VALUES ('Cash', 'Completed', '2025-05-30');
INSERT INTO Payment VALUES ('Credit Card', 'Completed', '2025-02-02');
INSERT INTO Payment VALUES ('PayPal', 'Completed', '2025-06-06');
INSERT INTO Payment VALUES ('Credit Card', 'Cancelled', NULL);
INSERT INTO Payment VALUES ('Cash', 'Completed', '2025-03-04');
INSERT INTO Payment VALUES ('Credit Card', 'Completed', '2025-02-01');
INSERT INTO Payment VALUES ('PayPal', 'Pending', NULL);
INSERT INTO Payment VALUES ('Credit Card', 'Completed', '2025-08-05');
INSERT INTO Payment VALUES ('Cash', 'Completed', '2025-04-19');
INSERT INTO Payment VALUES ('Credit Card', 'Completed', '2025-05-15');
INSERT INTO Payment VALUES ('PayPal', 'Completed', '2025-06-26');
INSERT INTO Payment VALUES ('Credit Card', 'Cancelled', NULL);
INSERT INTO Payment VALUES ('Cash', 'Completed', '2024-08-18');
INSERT INTO Payment VALUES ('Credit Card', 'Pending', NULL);
INSERT INTO Payment VALUES ('PayPal', 'Completed', '2025-06-17');
INSERT INTO Payment VALUES ('Credit Card', 'Completed', '2025-07-01');
INSERT INTO Payment VALUES ('Cash', 'Completed', '2025-03-10');
INSERT INTO Payment VALUES ('Credit Card', 'Completed', '2025-04-28');
INSERT INTO Payment VALUES ('PayPal', 'Cancelled', NULL);
INSERT INTO Payment VALUES ('PayPal', 'Completed', '2025-07-04');
INSERT INTO Payment VALUES ('Cash', 'Completed', '2025-06-09');
INSERT INTO Payment VALUES ('Credit Card', 'Completed', '2025-04-25');
INSERT INTO Payment VALUES ('PayPal', 'Completed', '2025-05-01');
INSERT INTO Payment VALUES ('Credit Card', 'Pending', NULL);
INSERT INTO Payment VALUES ('Cash', 'Completed', '2025-05-05');

SELECT * FROM Payment;

UPDATE o
SET o.PaymentID = p.PaymentID
FROM WebshopDB.dbo.Orders o
JOIN WebshopDB.dbo.Payment p ON o.OrderID = p.PaymentID

SELECT * FROM Orders;


SELECT COUNT(*) FROM AdventureWorksLT2022.SalesLT.SalesOrderHeader;
SELECT COUNT(*) FROM WebshopDB.dbo.Orders;

SELECT SUM(SalesOrderID) 
FROM AdventureWorksLT2022.SalesLT.SalesOrderHeader;
SELECT SUM(AWSalesOrderID)
FROM WebshopDB.dbo.Orders;


INSERT INTO WebshopDB.dbo.OrderItem (Quantity, UnitPrice, OrderID, ProductID, AWSalesOrderDetailID, AWSalesOrderID, AWProductID)
SELECT sod.OrderQty, sod.UnitPrice, o.OrderID, p.ProductID, sod.SalesOrderDetailID, sod.SalesOrderID, sod.ProductID
FROM AdventureWorksLT2022.SalesLT.SalesOrderDetail sod
JOIN WebshopDB.dbo.Orders o ON o.AWSalesOrderID = sod.SalesOrderID
JOIN WebshopDB.dbo.Product p ON p.AWProductID = sod.ProductID;

SELECT * FROM OrderItem;

SELECT COUNT(*) FROM AdventureWorksLT2022.SalesLT.SalesOrderDetail;
SELECT COUNT(*) FROM WebshopDB.dbo.OrderItem;

SELECT SUM(SalesOrderDetailID) 
FROM AdventureWorksLT2022.SalesLT.SalesOrderDetail;
SELECT SUM(AWSalesOrderDetailID) 
FROM WebshopDB.dbo.OrderItem;