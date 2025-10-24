CREATE DATABASE WebshopDB;
USE WebshopDB;

DELETE FROM Users;
DROP TABLE Users;

DROP TABLE WebshopDB.dbo.OrderItem;
DROP TABLE WebshopDB.dbo.Orders;
DROP TABLE WebshopDB.dbo.Address;
DROP TABLE WebshopDB.dbo.City;
DROP TABLE WebshopDB.dbo.Country;
DROP TABLE WebshopDB.dbo.Users;
DROP TABLE WebshopDB.dbo.ProductGroup;
DROP TABLE WebshopDB.dbo.SubCategory;
DROP TABLE WebshopDB.dbo.Payment;
DROP TABLE WebshopDB.dbo.Category;
DROP TABLE WebshopDB.dbo.Brand;
DROP TABLE WebshopDB.dbo.Product;

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(50) NULL,
    PasswordHash VARCHAR(128) NOT NULL,
    Phone NVARCHAR(25),
    CreatedAt DATETIME DEFAULT GETDATE(),
    Role NVARCHAR(20),
	AddressID INT,
	AWCustomerID INT
);

CREATE TABLE Country (
    CountryID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) NOT NULL
);

CREATE TABLE City (
    CityID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(30) NOT NULL,
    CountryID INT NULL--,
    --FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
);

CREATE TABLE Address (
    AddressID INT PRIMARY KEY IDENTITY,
    Street NVARCHAR(60) NOT NULL,
    ZipCode NVARCHAR(15) NOT NULL,
	AWAddressID INT,
    CityID INT NULL--,
    --FOREIGN KEY (CityID) REFERENCES City(CityID)
);
ALTER TABLE Address
ADD AWAddressID INT;

CREATE TABLE Brand (
    BrandID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) NOT NULL,
	AWProductModelID INT
);
ALTER TABLE Brand
ADD AWProductModelID INT;

CREATE TABLE Category (
    CategoryID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) NOT NULL,
    BrandID INT,
	AWProductCategoryID INT
    --FOREIGN KEY (BrandID) REFERENCES Brand(BrandID)
);
ALTER TABLE Category
ADD AWProductCategoryID INT;

CREATE TABLE SubCategory (
    SubCategoryID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) NOT NULL,
    CategoryID INT NULL,
	AWProductCategoryID INT--,
    --FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);
ALTER TABLE SubCategory
ADD AWProductCategoryID INT;

CREATE TABLE ProductGroup (
    ProductGroupID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) NOT NULL,
    SubCategoryID INT NULL--,
    --FOREIGN KEY (SubCategoryID) REFERENCES SubCategory(SubCategoryID)
);

CREATE TABLE Product (
    ProductID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) NOT NULL,
	ProductNumber NVARCHAR(25),
    Description NVARCHAR(255),
    Barcode NVARCHAR(50),
    Price DECIMAL(10,2) NOT NULL,
    DiscountPrice DECIMAL(10,2),
    Stock INT,
    IsAvailable BIT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    ImageURL NVARCHAR(255),
    CategoryID INT NULL,
    SubCategoryID INT NULL,
    ProductGroupID INT NULL,
    BrandID INT NULL,
	AWProductID INT,
	AWProductCategoryID INT,
	AWProductModelID INT--,
    /*FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
    FOREIGN KEY (SubCategoryID) REFERENCES SubCategory(SubCategoryID),
    FOREIGN KEY (ProductGroupID) REFERENCES ProductGroup(ProductGroupID),
    FOREIGN KEY (BrandID) REFERENCES Brand(BrandID)*/
);
ALTER TABLE Product
ADD AWProductID INT, AWProductCategoryID INT, AWProductModelID INT;

ALTER TABLE Product
ADD ProductNumber NVARCHAR(25);

CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY IDENTITY,
    PaymentMethod NVARCHAR(50) NOT NULL,
    PaymentStatus NVARCHAR(20),
    PaymentDate DATETIME,
);
--ALTER TABLE Payment ADD OrderID INT NULL;

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY,
    OrderDate DATETIME DEFAULT GETDATE() NOT NULL,
    Status NVARCHAR(20) NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    UserID INT NULL,
    AddressID INT NULL,
    PaymentID INT,
	AWSalesOrderID INT,
	AWCustomerID INT,/*,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID),
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID)*/
);
ALTER TABLE Orders
ADD AWSalesOrderID INT, AWCustomerID INT;

ALTER TABLE Orders
ADD FinalAmount DECIMAL(10, 2) NULL;
UPDATE Orders
SET FinalAmount = TotalAmount * 1.17;

CREATE TABLE OrderItem (
    OrderItemID INT PRIMARY KEY IDENTITY,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    OrderID INT NULL,
    ProductID INT NULL,
	AWSalesOrderDetailID INT,
	AWSalesOrderID INT,
	AWProductID INT/*,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)*/
);
ALTER TABLE OrderItem
ADD AWSalesOrderDetailID INT, AWSalesOrderID INT, AWProductID INT;