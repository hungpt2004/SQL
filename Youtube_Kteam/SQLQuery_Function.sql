-- Bài 30
-- Function
--Tạo Function không có tham số truyền vào
CREATE FUNCTION UF_SelectAllEmployee()
RETURNS TABLE
AS RETURN SELECT * FROM [dbo].[tblEmployee]
GO;
--Thực thi
SELECT * FROM UF_SelectAllEmployee()



--Tạo hàm xuất ra lương của nhân viên
--Tham số truyền vào là tenNhanVien
CREATE FUNCTION UF_SelectLuongNhanVien (@TenNhanVien nvarchar(30))
RETURNS INT
AS
BEGIN
	DECLARE @Luong INT
	SELECT @Luong = empSalary FROM [dbo].[tblEmployee] WHERE empName = @TenNhanVien
	RETURN @Luong
END
--Cách thực thi
SELECT [dbo].[UF_SelectLuongNhanVien](empname) AS [Salary] FROM [dbo].[tblEmployee] 


--Tạo thử Function kiểm tra số chắn hay số lẻ
CREATE FUNCTION UF_IsOdd(@num int)
RETURNS NVARCHAR(30)
AS
BEGIN
	IF(@num % 2 = 0)
		RETURN N'Số Chẵn'
	ELSE
		RETURN N'Số Lẻ'

	RETURN N'Không xác định'
END
--Tạo Function tính tuổi
ALTER FUNCTION UF_CalculateAge(@Year datetime)
RETURNS INT
AS
BEGIN 
	RETURN YEAR(GETDATE())-YEAR(@Year)
END


--Xét tuổi là số chắn hay số lẻ
SELECT dbo.UF_CalculateAge(empBirthDate),dbo.UF_IsOdd(dbo.UF_CalculateAge(empBirthDate)) FROM [dbo].[tblEmployee] 



