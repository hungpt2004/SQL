--1. In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp.
select mahv, ho, ten, ngsinh, hv.malop
from dbo.HOCVIEN hv
inner join dbo.LOP l on hv.MALOP = l.MALOP
group by mahv, ho, ten, ngsinh, hv.malop

--2. In ra bảng điểm khi thi (mã học viên, họ tên , lần thi, điểm số) môn CTRR của lớp “K12”, 
--sắp xếp theo tên, họ học viên.
select hv.mahv, ho, ten, lanthi, diem
from dbo.HOCVIEN hv 
inner join dbo.KETQUATHI kq on hv.MAHV = kq.MAHV
inner join dbo.MONHOC m on kq.MAMH = m.MAMH
where kq.MAMH = N'CTRR' and hv.MALOP=N'K12'

--3. In ra danh sách những học viên (mã học viên, họ tên) 
--và những môn học mà học viên đó thi lần thứ nhất đã đạt.
select hv.mahv, ho, ten, lanthi, kqua
from dbo.HOCVIEN hv
inner join dbo.KETQUATHI kq on hv.MAHV = kq.MAHV
where kq.LANTHI = 1 and kq.KQUA = N'Dat'

--4. In ra danh sách học viên (mã học viên, họ tên) 
--của lớp “K11” thi môn CTRR không đạt (ở lần thi 1).
select hv.mahv, ho, ten, lanthi, kqua
from dbo.HOCVIEN hv 
inner join dbo.KETQUATHI kq on hv.MAHV = kq.MAHV
where hv.MALOP =N'K11' and kq.LANTHI = 1 and kq.MAMH = N'CTRR' and kq.KQUA = N'Khong Dat'

--5. * Danh sách học viên (mã học viên, họ tên) 
--của lớp “K” thi môn CTRR không đạt (ở tất cả các lần thi).
select distinct hv.mahv, ho, ten, lanthi, kqua
from dbo.HOCVIEN hv
inner join dbo.KETQUATHI kq on hv.MAHV = kq.MAHV
where hv.MALOP LIKE 'K%' and kq.MAMH = N'CTRR' and kq.KQUA = N'Khong Dat'
group by hv.mahv, ho, ten, lanthi, kqua


--6. Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1 năm 2006.
select distinct mh.mamh, mh.tenmh, gv.hoten, gd.hocky, gd.nam
from dbo.MONHOC mh
inner join dbo.GIANGDAY gd on mh.MAMH = gd.MAMH
inner join dbo.GIAOVIEN gv on gv.MAGV = gd.MAGV
where gv.HOTEN = N'Tran Tam Thanh' and gd.HOCKY = 1 and gd.NAM = 2006


--7. Tìm những môn học (mã môn học, tên môn học) 
--mà giáo viên chủ nhiệm lớp “K11” dạy trong học kỳ 1 năm 2006.
select mh.mamh, mh.tenmh
from dbo.MONHOC mh
left outer join dbo.GIANGDAY gd on gd.MAMH = mh.MAMH
left outer join dbo.LOP l on l.MALOP = gd.MALOP and gd.MAGV = l.MAGVCN
where l.MALOP = 'K11' and gd.HOCKY = 1 and gd.NAM = 2006

select dbo.GIAOVIEN.HOTEN, dbo.MONHOC.TENMH, dbo.LOP.MALOP,dbo.HOCVIEN.HO, dbo.HOCVIEN.TEN, dbo.HOCVIEN.MAHV, dbo.LOP.TRGLOP
from dbo.GIANGDAY,dbo.HOCVIEN, dbo.LOP,dbo.GIAOVIEN, dbo.MONHOC
where dbo.GIAOVIEN.HOTEN = N'Nguyen To Lan' and dbo.MONHOC.TENMH = N'Co So Du Lieu' 

--8. Tìm họ tên lớp trưởng của các lớp 
--mà giáo viên có tên “Nguyen To Lan” dạy môn “Co So Du Lieu”.
select distinct hv.ho, hv.ten, hv.MALOP
from dbo.HOCVIEN hv
left outer join dbo.LOP l on hv.MAHV = l.TRGLOP and hv.MALOP = l.MALOP
left outer join dbo.GIANGDAY gd on gd.MALOP = l.MALOP
left outer join dbo.MONHOC mh on mh.MAMH = gd.MAMH
left outer join dbo.GIAOVIEN gv on gd.MAGV = gv.MAGV
where gv.HOTEN = 'Nguyen To Lan' and mh.TENMH = 'Co So Du Lieu'

select *
from dbo.GIANGDAY,dbo.HOCVIEN, dbo.LOP,dbo.GIAOVIEN, dbo.MONHOC
where dbo.GIAOVIEN.HOTEN = N'Nguyen To Lan' and dbo.MONHOC.TENMH = N'Co So Du Lieu' 

--9. In ra danh sách những môn học (mã môn học, tên môn học) 
--phải học liền trước môn “Co So Du Lieu”.
SELECT mh.MaMH, mh.tenMH
FROM MONHOC mh
WHERE mh.MAMH in (
select mamh_truoc
from MONHOC mh
left outer join DIEUKIEN dk on mh.MAMH = dk.MAMH_TRUOC
)

--10 Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước những môn học (mã môn học, tên môn học) nào.
select distinct mh1.MaMH, mh1.tenMH
from MONHOC mh1
where mh1.MAMH in (select dk.MaMH from DIEUKIEN dk inner join MONHOC mh on mh.MAMH = dk.MAMH_TRUOC where mh.TENMH = 'Cau truc du lieu va giai thuat')

select *
from MONHOC inner join DIEUKIEN on DIEUKIEN.MAMH = MONHOC.MAMH

select *
from GIAOVIEN gv
inner join GIANGDAY gd on gv.MAGV = gd.MAGV
inner join MONHOC mh on gd.MAMH = mh.MAMH
where mh.MAMH = 'CTRR'

--11. Tìm họ tên giáo viên dạy môn CTRR cho cả hai lớp “K11” và “K12” trong cùng học kỳ 1 năm 2006.
select distinct gv.magv, gv.hoten
from GIAOVIEN gv
inner join GIANGDAY gd on gv.MAGV = gd.MAGV
inner join MONHOC mh on gd.MAMH = mh.MAMH
where mh.MAMH = 'CTRR' and gd.HOCKY = 1 and gd.NAM = 2006 and gd.MALOP in ('k11','k12')

--12. Tìm những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1 nhưng chưa thi lại môn này.
select hv.MAHV, hv.HO, hv.TEN, kq.LANTHI, kq.KQUA
from HOCVIEN hv
inner join KETQUATHI kq on hv.MAHV = kq.MAHV
inner join MONHOC mh on mh.MAMH = kq.MAMH
where mh.MAMH = 'CSDL'
and kq.LANTHI = 1 
and kq.KQUA = N'Khong Dat' 
and not exists (select * from KETQUATHI where LANTHI>1 and KETQUATHI.MAHV = hv.MAHV)

select hv.MAHV, hv.HO, hv.TEN, kq.LANTHI, kq.KQUA
from HOCVIEN hv
inner join KETQUATHI kq on hv.MAHV = kq.MAHV
inner join MONHOC mh on mh.MAMH = kq.MAMH


--13. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào.
SELECT [MAGV],[HOTEN]
FROM [dbo].[GIAOVIEN]
WHERE [MAGV] not in (
	SELECT [MAGV] 
	FROM [dbo].[GIANGDAY]
	)


--14. Tìm giáo viên (mã giáo viên, họ tên) 
--không được phân công giảng dạy bất kỳ môn học nào thuộc khoa giáo viên đó phụ trách.
SELECT [MAGV],[HOTEN]
FROM [dbo].[GIAOVIEN] GV
WHERE GV.MAGV not in (
	  SELECT MAGV
	  FROM [dbo].[MONHOC] MH
	  WHERE MH.MAKHOA = GV.MAKHOA
	  )
--check
SELECT *
FROM [dbo].[GIAOVIEN],[dbo].[GIANGDAY],[dbo].[KHOA]
SELECT *
FROM [dbo].[GIANGDAY],[dbo].[KHOA]
--15. Tìm họ tên các học viên thuộc lớp “K11” 
--thi một môn bất kỳ quá 3 lần vẫn “Khong dat” hoặc thi lần thứ 2 môn CTRR được 5 điểm.
SELECT DISTINCT HV.[MAHV],HV.[HO],HV.[TEN],HV.MALOP
FROM [dbo].[HOCVIEN] HV
WHERE HV.MALOP in ('K11') 
AND (HV.MAHV in (
	SELECT MAHV
	FROM [dbo].[KETQUATHI] 
	WHERE DIEM = 5 and LANTHI > 1 and MAMH = 'CTRR'
	)
OR	HV.MAHV in (
	SELECT MAHV 
	FROM [dbo].[KETQUATHI] 
	WHERE KQUA = 'Khong Dat' and LANTHI >= 3
	))

--16. Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của một năm học.
SELECT GV.[MAGV],[HOTEN],[HOCKY],[NAM],COUNT(gd.MALOP) AS [TotalCLasses]
FROM [dbo].[GIAOVIEN] GV
	 inner join [dbo].[GIANGDAY] GD on GD.MAGV = GV.MAGV
	 inner join [dbo].[MONHOC] MH on GD.MAMH = MH.MAMH
WHERE MH.MAMH = 'CTRR'
GROUP BY  GV.[MAGV],[HOTEN],[HOCKY],[NAM]
HAVING COUNT(gd.MALOP) >= 2
	
--17. Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng).
SELECT hv.[MAHV],[HO],[TEN],[LANTHI],[DIEM]
FROM [dbo].[HOCVIEN] hv
	inner join [dbo].[KETQUATHI] kq on hv.MAHV = kq.MAHV
	inner join [dbo].[MONHOC] mh on kq.MAMH = mh.MAMH
WHERE mh.MAMH = 'CSDL' AND 
	  kq.LANTHI in (
		SELECT MAX(LANTHI)
		FROM [dbo].[KETQUATHI] kq2 
		WHERE kq2.MAHV = hv.MAHV and kq2.MAMH = mh.MAMH
		)	  
--18. Danh sách học viên và điểm thi môn “Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần thi).
SELECT hv.[MAHV],[HO],[TEN],[LANTHI],[DIEM]
FROM [dbo].[HOCVIEN] hv
	inner join [dbo].[KETQUATHI] kq on hv.MAHV = kq.MAHV
	inner join [dbo].[MONHOC] mh on kq.MAMH = mh.MAMH
WHERE mh.TENMH = N'Co So Du Lieu' AND 
	  kq.DIEM in (
		SELECT MAX(DIEM)
		FROM [dbo].[KETQUATHI] kq2 
		WHERE kq2.MAHV = hv.MAHV and kq2.MAMH = mh.MAMH
		)	  

--19. Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất.
SELECT [MAKHOA],[TENKHOA],[NGTLAP]
FROM [dbo].[KHOA]
WHERE [NGTLAP] in (
	  SELECT MIN([NGTLAP])
	  FROM [dbo].[KHOA]
)

--20. Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”.
SELECT COUNT([MAGV]) AS [TongGiaoVien]
FROM [dbo].[GIAOVIEN]
WHERE HOCHAM in ('GS','PGS')

--21. Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa.
SELECT k.[MAKHOA],[TENKHOA],[HOCVI],COUNT([MAGV]) AS [TongGiaoVien]
FROM [dbo].[KHOA] K
inner join [dbo].[GIAOVIEN] gv on gv.MAKHOA = K.MAKHOA
WHERE HOCVI in ('CN', 'KS', 'Ths', 'TS', 'PTS')
GROUP BY k.[MAKHOA],[TENKHOA],[HOCVI]

--22. Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt).
SELECT mh.[MAMH],[KQUA], COUNT([MAHV]) AS [TotalStudents]
FROM [dbo].[KETQUATHI] kq
	 inner join [dbo].[MONHOC] mh on kq.MAMH = mh.MAMH
GROUP BY mh.[MAMH],[KQUA]
ORDER BY mh.[MAMH]

--23. Tìm giáo viên (mã giáo viên, họ tên) 
--là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho lớp đó ít nhất một môn học.
--GV,LOP,GIANGDAY,MONHOC
SELECT gv.[MAGV],[HOTEN], COUNT(mh.MAMH) AS [TotalCourses]
FROM [dbo].[GIAOVIEN] gv
	 inner join [dbo].[GIANGDAY] gd on gd.MAGV = gv.MAGV
	 inner join [dbo].[LOP] l on l.MALOP = gd.MALOP and l.MAGVCN = gd.MAGV
	 inner join [dbo].[MONHOC] mh on gd.MAMH = mh.MAMH
GROUP BY gv.[MAGV],[HOTEN]
HAVING COUNT(mh.MAMH) >=1 


--24. Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất
SELECT [MAHV],[HO],[TEN]
FROM [dbo].[HOCVIEN] hv 
     inner join [dbo].[LOP] l on hv.MALOP = l.MALOP and hv.MAHV = l.TRGLOP
WHERE SISO in (
	SELECT MAX(SISO)
	FROM [dbo].[LOP]
)
--25*

--26. Tìm học viên (mã học viên, họ tên) 
--có số môn đạt điểm 9,10 nhiều nhất
SELECT top 1 hv.[MAHV],[HO],[TEN],COUNT([MAMH]) AS [TotalCourses]
FROM [dbo].[HOCVIEN] hv 
	 inner join [dbo].[KETQUATHI] kq on hv.MAHV = kq.MAHV
WHERE DIEM in (9,10)
GROUP BY hv.[MAHV],[HO],[TEN]
ORDER BY COUNT([MAMH]) DESC

--27. Trong từng lớp, tìm học viên (mã học viên, họ tên) 
--có số môn đạt điểm 9,10 nhiều nhất
SELECT L1.[MALOP],[MAHV],[HO],[TEN]
FROM [dbo].[HOCVIEN] HV1 
	 inner join [dbo].[LOP] L1 on HV1.MALOP = L1.MALOP
WHERE HV1.MAHV in (
	  select top 1 HV2.[MAHV]
	  from [dbo].[KETQUATHI] KQ 
	       inner join [dbo].[HOCVIEN] HV2 on KQ.MAHV = HV2.MAHV
	  where KQ.DIEM in (9,10) and HV2.MALOP = HV1.MALOP
	  group by HV2.MAHV
	  order by COUNT(KQ.MAMH) DESC
)

SELECT *
FROM [dbo].[HOCVIEN] hv 
inner join [dbo].[KETQUATHI] kq on hv.MAHV = kq.MAHV
inner join [dbo].[LOP] l on hv.MALOP = l.MALOP
WHERE hv.MALOP LIKE 'K%'

--28. Trong từng học kỳ của từng năm, mỗi giáo viên phân công dạy bao nhiêu môn học, bao nhiêu lớp.
SELECT [MAGV],[HOCKY],[NAM],COUNT(DISTINCT GD.MAMH) AS [TotalCourse], COUNT(DISTINCT GD.MALOP) AS [TotalClass]
FROM [dbo].[GIANGDAY] GD 
	 inner join [dbo].[LOP] L on GD.MALOP = L.MALOP
     inner join [dbo].[MONHOC] MH on GD.MAMH = MH.MAMH
GROUP BY [MAGV],[HOCKY],[NAM]
ORDER BY [MAGV]

SELECT *
FROM [dbo].[GIANGDAY] gd 
inner join [dbo].[LOP] l on gd.MALOP = l.MALOP
inner join [dbo].[MONHOC] mh on gd.MAMH = mh.MAMH

--29. Trong từng học kỳ của từng năm, tìm giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất
SELECT GV1.[MAGV],[HOTEN]
FROM [dbo].[GIAOVIEN] GV1
WHERE EXISTS (
	  select top 1 [MAGV],[HOCKY],[NAM],COUNT([MAMH])
	  from [dbo].[GIANGDAY] GD 
	  where GD.MAGV = GV1.MAGV
	  group by [MAGV],[HOCKY],[NAM]
	  order by COUNT([MAMH]) DESC 
) 


SELECT *
FROM [dbo].[GIAOVIEN] GV
inner join [dbo].[GIANGDAY] GD on GV.MAGV = GD.MAGV
inner join [dbo].[MONHOC] MH on MH.MAMH = GD.MAMH

--30. Tìm môn học (mã môn học, tên môn học) có nhiều học viên thi không đạt (ở lần thi thứ 1) nhất.
SELECT [MAMH],[TENMH]
FROM [dbo].[MONHOC] MH
WHERE EXISTS (
	  select top 1 [MAMH],[LANTHI],[KQUA],COUNT([MAHV])
	  from [dbo].[KETQUATHI] KQ
	  where KQ.MAMH = MH.MAMH and KQ.LANTHI = 1 and KQ.KQUA = 'Khong Dat'
	  group by [MAMH],[LANTHI],[KQUA]
	  order by COUNT([MAHV]) DESC 
)
--check
SELECT *
FROM [dbo].[MONHOC] MH
inner join [dbo].[KETQUATHI] KQ on MH.MAMH = KQ.MAMH
WHERE KQ.KQUA in ('Dat')
ORDER BY MH.MAMH

--31. Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi thứ 1).
SELECT DISTINCT HV.[MAHV],[HO],[TEN]
FROM [dbo].[HOCVIEN] HV
	 inner join [dbo].[KETQUATHI] KQ on HV.MAHV = KQ.MAHV
WHERE NOT EXISTS (
	  select *
	  from [dbo].[KETQUATHI] 
	  where MAHV = HV.MAHV and LANTHI = 1 and KQUA = N'Khong Dat'
)

select*
from [dbo].[HOCVIEN] hv
inner join [dbo].[KETQUATHI] kq on hv.MAHV=kq.MAHV
inner join [dbo].[MONHOC] mh on kq.MAMH = mh.MAMH


--32. * Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi sau cùng).
SELECT DISTINCT HV.[MAHV],[HO],[TEN]
FROM [dbo].[HOCVIEN] HV
	 inner join [dbo].[KETQUATHI] KQ on HV.MAHV = KQ.MAHV
WHERE NOT EXISTS (
				  select *
				  from [dbo].[KETQUATHI] 
				  where MAHV = HV.MAHV and KQUA = N'Khong Dat' and LANTHI IN (
																			  select MAX(LANTHI)
																			  from [dbo].[KETQUATHI] kq2
																			  where kq2.MAHV = HV.MAHV))

--33.* Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn đều đạt (chỉ xét lần thi thứ 1).
--35.** Tìm học viên (mã học viên, họ tên) có điểm thi cao nhất trong từng môn (lấy điểm ở lần thi sau cùng)
SELECT DISTINCT HV.[MAHV],[HO],[TEN],KQ.MAMH
FROM [dbo].[HOCVIEN] HV
	 inner join [dbo].[KETQUATHI] KQ on HV.MAHV = KQ.MAHV
WHERE LANTHI in (
	             SELECT DISTINCT MAX(LANTHI)
				 FROM [dbo].[KETQUATHI] KQ2
				 WHERE KQ2.MAHV = HV.MAHV
) AND DIEM in (
			   SELECT DISTINCT MAX(DIEM)
			   FROM [dbo].[KETQUATHI] KQ2
			   WHERE KQ2.MAHV = HV.MAHV
)
																			


