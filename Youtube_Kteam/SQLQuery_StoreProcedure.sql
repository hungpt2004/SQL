
--Store Procedure trong SQL
--Bài 29 
CREATE PROCEDURE USP_Test
@NAME NVARCHAR(30), @SALARY INT
AS
BEGIN
	SELECT * FROM [dbo].[tblEmployee] WHERE EMPNAME=@NAME AND EMPSALARY=@SALARY
END

EXEC USP_Test @Name = N'Mai Duy An', @Salary = 30000;
GO;


CREATE PROCEDURE USP_SelectAllEmployee
AS SELECT * FROM [dbo].[tblEmployee]

EXEC USP_SelectAllEmployee
GO;
