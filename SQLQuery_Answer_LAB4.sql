--Câu 1 (1 điểm): Hãy viết lệnh SQL để tạo cấu trúc các bảng trên.
create table HANGHOA(
MaHang varchar(5) primary key,
TenHang nvarchar(30),
DVT nvarchar(5),
)
create table KHACHHANG(
MaKH varchar(5) primary key,
HoKH nvarchar(30),
TenKH nvarchar(30),
DiaChi nvarchar(20),
SoDT varchar(15),
)
create table HOADON(
SoHD varchar(5) primary key,
NgayHD date,
MaKH varchar(5) foreign key references KHACHHANG(MaKH),
)
create table CHITIETHOADON(
SoHD varchar(5) foreign key references HOADON(soHD),
MaHang varchar(5) foreign key references HANGHOA(MaHang),
primary key (soHD, MaHang),
SoLuong tinyint,
DonGia int,
)


--Câu 2 (1 điểm): Hãy viết lệnh SQL để nhập dữ liệu vào các bảng trên.
insert into HANGHOA values('TL001',N'Thuốc lá Prince', N'Gói');
insert into HANGHOA values('TL002',N'Thuốc lá White Horse',N'Gói')
insert into HANGHOA values('B001',N'Bánh Chocolate',N'Hộp')
insert into HANGHOA values('NM001',N'Nước mắm Nam Ngư',N'Chai');
---KHACH HANG
insert into KHACHHANG values('KH001',N'Nguyễn Văn',N'Hải',N'16 Lê Lợi - ĐN','0935688515');
insert into KHACHHANG values('KH002',N'Trần Anh',N'Khôi',N'8 Lê Duẩn - ĐN','0905619034');
insert into KHACHHANG values('KH003',N'Lê Ngọc',N'Lan',N'2 Thanh Thủy - ĐN','0905943847');
insert into KHACHHANG values('KH004',N'Ngô Minh',N'Tú',N'12 Hải Hồ - ĐN','0905881456');
--HOA DON
delete from HOADON
insert into HOADON values('001','2013/09/03','KH001');
insert into HOADON values('002','2013/09/05','KH002');
insert into HOADON values('003','2013/10/12','KH001');
select *
from HOADON
delete from CHITIETHOADON
--CHITIETHOADON
insert into CHITIETHOADON values('001','TL001',10,7000);
insert into CHITIETHOADON values('001','B001',5,45000);
insert into CHITIETHOADON values('002','TL002',30,20000);
insert into CHITIETHOADON values('002','B001',15,48000);
insert into CHITIETHOADON values('003','NM001',2,25000);

--3.Hãy viết lệnh SQL để liệt kê danh sách các hóa đơn có tổng  thành tiền từ 5 triệu đồng trở lên, biết thành tiền = số lượng * đơn giá. 
--Yêu cầu hiển thị các thông tin: SoHD, NgayHD, Họ tên KH, Tổng thành tiền.
select hd.sohd, hd.ngayhd, hokh,tenkh,sum(cthd.dongia*cthd.soluong) as thanhtien
from dbo.HOADON hd 
inner join dbo.KHACHHANG kh on hd.MaKH = kh.MaKH
inner join dbo.CHITIETHOADON cthd on cthd.SoHD = hd.SoHD
group by hd.sohd, hd.ngayhd, hokh,tenkh
having sum(cthd.dongia*cthd.soluong) > 5000000

--Câu 3 (1,5 điểm): Hãy tạo View có tên BangTongHop để lập bảng tính tiền theo yêu cầu dưới đây. View gồm có các trường sau: SoHD, MaHang, SoLuong, DonGia, ThanhTien, Thue, Thực Trả,  Trong đó:
--Thành tiền = số lượng * đơn giá
--Thuế được tính như sau:
--Nếu mặt hàng là thuốc lá tính thuế 30% thành tiền
--Các mặt hàng còn lại nếu số lượng > 20 tính thuế 10% thành tiền.
--Nếu số lượng >10 và <20 tính thuế 5% thành tiền.
--Còn lại được miễn thuế
--Thực trả = thành tiền + Thuế
create view BangTongHop as
select CTHD.SoHD,CTHD.MaHang,CTHD.SoLuong,CTHD.DonGia, (CTHD.SoLuong*CTHD.DonGia)as ThanhTien,
case 
when (HH.TenHang=N'Thuốc lá Price' or HH.TenHang=N'Thuốc lá White Horse') then (CTHD.SoLuong*CTHD.DonGia)*30/100
when CTHD.SoLuong > 20 then (CTHD.SoLuong*CTHD.DonGia)*10/100
when CTHD.SoLuong>10 and CTHD.SoLuong < 20 then (CTHD.SoLuong*CTHD.DonGia)*5/100
ELSE 0
END as Thue, 
case 
when (HH.TenHang=N'Thuốc lá Price' or HH.TenHang=N'Thuốc lá White Horse') then (CTHD.SoLuong*CTHD.DonGia)*30/100+(CTHD.SoLuong*CTHD.DonGia)
when CTHD.SoLuong > 20 then (CTHD.SoLuong*CTHD.DonGia)*10/100+(CTHD.SoLuong*CTHD.DonGia)
when CTHD.SoLuong>10 and CTHD.SoLuong < 20 then (CTHD.SoLuong*CTHD.DonGia)*5/100+(CTHD.SoLuong*CTHD.DonGia)
ELSE 0+(CTHD.SoLuong*CTHD.DonGia)
END as ThucTra
from CHITIETHOADON CTHD inner join HANGHOA HH on CTHD.MaHang=HH.MaHang
inner join HOADON HD on CTHD.SoHD=HD.SoHD


--Câu 4 (1,5 điểm): Hãy viết lệnh SQL liệt kê ra khách hàng mua có  số lượng lớn nhất của mỗi  mặt hàng gồm các cột sau: Mã khách hàng, họ tên khách hàng và số lượng.
select kh.makh, kh.hokh, kh.tenkh,ctdh.mahang, ctdh.soluong
from dbo.KHACHHANG kh
inner join dbo.HOADON hd on kh.MaKH = hd.MaKH
inner join dbo.CHITIETHOADON ctdh on ctdh.SoHD = hd.SoHD
inner join dbo.HANGHOA hh on ctdh.MaHang = hh.MaHang
where ctdh.soluong >= ALL (
    SELECT SoLuong
    FROM CHITIETHOADON sub_cthd
    WHERE sub_cthd.MaHang = ctdh.mahang
  );

--Câu 5: Hiển thị danh sách khách hàng mua hàng vào vào tháng 9 năm 2013 và có tổng số tiền của hóa đơn lớn hơn hoặc bằng 500000.
select CTHD.SoHD,HD.NgayHD,HD.MaKH,(CTHD.SoLuong*CTHD.DonGia) as ThanhTien
from CHITIETHOADON CTHD inner join HOADON HD on CTHD.SoHD=HD.SoHD
where (CTHD.SoLuong*CTHD.DonGia)>500000 and
DATEPART (MONTH, HD.NgayHD)=9 and
DATEPART (YEAR, HD.NgayHD)=2013

--Câu 6 (1 điểm): Hiển thị danh sách các mặt hàng bán được nhiều nhất từ ngày 01/09/2013 đến 31/10/2013
WITH TotalSold AS (
    SELECT MaHang, SUM(SoLuong) AS TotalQuantity
    FROM CHITIETHOADON CT
    JOIN HOADON H ON CT.SoHD = H.SoHD
    WHERE H.NgayHD BETWEEN '2013-09-01' AND '2013-10-31'
    GROUP BY MaHang
)
SELECT H.MaHang, H.TenHang, TS.TotalQuantity
FROM HANGHOA H
JOIN TotalSold TS ON H.MaHang = TS.MaHang
WHERE TS.TotalQuantity = (SELECT MAX(TotalQuantity) FROM TotalSold)

-- 7 Hãy viết lệnh SQL thực hiện các thao tác sau:
--Thêm một bản ghi mới vào bảng CHITIETHOADON; dữ liệu phù hợp nhưng không được nhập giá trị null.
--Thay đổi đơn giá của các mặt hàng là thuốc lá tăng lên 10%.
--Xóa các khách hàng chưa mua bất kì mặt hàng nào.
INSERT INTO CHITIETHOADON (SoHD, MaHang, SoLuong, DonGia)
VALUES ('003', 'B001', '10', '5000')
-- Thay đổi đơn giá của các mặt hàng là thuốc lá tăng lên 10%
UPDATE CHITIETHOADON 
SET DonGia = DonGia * 1.1
WHERE MaHang LIKE 'TL%'
-- Xóa các khách hàng chưa mua bất kì mặt hàng nào.
DELETE FROM KHACHHANG
WHERE MaKH NOT IN (SELECT DISTINCT MaKH FROM HOADON)