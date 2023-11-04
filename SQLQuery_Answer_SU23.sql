-- Practical Exam DBI202 SUMMER2023

-- 1. Write commands to create all the tables and insert appropriate data into the tables. There 
-- must be primary key, foreign key according to the diagram. (2 point)
CREATE TABLE Customer (
CustomerID VARCHAR(10) PRIMARY KEY NOT NULL,
LastName NVARCHAR(30),
FirstName NVARCHAR(30),
Phone VARCHAR(15),
Address NVARCHAR(50),
City NVARCHAR(30),
Country NVARCHAR(30),
)

CREATE TABLE Orders(
OrderID VARCHAR(10) PRIMARY KEY NOT NULL,
CustomerID VARCHAR(10) FOREIGN KEY REFERENCES Customer(CustomerID) NOT NULL,
OrderDate DATETIME,
RequiredDate DATETIME,
ShippedDate DATETIME,
Status VARCHAR(30),
Comment NVARCHAR(50),
)

CREATE TABLE Product(
ProductCode VARCHAR(10) PRIMARY KEY,
Name NVARCHAR(30),
Scale int,
Vendor NVARCHAR(30),
Description VARCHAR(30),
BuyPrice int,
Inventory int,
)

CREATE TABLE OrdersDetail(
OrderID VARCHAR(10) FOREIGN KEY REFERENCES Orders(OrderID),
ProductCode VARCHAR(10) FOREIGN KEY REFERENCES Product(ProductCode),
PRIMARY KEY (OrderID, ProductCode),
Qty int,
Price int,
)



--Question 2: 
--Create constraint for table OrderDetail whose Qty is always greater than 0 (0.5 point)
--Create constraint to check input data 
ALTER TABLE [dbo].[OrdersDetail] 
ADD CONSTRAINT check_Qty CHECK ([Qty]>0)

--Check insert 
INSERT INTO [dbo].[OrdersDetail] (OrderID, ProductCode, Qty, Price ) VALUES (001,234,0,2000);

--Show constraint of table
EXEC sp_helpconstraint 'OrdersDetail';

--Question 3:
----------------------------------------------------------------------------------------------
-- 3.a. Display customers in Da Nang, including IDcustomer, Firstname, Lastname, Phone, Address

--Insert Danang Customer
INSERT INTO [dbo].[Customer] (CustomerID, LastName, FirstName, Phone, Address, City, Country)
VALUES ('001',N'Hung',N'Pham Trong','0947811370',N'Che Lan Vien',N'Da Nang',N'Viet Nam');

INSERT INTO [dbo].[Customer] (CustomerID, LastName, FirstName, Phone, Address, City, Country)
VALUES ('002',N'My',N'Nguyen Thi Ha','0947811370',N'Tran Van Du',N'Ho Chi Minh',N'Viet Nam');

--Display customer information who have city = 'Đà Nẵng'
SELECT *
FROM [dbo].[Customer]
WHERE city in ('Da Nang')

------------------------------------------------------------------------------------------------
-- 3.b Calculate the amount of each order with Total = Quantity * Price,
--Insert data to [dbo].[Product]
INSERT INTO [dbo].[Product]
VALUES ('282','Bao cao su', 20, 'Hoang Cong Minh', 'Vanila', 200000, 20);
INSERT INTO [dbo].[Product]
VALUES ('143','Macbook', 20, 'Nguyen Dinh Hoang Hai', 'MacPro', 6000000, 2);
INSERT INTO [dbo].[Product]
VALUES ('143','Macbook', 20, 'Nguyen Dinh Hoang Hai', 'MacPro', 6000000, 2);

--Insert data to [dbo].[Orders]
INSERT INTO [dbo].[Orders]
VALUES ('05','001','1996-07-04 00:00:00.000','1996-08-01 00:00:00.000','1996-07-16 00:00:00.000', 'Da giao', Null);
INSERT INTO [dbo].[Orders]
VALUES ('06','002','1996-07-04 00:00:00.000','1996-08-01 00:00:00.000','1998-07-16 00:00:00.000', 'Chua giao', Null);
INSERT INTO [dbo].[Orders]
VALUES ('08','001','2000-07-04 00:00:00.000','2000-08-01 00:00:00.000','2000-07-16 00:00:00.000', 'Da giao', Null);
INSERT INTO [dbo].[Orders]
VALUES ('10','001','2001-09-04 00:00:00.000','2001-10-01 00:00:00.000','2001-11-16 00:00:00.000', 'Chua giao', Null);

--Insert data to [dbo].[OrdersDetail]
INSERT INTO [dbo].[OrdersDetail]
VALUES ('05','282',100,2000);
INSERT INTO [dbo].[OrdersDetail]
VALUES ('06','143',1,6000000);
INSERT INTO [dbo].[OrdersDetail]
VALUES ('08','143',2,5700000);
INSERT INTO [dbo].[OrdersDetail]
VALUES ('10','143',500,870000);

UPDATE [dbo].[OrdersDetail] SET [Qty] = 120
WHERE [OrderID] = 08;
UPDATE [dbo].[OrdersDetail] SET [Qty] = 10
WHERE [OrderID] = 10;

--Display Total
SELECT [OrderID],p.[ProductCode],p.[Name], SUM([Qty] * [Price]) AS [Total]
FROM [dbo].[OrdersDetail] od
inner join [dbo].[Product] p on od.ProductCode = p.ProductCode
GROUP BY [OrderID],p.[ProductCode],p.[Name]
GO;

------------------------------------------------------------------------------------------------
-- 3.c. Create a view to store the best-selling items in June. If the number is the same, show all
CREATE VIEW TheBestSelling AS
SELECT od.[ProductCode],SUM([Qty]) AS [SellingAmount]
FROM [dbo].[Orders] o
inner join [dbo].[OrdersDetail] od on o.OrderID = od.OrderID
inner join [dbo].[Product] p on od.ProductCode = p.ProductCode
WHERE MONTH(OrderDate) = 7
GROUP BY od.[ProductCode]

SELECT top 1 *
FROM TheBestSelling
ORDER BY SellingAmount DESC

-- 3.d Display details of each order with a total amount > 500 including the following information: Order1.orderID, Customerid,RequiredDate,ShippedDate, amount
SELECT DISTINCT o.[OrderID],[CustomerID],[RequiredDate],[ShippedDate], SUM(od.[Qty] * od.[Price]) AS [TotalAmount]
FROM [dbo].[Orders] o
inner join [dbo].[OrdersDetail] od on o.OrderID = od.OrderID
GROUP BY o.[OrderID],[CustomerID],[RequiredDate],[ShippedDate]
HAVING SUM(od.[Qty] * od.[Price]) < 500

GO;

-- 4.Write a function that calculates the total amount of an order with the invoice code as the parameter (1 point)
CREATE FUNCTION CalculateTotal (@madonhang varchar(10))
RETURNS INT
AS
BEGIN
	DECLARE @TotalAmount INT
	SELECT @TotalAmount = SUM([Qty]*[Price]) 
	FROM [dbo].[OrdersDetail] 
	WHERE @madonhang = [OrderID]
	RETURN @TotalAmount
END

--Execute
SELECT dbo.CalculateTotal([OrderID]) FROM [dbo].[OrdersDetail]




-- Thêm dữ liệu vào bảng Customer
INSERT INTO Customer (CustomerID, LastName, FirstName, Phone, Address, City, Country)
VALUES ('C001', 'Smith', 'John', '123456789', '123 Main St', 'Anytown', 'USA'),
       ('C002', 'Johnson', 'Alice', '987654321', '456 Oak St', 'Othertown', 'USA');

-- Thêm dữ liệu vào bảng Orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate, RequiredDate, ShippedDate, Status, Comment)
VALUES ('O001', 'C001', '2023-07-15', '2023-10-20', '2023-10-18', 'Shipped', 'Some comment'),
       ('O002', 'C002', '2023-10-18', '2023-10-25', '2023-10-23', 'Shipped', 'Another comment');

-- Thêm dữ liệu vào bảng Product
INSERT INTO Product (ProductCode, Name, Scale, Vendor, Description, BuyPrice, Inventory)
VALUES ('P001', 'Product A', 1, 'Vendor X', 'Description A', 50, 100),
       ('P002', 'Product B', 2, 'Vendor Y', 'Description B', 40, 150);

-- Thêm dữ liệu vào bảng OrdersDetail
INSERT INTO OrdersDetail (OrderID, ProductCode, Qty, Price)
VALUES ('O001', 'P001', 5, 50),
       ('O001', 'P002', 3, 40),
       ('O002', 'P001', 2, 50);