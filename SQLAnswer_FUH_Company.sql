---Cau 1
SELECT empSSN, empName, dbo.tblDepartment.depNum, dbo.tblDepartment.depName
FROM dbo.tblEmployee, dbo.tblDepartment
WHERE dbo.tblDepartment.depName = N'Phòng Nghiên cứu và phát triển' and dbo.tblDepartment.mgrSSN = dbo.tblEmployee.empSSN
---Cau 2
SELECT proNum, proName, depName
FROM dbo.tblProject, dbo.tblDepartment
WHERE dbo.tblDepartment.depName = N'Phòng Nghiên cứu và phát triển' and dbo.tblProject.depNum = dbo.tblDepartment.depNum 

---Cau 3
SELECT proNum, proName, depName
FROM dbo.tblProject, dbo.tblDepartment
WHERE proName = 'ProjectB' and dbo.tblProject.depNum = dbo.tblDepartment.depNum

---Cau 4
SELECT empSSN, empName
FROM dbo.tblEmployee
WHERE dbo.tblEmployee.supervisorSSN = (select dbo.tblEmployee.empSSN from dbo.tblEmployee where dbo.tblEmployee.empName = N'Mai Duy An');

---Cau 5
SELECT empSSN, empName
FROM dbo.tblEmployee
WHERE dbo.tblEmployee.empSSN = (select dbo.tblEmployee.supervisorSSN from dbo.tblEmployee where dbo.tblEmployee.empName = N'Mai Duy An');


---Cau 6
SELECT proNum, proName, dbo.tblLocation.locNum, dbo.tblLocation.locName
FROM dbo.tblLocation, dbo.tblProject
WHERE proName = N'ProjectA' and dbo.tblProject.locNum = dbo.tblLocation.locNum

SELECT *
FROM dbo.tblProject, dbo.tblLocation

---Cau 7
SELECT proName, proNum
FROM  dbo.tblProject
WHERE dbo.tblProject.locNum = (select locNum 
from dbo.tblLocation 
where dbo.tblLocation.locName=N'TP Hồ Chí Minh');

---Check
SELECT*
FROM dbo.tblWorksOn, dbo.tblProject

---Cau 8
SELECT depName, dbo.tblEmployee.empName, depBirthdate
FROM dbo.tblDependent, dbo.tblEmployee
WHERE dbo.tblDependent.empSSN = dbo.tblEmployee.empSSN and year(getdate())- year(depBirthdate) > 18

---Cau 9
SELECT dbo.tblEmployee.empName, depName, depSex, depBirthdate
FROM dbo.tblDependent, dbo.tblEmployee
WHERE dbo.tblDependent.empSSN = dbo.tblEmployee.empSSN and tblDependent.depSex = 'M';

---Cau 10
SELECT dbo.tblDepartment.depNum, depName, locName
FROM dbo.tblDepartment, dbo.tblLocation, dbo.tblDepLocation
WHERE dbo.tblDepartment.depName = N'Phòng Nghiên cứu và phát triển' and dbo.tblDepLocation.locNum = dbo.tblLocation.locNum and dbo.tblDepartment.depNum = dbo.tblDepLocation.depNum;

---Cau 11
---<cách 1>
SELECT proNum, proName, depName
FROM dbo.tblProject, dbo.tblLocation, dbo.tblDepartment
WHERE dbo.tblProject.locNum = dbo.tblLocation.locNum and dbo.tblProject.depNum = dbo.tblDepartment.depNum and dbo.tblLocation.locName = N'TP Hồ Chí Minh';

---<cách 2>
SELECT pronum, proname, depname
FROM (dbo.tblProject inner join dbo.tblDepartment on dbo.tblProject.depNum = dbo.tblDepartment.depNum)



---Cau 16
--Số lượng người phụ thuộc theo mỗi phòng ban => count
--Dùng <Employee> để kết nối bảng Department và Dependent
--Select cái gì thì groupBy cái đó
--Mã phòng ban, tên phòng ban, số lượng người phụ thuộc
SELECT d.depnum, d.depname, count(de.depname) as SNPT
FROM dbo.tblDepartment d inner join dbo.tblEmployee e on d.depNum = e.depNum inner join dbo.tblDependent de on de.empSSN = e.empSSN
GROUP BY d.depNum, d.depName

SELECT d.depnum, d.depname, count(de.depname) as SNPT
FROM dbo.tblDepartment d, dbo.tblDependent de, dbo.tblEmployee e
WHERE d.depNum = e.depNum and de.empSSN = e.empSSN
GROUP BY d.depnum, d.depName;


--Ưu tiên mã phòng ban
--Lấy depnum = 4 với SNPT = 0
SELECT d.depnum, d.depname, count(de.depname) as SNPT
FROM (dbo.tblDepartment d left outer join dbo.tblEmployee e on d.depNum = e.depNum) left outer join dbo.tblDependent de on de.empSSN = e.empSSN
GROUP BY d.depNum, d.depName;

--Where là điều kiện gộp
--Hiển thị danh sách phòng ban có số người phụ thuộc >= 2
SELECT d.depnum, d.depname, count(de.depname) as SNPT
FROM (dbo.tblDepartment d left outer join dbo.tblEmployee e on d.depNum = e.depNum) left outer join dbo.tblDependent de on de.empSSN = e.empSSN
GROUP BY d.depNum, d.depName
having count(de.depname)>=2
ORDER BY count(de.depname) asc


--Hiển thị danh sách phòng ban có số người phụ thuộc nhiều nhất
--top 1 with ties lấy các giá trị cùng lớn nhất đầu tiên
SELECT top 1 with ties d.depnum, d.depname, count(de.depname) as SNPT
FROM (dbo.tblDepartment d left outer join dbo.tblEmployee e on d.depNum = e.depNum) left outer join dbo.tblDependent de on de.empSSN = e.empSSN
GROUP BY d.depNum, d.depName
ORDER BY count(de.depname) desc


--làm đến câu 38
--12.Cho biết những người phụ thuộc là nữ giới, của nhân viên thuộc phòng ban có tên: Phòng Nghiên cứu và phát triển .
--Thông tin yêu cầu: tên nhân viên, tên người phụ thuộc, mối liên hệ giữa người phụ thuộc với nhân viên
select de.depname, empname, depRelationship
from dbo.tblDependent de, dbo.tblEmployee e, dbo.tblDepartment d
where e.empSSN = de.empSSN and e.depNum = d.depNum and d.depName = N'Phòng Nghiên cứu và phát triển' and de.depSex = 'F';

select de.depname, empname, depRelationship
from (dbo.tblDependent de inner join dbo.tblEmployee e on e.empSSN = de.empSSN) inner join dbo.tblDepartment d on e.depNum = d.depNum
where d.depName = N'Phòng Nghiên cứu và phát triển' and de.depSex = 'F';

--13.Cho biết những người phụ thuộc trên 18 tuổi, của nhân viên thuộc phòng    ban có tên: Phòng Nghiên cứu và phát triển. 
--Thông tin yêu cầu: tên nhân viên, tên người phụ thuộc, mối liên hệ giữa người phụ thuộc với nhân viên
select de.depname, empname, depRelationship, depBirthdate, year(getdate())- year(depBirthdate) as depAge
from dbo.tblDependent de, dbo.tblEmployee e, dbo.tblDepartment d
where e.empSSN = de.empSSN and e.depNum = d.depNum and d.depName = N'Phòng Nghiên cứu và phát triển' and year(getdate())- year(depBirthdate) > 18;


--14.Cho biết số lượng người phụ thuộc theo giới tính. 
--Thông tin yêu cầu: giới tính, số lượng người phụ thuộc
select de.depSex, count(de.depName) as SNPT 
from dbo.tblDependent de
group by de.depSex

--15.Cho biết số lượng người phụ thuộc theo mối liên hệ với nhân viên. 
--Thông tin yêu cầu: mối liên hệ, số lượng người phụ thuộc
select de.depRelationship, count(de.depName) as SNPT
from dbo.tblDependent de
group by de.depRelationship

--16.Cho biết số lượng người phụ thuộc theo mỗi phòng ban. 
--Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng người phụ thuộc
select d.depNum, d.depName, count(de.depName) as SNPT
from (dbo.tblDependent de inner join dbo.tblEmployee e on de.empSSN = e.empSSN) inner join dbo.tblDepartment d on d.depNum = e.depNum
group by d.depNum, d.depName

--17.Cho biết phòng ban nào có số lượng người phụ thuộc là ít nhất. 
--Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng người phụ thuộc
select top 1 with ties d.depnum, d.depname, count(de.depname) as SNPT
from (dbo.tblDependent de left outer join dbo.tblEmployee e on de.empSSN = e.empSSN) left outer join dbo.tblDepartment d on d.depNum = e.depNum
group by d.depnum, d.depname
order by count(de.depname) asc

--18.Cho biết phòng ban nào có số lượng người phụ thuộc là nhiều nhất. 
--Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng người phụ thuộc
select top 1 with ties d.depnum, d.depname, count(de.depname) as SNPT
from (dbo.tblDependent de left outer join dbo.tblEmployee e on de.empSSN = e.empSSN) left outer join dbo.tblDepartment d on d.depNum = e.depNum
group by d.depnum, d.depname
order by count(de.depname) desc

--19.Cho biết tổng số giờ tham gia dự án của mỗi nhân viên. 
--Thông tin yêu cầu: mã nhân viên, tên nhân viên, tên phòng ban của nhân viên
select e.empssn, e.empname, d.depname, sum(w.workhours) as SumWorkOn
from dbo.tblEmployee e inner join dbo.tblDepartment d on e.depNum = d.depNum
inner join dbo.tblProject p on p.depNum = d.depNum
inner join dbo.tblWorksOn w on w.proNum = p.proNum
group by e.empssn, e.empname, d.depname;

--20.Cho biết tổng số giờ làm dự án của mỗi phòng ban. 
--Thông tin yêu cầu: mã phòng ban,  tên phòng ban, tổng số giờ
SELECT d.depnum, d.depname, SUM(w.workhours) AS total_hours
FROM dbo.tblDepartment d 
inner join dbo.tblEmployee e ON d.depNum = e.depnum
inner join dbo.tblWorksOn w ON w.empSSN = e.empSSN
GROUP BY d.depnum, d.depname;

--21.Cho biết nhân viên nào có số giờ tham gia dự án là ít nhất. 
--Thông tin yêu cầu: mã nhân viên, tên nhân viên, tổng số giờ tham gia dự án
select top 1 with ties e.empssn, empname, sum(w.workhours) as total_hours
from dbo.tblEmployee e
inner join dbo.tblDepartment d on e.depNum = d.depNum
inner join dbo.tblProject p on p.depNum = d.depNum
inner join dbo.tblWorksOn w on w.empSSN = e.empSSN
group by e.empssn, empname
order by sum(w.workhours) asc

--22.Cho biết nhân viên nào có số giờ tham gia dự án là nhiều nhất. 
--Thông tin yêu cầu: mã nhân viên, tên nhân viên, tổng số giờ tham gia dự án
select top 1 with ties e.empssn, empname, sum(w.workhours) as total_hours
from dbo.tblEmployee e
inner join dbo.tblDepartment d on e.depNum = d.depNum
inner join dbo.tblProject p on p.depNum = d.depNum
inner join dbo.tblWorksOn w on w.empSSN = e.empSSN
group by e.empssn, empname
order by sum(w.workhours) desc

--23.Cho biết những nhân viên nào lần đầu tiên tham gia dụ án. 
--Thông tin yêu cầu: mã nhân viên, tên nhân viên, tên phòng ban của nhân viên
select top 1 with ties e.empssn, e.empname, d.depname, count(e.empname) as amountOfProject
from dbo.tblEmployee e
inner join dbo.tblDepartment d on e.depNum = d.depNum
inner join dbo.tblProject p on d.depnum = p.depnum
inner join dbo.tblWorksOn w on w.empSSN = e.empSSN and w.proNum = p.proNum
group by e.empssn, e.empname, d.depname
order by count(e.empname) asc


--24.Cho biết những nhân viên nào lần thứ hai tham gia dụ án. 
--Thông tin yêu cầu: mã nhân viên, tên nhân viên, tên phòng ban của nhân viên
select top 1 with ties e.empssn, e.empname, d.depname, count(e.empname) as amountOfProject
from dbo.tblEmployee e
inner join dbo.tblDepartment d on e.depNum = d.depNum
inner join dbo.tblProject p on d.depnum = p.depnum
inner join dbo.tblWorksOn w on w.empSSN = e.empSSN and w.proNum = p.proNum
group by e.empssn, e.empname, d.depname
order by count(e.empname) desc

--25.Cho biết những nhân viên nào tham gia tối thiểu hai dụ án. 
--Thông tin yêu cầu: mã nhân viên, tên nhân viên, tên phòng ban của nhân viên
select e.empssn, e.empname, d.depname, count(w.proNum) as amountOfProject
from dbo.tblEmployee e
inner join dbo.tblDepartment d on e.depNum = d.depNum
inner join dbo.tblProject p on d.depnum = p.depnum
inner join dbo.tblWorksOn w on w.empSSN = e.empSSN and w.proNum = p.proNum
group by e.empssn, e.empname, d.depname
having count(w.proNum)>=2
order by count(w.proNum) asc


--26.Cho biết số lượng thành viên của mỗi dự án. 
--Thông tin yêu cầu: mã dự án, tên dự án, số lượng thành viên'
select p.pronum, p.proname, count(e.empname) as SLTV
from dbo.tblEmployee e
inner join dbo.tblDepartment d on d.depNum = e.depNum
inner join dbo.tblProject p on p.depNum = d.depNum
group by p.pronum, p.proname

--27.Cho biết tổng số giờ làm của mỗi dự án. 
--Thông tin yêu cầu: mã dự án, tên dự án, tổng số giờ làm
select p.pronum, p.proname, sum(w.workhours) as TSGL
from dbo.tblProject p
inner join dbo.tblWorksOn w on p.proNum = w.proNum
group by p.pronum, p.proname


--28.Cho biết dự án nào có số lượng thành viên là ít nhất. 
--Thông tin yêu cầu: mã dự án, tên dự án, số lượng thành viên
select top 1 with ties p.pronum, p.proname, count(w.empSSN) as SLTV
from dbo.tblProject p
left outer join dbo.tblWorksOn w on p.pronum = w.pronum
group by p.pronum, p.proname
order by count(w.empssn) asc


--29.Cho biết dự án nào có số lượng thành viên là nhiều nhất. 
--Thông tin yêu cầu: mã dự án, tên dự án, số lượng thành viên
select top 1 with ties p.pronum, p.proname, count(w.empSSN) as SLTV
from dbo.tblProject p
left outer join dbo.tblWorksOn w on p.pronum = w.pronum
group by p.pronum, p.proname
order by count(w.empssn) desc

--30.Cho biết dự án nào có tổng số giờ làm là ít nhất. 
--Thông tin yêu cầu: mã dự án, tên dự án, tổng số giờ làm
select top 1 with ties p.pronum, p.proname, sum(w.workhours) as TSGL
from dbo.tblProject p
inner join dbo.tblWorksOn w on p.proNum = w.proNum
group by p.pronum, p.proname
order by sum(w.workhours) asc

--31.Cho biết dự án nào có tổng số giờ làm là nhiều nhất. 
--Thông tin yêu cầu: mã dự án, tên dự án, tổng số giờ làm
select top 1 with ties p.pronum, p.proname, sum(w.workhours) as TSGL
from dbo.tblProject p
inner join dbo.tblWorksOn w on p.proNum = w.proNum
group by p.pronum, p.proname
order by sum(w.workhours) desc

--32.Cho biết số lượng phòng ban làm việc theo mỗi nơi làm việc. 
--Thông tin yêu cầu: tên nơi làm việc, số lượng phòng ban
select locname, count(d.depname) as SLPB
from dbo.tblDepartment d
inner join dbo.tblDepLocation dl on d.depNum = dl.depNum
inner join dbo.tblLocation l on dl.locNum = l.locNum
group by locname

--33.Cho biết số lượng chỗ làm việc theo mỗi phòng ban. 
--Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng chỗ làm việc
select d.depnum, d.depname,count(l.locname) as SLCLV
from dbo.tblDepartment d
left outer join dbo.tblDepLocation dl on d.depNum = dl.depNum
left outer join dbo.tblLocation l on dl.locnum = l.locNum
group by d.depnum, d.depname



--34.Cho biết phòng ban nào có nhiều chỗ làm việc nhất. 
--Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng chỗ làm việc
select top 1 with ties d.depnum, d.depname,count(l.locname) as SLCLV
from dbo.tblDepartment d
left outer join dbo.tblDepLocation dl on d.depNum = dl.depNum
left outer join dbo.tblLocation l on dl.locnum = l.locNum
group by d.depnum, d.depname
order by count(l.locname) desc

--35.Cho biết phòng ban nào có it chỗ làm việc nhất. 
--Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng chỗ làm việc
select top 1 with ties d.depnum, d.depname,count(l.locname) as SLCLV
from dbo.tblDepartment d
left outer join dbo.tblDepLocation dl on d.depNum = dl.depNum
left outer join dbo.tblLocation l on dl.locnum = l.locNum
group by d.depnum, d.depname
order by count(l.locname) asc

--36.Cho biết địa điểm nào có nhiều phòng ban làm việc nhất. 
--Thông tin yêu cầu: tên nơi làm việc, số lượng phòng ban
select top 1 with ties locname, count(d.depname) as SLPB
from dbo.tblDepartment d
inner join dbo.tblDepLocation dl on d.depNum = dl.depNum
inner join dbo.tblLocation l on dl.locNum = l.locNum
group by locname
order by count(d.depname) desc 

--37.Cho biết địa điểm nào có ít phòng ban làm việc nhất. 
--Thông tin yêu cầu: tên nơi làm việc, số lượng phòng ban
select top 1 with ties locname, count(d.depname) as SLPB
from dbo.tblDepartment d
inner join dbo.tblDepLocation dl on d.depNum = dl.depNum
inner join dbo.tblLocation l on dl.locNum = l.locNum
group by locname
order by count(d.depname) asc

--38.Cho biết nhân viên nào có nhiều người phụ thuộc nhất. 
--Thông tin yêu cầu: mã số, họ tên nhân viên, số lượng người phụ thuộc
select top 1 with ties e.empssn, e.empname, count(de.depname) as SNPT
from dbo.tblEmployee e
left outer join dbo.tblDependent de  on e.empSSN = de.empSSN
group by e.empssn, e.empname
order by count(de.depname) asc


--DISTINCT dùng để in ra giá trị không trùng lặp


--40.Cho biết nhân viên nào không có người phụ thuộc.
--Thông tin yêu cầu: mã số nhân viên, họ tên nhân viên, tên phòng ban của nhân viên
select empssn, empname, depname
from dbo.tblEmployee e 
inner join dbo.tblDepartment d on e.depNum = d.depNum
where empssn not in (select empSSN from dbo.tblDependent)



--41.Cho biết phòng ban nào không có người phụ thuộc. 
--Thông tin yêu cầu: mã số phòng ban, tên phòng ban
select d.depNum,d.depName,count(de.depName) as sumDependent
from [dbo].[tblDepartment] d 
left outer join [dbo].[tblEmployee] e on d.depNum=e.depNum
left outer join [dbo].[tblDependent] de on e.empSSN=de.empSSN
group by d.depNum,d.depName
having count(de.depName)=0

--42.Cho biết những nhân viên nào chưa hề tham gia vào bất kỳ dự án nào. 
--Thông tin yêu cầu: mã số, tên nhân viên, tên phòng ban của nhân viên
select e.empssn, e.empname, d.depname, count(w.pronum) as amountOfProject
from dbo.tblEmployee e
left outer join dbo.tblDepartment d on e.depNum = d.depNum
left outer join dbo.tblProject p on d.depnum = p.depnum
left outer join dbo.tblWorksOn w on w.proNum = p.proNum and w.empSSN = e.empSSN 
group by e.empssn, e.empname, d.depname
having count(w.proNum) = 0

--43.Cho biết phòng ban không có nhân viên nào tham gia (bất kỳ) dự án. 
--Thông tin yêu cầu: mã số phòng ban, tên phòng ban
select d.depnum, depname, count(w.pronum) as SoNhanVienThamGia
from dbo.tblDepartment d
left outer join dbo.tblProject p on d.depNum = p.depNum
left outer join dbo.tblEmployee e on d.depNum = e.depNum
left outer join dbo.tblWorksOn w on w.empSSN = e.empSSN
group by d.depnum, depname
having count(w.pronum) = 0 


--44.Cho biết phòng ban không có nhân viên nào tham gia vào dự án có tên là ProjectA. 
--Thông tin yêu cầu: mã số phòng ban, tên phòng ban
select distinct d.depnum, d.depname
from dbo.tblDepartment d
where d.depnum not in (
select distinct e.depnum
from dbo.tblEmployee e
inner join dbo.tblWorksOn w on w.empSSN = e.empSSN
inner join dbo.tblProject p on p.proNum = w.proNum
where p.proname = 'ProjectA'
)

select *
from dbo.tblDepartment, dbo.tblProject


--45.Cho biết số lượng dự án được quản lý theo mỗi phòng ban. 
--Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng dự án
select distinct d.depnum, d.depname, count(p.pronum) as SLDA
from dbo.tblDepartment d 
left outer join dbo.tblProject p on p.depNum = d.depNum
group by d.depnum, d.depname


--46.Cho biết phòng ban nào quản lý it dự án nhất. 
--Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng dự án
select distinct top 1 with ties d.depnum, d.depname, count(pronum) as SLDA
from dbo.tblDepartment d
left outer join dbo.tblProject p on p.depNum = d.depNum
group by d.depnum, d.depname
order by count(pronum) asc

--47.Cho biết phòng ban nào quản lý nhiều dự án nhất. 
--Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng dự án
select distinct top 1 with ties d.depnum, d.depname, count(pronum) as SLDA
from dbo.tblDepartment d
left outer join dbo.tblProject p on p.depNum = d.depNum
group by d.depnum, d.depname
order by count(pronum) desc

--48.Cho biết những phòng ban nào có nhiểu hơn 5 nhân viên đang quản lý dự án gì. 
--Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng nhân viên của phòng ban, tên dự án quản lý
select d.depnum, d.depname, count(d.depnum) as SLNV, proname
from dbo.tblDepartment d
left outer join dbo.tblEmployee e on e.depNum = d.depNum
left outer join dbo.tblProject p on d.depNum = p.depNum
group by d.depnum, d.depname, proname
having count(d.depnum) >= 5

select *
from dbo.tblDepartment, dbo.tblProject, dbo.tblEmployee, dbo.tblWorksOn

--49.Cho biết những nhân viên thuộc phòng có tên là Phòng nghiên cứu, và không có người phụ thuộc. 
--Thông tin yêu cầu: mã nhân viên,họ tên nhân viên
select empssn, empname, depname
from dbo.tblEmployee e 
inner join dbo.tblDepartment d on e.depNum = d.depNum
where empssn not in (select empSSN from dbo.tblDependent) and depname = N'Phòng nghiên cứu và phát triển'

select E.empSSN, E.empName
from [dbo].[tblEmployee] E left outer join [dbo].[tblDepartment] DP on E.depNum=DP.depNum
left join [dbo].[tblDependent] DE on E.empSSN=DE.empSSN
where DP.depName=N'Phòng Nghiên cứu và phát triển' and DE.depName is null

--50.Cho biết tổng số giờ làm của các nhân viên, mà các nhân viên này không có người phụ thuộc. 
--Thông tin yêu cầu: mã nhân viên,họ tên nhân viên, tổng số giờ làm
select e.empssn, empname, depname, sum(w.workhours) as TSGL
from dbo.tblEmployee e 
left outer join dbo.tblDepartment d on e.depNum = d.depNum
left outer join dbo.tblWorksOn w on e.empSSN = w.empssn
where e.empssn not in (select empSSN from dbo.tblDependent)
group by e.empssn, empname, depname

--51.Cho biết tổng số giờ làm của các nhân viên, mà các nhân viên này có nhiều hơn 3 người phụ thuộc. 
--Thông tin yêu cầu: mã nhân viên,họ tên nhân viên, số lượng người phụ thuộc, tổng số giờ làm
select e.empssn, e.empname, count(de.depname) as SNPT, sum(w.workhours) as TSGL
from dbo.tblEmployee e
left outer join dbo.tblDependent de on e.empssn = de.empSSN
left outer join dbo.tblWorksOn w on e.empSSN = w.empSSN
group by e.empssn, e.empname
having count(de.depname) >= 3

--52.Cho biết tổng số giờ làm việc của các nhân viên hiện đang dưới quyền giám sát (bị quản lý bởi) của nhân viên Mai Duy An. 
--Thông tin yêu cầu: mã nhân viên, họ tên nhân viên, tổng số giờ làm
select e.empssn, e.empname, sum(w.workhours) as TSGL
from dbo.tblEmployee e
left outer join dbo.tblDependent de on de.empSSN = e.empSSN
left outer join dbo.tblWorksOn w on w.empSSN = e.empSSN
where e.supervisorSSN in (select empssn from dbo.tblEmployee where empname = N'Mai Duy An')
group by e.empssn, e.empname
