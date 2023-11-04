-- Question 2
-- See all products of the category 'Cyclocross Bicycles'
SELECT *
FROM [dbo].[products]
WHERE [category_name] = N'Cyclocross Bicycles'


-- Question 3
-- select product_name, model_year, list_price, brand_name
-- all brand = 'Trek' and model_year = 2018 , list_price > 3000
SELECT [product_name], [model_year], [list_price], [brand_name]
FROM [dbo].[products]
WHERE [brand_name] in ('Trek') AND [model_year] = 2018 AND [list_price] > 3000
ORDER BY [list_price] ASC

-- Question 4
SELECT [order_id], [order_date], CUS.[customer_id], [first_name], [last_name], [store_name]
FROM [dbo].[orders] O 
	inner join [dbo].[customers] CUS on O.customer_id = CUS.customer_id
	inner join [dbo].[stores] S on O.store_id = S.store_id
WHERE MONTH([order_date]) = 1 AND YEAR([order_date]) = 2016 AND [store_name] in ('Santa Cruz Bikes')


-- Question 5
SELECT S.[store_id], S.[store_name], COUNT(*) AS NumberOfOrderIn2018
FROM [dbo].[stores] S 
	inner join [dbo].[orders] O on S.store_id = O.store_id
WHERE YEAR([order_date]) = 2018
GROUP BY S.[store_id], S.[store_name]
ORDER BY COUNT(*) DESC


-- Question 6
SELECT top 1 with ties P.[product_id], [product_name], [model_year], SUM([quantity]) AS [TotalStockQuantity]
FROM [dbo].[products] P 
	inner join [dbo].[stocks] ST on P.product_id = ST.product_id
GROUP BY P.[product_id], [product_name], [model_year]
ORDER BY SUM([quantity]) DESC

-- Question 7



SELECT store_name, staff_id, first_name, last_name, NumberOfOrders, OrderRank
FROM (
    SELECT store_name, staff_id, first_name, last_name, NumberOfOrders, 
           RANK() OVER (PARTITION BY store_id ORDER BY NumberOfOrders DESC) AS OrderRank
    FROM (
        SELECT S.store_name, ST.staff_id, ST.first_name, ST.last_name, 
               COUNT(O.order_id) AS NumberOfOrders,
               S.store_id
        FROM dbo.stores S
        INNER JOIN dbo.staffs ST ON S.store_id = ST.store_id
        LEFT JOIN dbo.orders O ON O.staff_id = ST.staff_id
        GROUP BY S.store_name, ST.staff_id, ST.first_name, ST.last_name, S.store_id
    ) SubQueryAlias
) RankedData
WHERE OrderRank = 1



SELECT store_name, staff_id, first_name, last_name, NumberOfOrders, 
       RANK() OVER (PARTITION BY store_id ORDER BY NumberOfOrders DESC) AS OrderRank
FROM (
    SELECT S.store_name, ST.staff_id, ST.first_name, ST.last_name, 
           COUNT(O.order_id) AS NumberOfOrders,
           S.store_id
    FROM dbo.stores S
    INNER JOIN dbo.staffs ST ON S.store_id = ST.store_id
    LEFT JOIN dbo.orders O ON O.staff_id = ST.staff_id
    GROUP BY S.store_name, ST.staff_id, ST.first_name, ST.last_name, S.store_id
) SubQueryAlias
GO;

-- Question 8
CREATE PROCEDURE PR1
@storeID INT, @numberOfStaffs INT OUTPUT
AS
BEGIN
	set @numberOfStaffs = (Select COUNT(ST.[store_id]) FROM [dbo].[staffs] ST WHERE ST.store_id = @storeID  GROUP BY [store_id])
END

Declare @x INT
EXEC pr1 3, @x output
select @x as NumberOfStaffs
GO;

-- Question 9
CREATE TRIGGER Tr2 
ON [dbo].[stocks]
FOR DELETE
AS
BEGIN
	SELECT P.[product_id], [product_name], ST.[store_id], ST.[store_name], D.[quantity]
	FROM [dbo].[products] P
		inner join deleted D on D.product_id = P.product_id
		inner join [dbo].[stores] ST on D.store_id = ST.store_id
END   

-- Exec
DELETE FROM [dbo].[stocks]
WHERE [store_id] = 1 AND [product_id] in (10,11,12)

-- 10 
update stocks 
set quantity = 30
where store_id = 1 and product_id in 
(select p.product_id from stocks s, products p
where p.product_id = s.product_id and 
p.category_name = 'Cruisers Bicycles' and s.store_id = 1)