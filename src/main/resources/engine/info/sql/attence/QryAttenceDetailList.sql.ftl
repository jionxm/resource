select * from 
(
select 
	e.id as userId,
	e.`name` as userName,
	case when a.subNum is null then 0 else a.subNum end as commitDay,
	case when a.workHours is null then 0 else a.workHours end as commitHours
	from t_employee e
	left join 
(
	select 
	count(id) as subNum,
	sum(hours) as workHours,
	submit_by as submitBy 
from t_worklog  w 
where w.exam_res = '2'
and w.submit_time >= #{data.startTime} and w.submit_time <= #{data.endTime}
group by  submit_by
)a  on e.id = a.submitBy
where e.org_id = #{data.empId}
order by a.subNum desc 
)c