CREATE DATABASE IF NOT EXISTS superstore_db;
USE superstore_db;

CREATE TABLE SuperstoreRaw (
    RowID INT,
    OrderID VARCHAR(20),
    OrderDate VARCHAR(15),
    ShipDate VARCHAR(15),
    ShipMode VARCHAR(30),
    CustomerID VARCHAR(20),
    CustomerName VARCHAR(100),
    Segment VARCHAR(30),
    Country VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    PostalCode VARCHAR(10),
    Region VARCHAR(20),
    ProductID VARCHAR(30),
    Category VARCHAR(30),
    SubCategory VARCHAR(30),
    ProductName VARCHAR(255),
    Sales DECIMAL(10,4),
    Quantity INT,
    Discount DECIMAL(5,2),
    Profit DECIMAL(10,4)
);

-- import csv data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Sample - Superstore.csv'
INTO TABLE SuperstoreRaw
CHARACTER SET latin1
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM SuperstoreRaw;

ALTER TABLE SuperstoreRaw ADD COLUMN OrderDate_Fixed DATE;
ALTER TABLE SuperstoreRaw ADD COLUMN ShipDate_Fixed DATE;

set sql_safe_updates= 0;

SELECT * FROM superstore_db.superstoreraw;

-- fix order date & ship date 
UPDATE SuperstoreRaw
SET OrderDate_Fixed = 
    CASE 
        WHEN OrderDate LIKE '%/%' THEN STR_TO_DATE(OrderDate, '%m/%d/%Y')
        WHEN OrderDate LIKE '%-%' THEN STR_TO_DATE(OrderDate, '%m-%d-%y')
        ELSE NULL
    END,
    ShipDate_Fixed = 
    CASE 
        WHEN ShipDate LIKE '%/%' THEN STR_TO_DATE(ShipDate, '%m/%d/%Y')
        WHEN ShipDate LIKE '%-%' THEN STR_TO_DATE(ShipDate, '%m-%d-%y')
        ELSE NULL
    END;

SELECT COUNT(*) FROM SuperstoreRaw WHERE OrderDate_Fixed IS NULL;
SELECT COUNT(*) FROM SuperstoreRaw WHERE ShipDate_Fixed IS NULL;

SELECT OrderDate, OrderDate_Fixed, ShipDate, ShipDate_Fixed 
FROM SuperstoreRaw 
WHERE OrderDate LIKE '%/%' OR ShipDate LIKE '%/%';

SELECT MIN(OrderDate_Fixed), MAX(OrderDate_Fixed) FROM SuperstoreRaw;
SELECT MIN(ShipDate_Fixed), MAX(ShipDate_Fixed) FROM SuperstoreRaw;

SELECT * FROM superstore_db.superstoreraw;

SELECT OrderDate, OrderDate_Fixed, ShipDate, ShipDate_Fixed FROM SuperstoreRaw LIMIT 10;

ALTER TABLE SuperstoreRaw DROP COLUMN OrderDate;
ALTER TABLE SuperstoreRaw DROP COLUMN ShipDate;
ALTER TABLE SuperstoreRaw RENAME COLUMN OrderDate_Fixed TO OrderDate;
ALTER TABLE SuperstoreRaw RENAME COLUMN ShipDate_Fixed TO ShipDate;

-- dimention table
create table dim_customer as select distinct customerid, customername, segment from superstoreraw;
create table dim_product as select distinct productid, productname, category, subcategory from superstoreraw;
create table dim_location as select distinct city, state, postalcode, region from superstoreraw;

-- fact table
create table fact_orders as select rowid, orderid, orderdate, shipdate, shipmode, customerid, 
productid, postalcode, sales, quantity, discount, profit  from superstoreraw;

DESCRIBE SuperstoreRaw;

select count(*) from dim_customer;
select count(*) from dim_product;
select count(*) from dim_location;
select count(*) from fact_orders;

-- joins
select  f.orderid, f.orderdate, c.customername, c.segment, p.category, p.subcategory, l.region, l.state, f.sales, f.profit from fact_orders f
join dim_customer c on f.customerid=c.customerid
join dim_product p on f.productid=p.productid
join dim_location l on f.postalcode= l.postalcode
limit 10;

-- region wise sales & profit
select l.region, sum(f.sales) as total_sales, sum(f.profit) as total_profit from fact_orders f
join dim_location l on f.postalcode=l.postalcode
group by l.region
order by total_sales desc;

-- category wise profit margin
select p.category, sum(f.sales) as sales, sum(f.profit) as profit, round(sum(f.profit)/sum(f.sales)*100,2) as profit_margin  from fact_orders f
join dim_product p on f.productid=p.productid
group by p.category;

-- top 10 customer by sales
select c.customername, sum(f.sales) as total_sales from Fact_Orders f
join dim_customer c on f.customerid=c.customerid
group by c.customername
order by total_sales desc
limit 10;

-- monthly sales trend
select year(f.orderdate) as yr, month(f.orderdate) as mon, sum(f.sales) as sales from fact_orders f
group by year(f.orderdate), month(f.orderdate)
order by yr, mon;

-- ----------------------------------------------------------------------------------------------------------------
-- view
create view vw_sales_summary as 
select f.orderid, f.orderdate, f.shipdate, f.shipmode, c.customername, c.segment, p.category, p.subcategory, p.productname, l.region, l.state, l.city,
f.sales, f.quantity, f.discount, f.profit, round(f.profit/nullif(f.sales,0)*100,2) as profit_margin from fact_orders f
join dim_customer c on f.customerid=c.customerid
join dim_product p on f.productid=p.productid
join dim_location l on f.postalcode= l.postalcode;

select * from vw_sales_summary;
select count(*) from vw_sales_summary;

select customerid, count(*) from dim_customer group by customerid having count(*)>1;
select productid, count(*) from dim_product group by productid having count(*)>1;
select postalcode, count(*) from dim_location group by postalcode having count(*)>1;
-- ------------------------------------------------------------------------------------------------------------------


DROP TABLE Dim_Product;

CREATE TABLE Dim_Product AS
SELECT ProductID, MAX(ProductName) AS ProductName, MAX(Category) AS Category, MAX(SubCategory) AS SubCategory FROM SuperstoreRaw
GROUP BY ProductID;

DROP TABLE Dim_Location;

CREATE TABLE Dim_Location AS
SELECT PostalCode, MAX(City) AS City, MAX(State) AS State, MAX(Region) AS Region FROM SuperstoreRaw
GROUP BY PostalCode;

DROP VIEW vw_Sales_Summary;

CREATE VIEW vw_Sales_Summary AS
SELECT f.OrderID, f.OrderDate, f.ShipDate, f.ShipMode, c.CustomerName, c.Segment, p.Category, p.SubCategory, p.ProductName,
l.Region, l.State, l.City, f.Sales, f.Quantity, f.Discount, f.Profit, ROUND(f.Profit/NULLIF(f.Sales,0)*100, 2) AS Profit_Margin_Pct
FROM Fact_Orders f
JOIN Dim_Customer c ON f.CustomerID = c.CustomerID
JOIN Dim_Product p ON f.ProductID = p.ProductID
JOIN Dim_Location l ON f.PostalCode = l.PostalCode;

SELECT COUNT(*) FROM vw_Sales_Summary;




