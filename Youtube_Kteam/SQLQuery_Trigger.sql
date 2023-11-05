--TRIGGER 


CREATE TRIGGER UTF_InsertEmp
ON [dbo].[tblEmployee]
FOR INSERT, UPDATE
AS
BEGIN
	--ROLLBACK TRAN
	PRINT('Trigger')
END

--insert 1
INSERT [dbo].[tblEmployee] (empSSN,empName,empAddress,empSalary,empSex,empBirthdate,depNum,supervisorSSN,empStartdate)
VALUES(30121050007,N'Phạm Trọng Hùng',N'CLV',5000,'M','1990-02-17 00:00:00.000',1,30121050004,'2000-01-01 00:00:00.000')
--insert 2
INSERT [dbo].[tblEmployee] (empSSN,empName,empAddress,empSalary,empSex,empBirthdate,depNum,supervisorSSN,empStartdate)
VALUES(30121050005,N'Hoàng Công Ming',N'LVH',5000,'M','1995-02-17 00:00:00.000',1,30121050004,'2002-01-01 00:00:00.000')
GO;

--Tạo Trigger không cho phép xóa nhân viên
CREATE TRIGGER UTF_AbortAgeGrater
ON [dbo].[tblEmployee]
FOR DELETE
AS
 BEGIN
	DECLARE @COUNT INT = 0
	SELECT @COUNT = COUNT(*) 
	FROM DELETED
	WHERE YEAR(GETDATE()) - YEAR(DELETED.empBirthdate) > 60

	IF(@COUNT > 0)
	BEGIN
		PRINT(N'Không được xóa người lớn hơn 60 tuổi')
		ROLLBACK TRAN
	END
 END

--insert 3
INSERT [dbo].[tblEmployee] (empSSN,empName,empAddress,empSalary,empSex,empBirthdate,depNum,supervisorSSN,empStartdate)
VALUES(30121050009,N'Lê Kim Hoàng Nguyên',N'HChau',5000,'M','1960-02-17 00:00:00.000',1,30121050004,'2006-01-01 00:00:00.000')

DELETE [dbo].[tblEmployee] WHERE empName = N'Trần Nguyễn Phương Bình'

INSERT [dbo].[tblEmployee] (empSSN,empName,empAddress,empSalary,empSex,empBirthdate,depNum,supervisorSSN,empStartdate)
VALUES(30121050009,N'Lê Kim Hoàng Nguyên',N'HChau',5000,'M','1960-02-17 00:00:00.000',1,30121050004,'2006-01-01 00:00:00.000')--
-- insert hocsinh -> lop si so +1 