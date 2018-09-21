select * from 
(
select 
	a.id as Id,
	a.title as title,
	DATE_FORMAT(a.start_time,'%Y-%m-%d') as startTime,
	DATE_FORMAT(a.end_time,'%Y-%m-%d') as endTime,
	o.`name` as empId,
	o.`name` as empName,
	a.create_by as createBy,
	e.`name` as createByName,
	a.remark as reamark,
	a.check_status as isCheck,
	case when a.check_status = '2' then '通过' 
	when a.check_status = '1' then '未通过'
	else '未考核' end 
	as checkStatus
from 
t_attence_check a 
left join t_org o on a.emp_id = o.id 
LEFT JOIN t_employee e on a.create_by = e.id
where DATE_FORMAT(a.start_time,'%Y-%m-%d') >= #{data.startTime}
and DATE_FORMAT(a.end_time,'%Y-%m-%d') <= #{data.endTime}
)b