

--Tạo ra bảng lưu thông tin nhân viên
CREATE VIEW Empview as 
SELECT * FROM [dbo].[tblEmployee]

--Truy vấn tới bảng nhân viên dựa trên view
SELECT *
FROM Empview

--Update thông tin thông qua view
UPDATE [dbo].[tblEmployee] SET empSalary = 10000
WHERE empSSN = 30121050004

--Xóa view
DROP VIEW Empview

--Update view
--view chỉ chứa 1 cột hoặc 1 hàng
ALTER VIEW Empview as
SELECT empName 
FROM [dbo].[tblEmployee]