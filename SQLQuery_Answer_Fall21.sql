

-- Question 2
SELECT *
FROM [dbo].[Location]
WHERE [CostRate] > 0

-- Question 3
SELECT P.[ProductID],PPH.[Price],[StartDate],[EndDate]
FROM [dbo].[ProductPriceHistory] PPH
	inner join [dbo].[Product] P on PPH.ProductID = P.ProductID
WHERE YEAR([EndDate]) = 2003 AND PPH.[Price] < 100 
ORDER BY [Price] DESC

-- Question 4
SELECT P.[ProductID],P.[Name],PS.[SubcategoryID],PS.[Category],PS.[Name],[Color],
[StartDate],[EndDate],PCH.[Cost]
FROM [dbo].[ProductCostHistory] PCH
	right outer join [dbo].[Product] P on PCH.ProductID = P.ProductID
	left outer join [dbo].[ProductSubcategory] PS on P.SubcategoryID = PS.SubcategoryID
WHERE [Color] = ('Black') AND P.[Name] LIKE ('HL%') 

-- Question 5
SELECT L.[LocationID], L.[Name], COUNT([ProductID]) as [NumberOfProducts]
FROM [dbo].[Location] L 
	inner join [dbo].[ProductInventory] PI on L.LocationID = PI.LocationID
GROUP BY L.[LocationID], L.[Name]
ORDER BY COUNT([ProductID]) DESC

-- Question 7
SELECT Pmodel.[ModelID], Pmodel.[Name], P.[ProductID], P.[Name], COUNT(Piven.LocationID) as [NumberOfLocations]
FROM [dbo].[Product] P
	inner join [dbo].[ProductModel] Pmodel on P.ModelID = Pmodel.ModelID
	right outer join [dbo].[ProductInventory] Piven on P.ProductID = P.ProductID
WHERE Pmodel.[Name] LIKE ('HL%')
GROUP BY  Pmodel.[ModelID], Pmodel.[Name], P.[ProductID], P.[Name]


SELECT ModelID,[Name],ProductID,ProductName,NumberOfLocations	
FROM(
select PM.ModelID,PM.[Name],P.ProductID,P.[Name] as ProductName, count([PI].LocationID) as NumberOfLocations,Rank () OVER(Partition by PM.[Name] order by count([PI].LocationID) desc)as Rank
from ProductModel PM left outer join Product P on PM.ModelID=P.ModelID
left outer join [dbo].[ProductInventory] [PI] on P.ProductID=[PI].ProductID
where PM.[Name] like 'HL Mountain%'
group by PM.ModelID,PM.[Name],P.ProductID,P.[Name]
) as SRC
WHERE rank = 1
GO;


--Question 8
CREATE PROCEDURE proc_product_subccategory
@subCategory INT, @NumberOfProduct INT OUTPUT
AS
BEGIN
	SET @NumberOfProduct = (SELECT COUNT(P.[ProductID]) 
	FROM [dbo].[Product] P 
	WHERE P.SubcategoryID = @subCategory
	)
END

DECLARE @x INT
EXEC proc_product_subccategory 1, @x output
SELECT @x as [NumberOfProduct]
GO;

-- Question 9
CREATE TRIGGER tr_delete_productInventory_location
on [dbo].[ProductInventory]
FOR delete
AS
BEGIN
	SELECT P.[ProductID], L.[LocationID], L.[Name] as [LocationName], [Shelf], [Bin], [Quantity]
	FROM [dbo].[Product] P
		inner join Deleted D on P.ProductID = D.ProductID
		inner join [dbo].[Location] L on D.LocationID = L.LocationID
END


delete from [dbo].[ProductInventory]
where [ProductID] = 1 and [LocationID] = 1

-- Question 10
UPDATE [dbo].[ProductInventory] SET [Quantity] = 2000
WHERE exists (select * 
	   from [dbo].[Product] p
	   where p.[ModelID] = 33)

