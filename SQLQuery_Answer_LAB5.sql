-- 1.Write function name: StudenID_ Func1 with parameter @mavt, return the sum of sl*giaban corresponding.
CREATE FUNCTION StudentID_Func1(@mavt nvarchar(5))
RETURNS int
AS
BEGIN
	DECLARE @TongTien INT
	SELECT @TongTien = SUM([SL]*[GiaBan]) FROM [dbo].[CHITIETHOADON] WHERE MaVT = @mavt
	RETURN @TongTien
END
GO;
--Execute 1
SELECT dbo.StudentID_Func1(MaVT) AS [TongHoaDon] FROM [dbo].[CHITIETHOADON]
GO;

--2.Write function to return a total of the HoaDon (@MahD is a parameter) 
CREATE FUNCTION Total_HoaDon(@mahd nvarchar(5))
RETURNS int
AS 
BEGIN
	DECLARE @TongTien INT
	SELECT @TongTien = SUM([SL]*[GiaBan]) FROM [dbo].[CHITIETHOADON] WHERE MaHD = @mahd
	RETURN @TongTien
END
GO;
--Execute
SELECT dbo.Total_HoaDon(MaHD) AS [TongHoaDon] FROM [dbo].[CHITIETHOADON] 
GO;

--3.Write procedure name: StudenId _Proc1, parameter @makh, @diachi. This procedure help user update @diachi corresponding @makh.
CREATE PROCEDURE StudentID_Proc1
@makh nvarchar(5), @diachi nvarchar(50)
AS
BEGIN
	--Update KhachHang Table
	UPDATE KHACHHANG
	SET DiaChi = @diachi
	WHERE MaKH = @makh
END
GO;

--Execute
EXEC StudentID_Proc1 @diachi = 'Da Nang', @makh = 'KH01';
GO;

--4.Write procedure to add an item into Hoadon 
--add item => chi tiet hoa don
CREATE PROCEDURE AddItemIntoHoaDon
@mahd nvarchar(10),
@mavt nvarchar(5),
@soluong int,
@khuyenmai int,
@giaban int
AS
BEGIN
	INSERT INTO [dbo].[CHITIETHOADON]
	VALUES (@mahd,@mavt,@soluong,@khuyenmai,@giaban)
END
GO;


--5.Write trigger name: StudenId_ Trig1 on table Chitiethoadon, 
--when user insert data into Chitiethoadon, 
--the trigger will update the Pennington in HoaDon(student should add Tongtien column into Hoadon, tongtien=sum(sl*giaban).
CREATE TRIGGER StudentID_Trig1
ON [dbo].[CHITIETHOADON]
FOR INSERT
AS
BEGIN
	UPDATE HOADON 
	SET TongTG = (SELECT SUM([SL]*[GiaBan]) FROM [dbo].[CHITIETHOADON] WHERE [MaHD] = inserted.[MaHD])
	FROM [dbo].[HOADON]
	inner join inserted on [dbo].[HOADON].[MaHD] = inserted.[MaHD]
END
GO;

--6.Write view name: StudentID_View1 to extract list of customers who bought ‘Gach Ong’
CREATE VIEW StudentID_View1 AS
SELECT KH.*
FROM [dbo].[KHACHHANG] KH
	inner join [dbo].[HOADON] HD on KH.MaKH = HD.MaKH
	inner join [dbo].[CHITIETHOADON] CTHD on HD.MaHD = CTHD.MaHD
	inner join [dbo].[VATTU] VT on CTHD.MaVT = VT.MaVT
WHERE VT.TenVT = N'Gach Ong'
