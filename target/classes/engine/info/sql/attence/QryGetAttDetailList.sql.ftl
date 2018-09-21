select * from 
(select c.userId,c.userName,c.commitDay,c.commitHours,c.submitTime as createTime,c.projId,acd.attence_day,acd.attence_id ,tch.id,
DATE_FORMAT(tch.start_time,'%Y-%m-%d') startTime,DATE_FORMAT(tch.end_time,'%Y-%m-%d') endTime,
	pro.`name` as projName  ,acd.id as acdId
 from 
(
select 
	e.id as userId,
	e.`name` as userName,
	case when a.subNum is null then 0 else a.subNum end as commitDay,
	case when a.workHours is null then 0 else a.workHours end as commitHours,
	a.submitTime as submitTime ,
	a.projId as projId
	from t_employee e
	left join 
(
	select 
	count(w.id) as subNum,
	hours as workHours,
	submit_by as submitBy ,
	DATE_FORMAT(submit_time,'%Y-%m-%d') as submitTime,
	de.project_id as projId
from t_worklog  w 
left join t_worklog_detail  de on w.id = de.work_id 
where w.exam_res = '2'
/*and w.submit_time >= '2017-12-01' and w.submit_time <= '2017-12-27'*/
group by  submit_by,DATE_FORMAT(submit_time,'%Y-%m-%d'),de.project_id
)a  on e.id = a.submitBy
/*where e.org_id = '299' */
order by a.subNum desc 
)c
left join t_attence_check_detail acd on c.userId = acd.user_id 
left join t_attence_check tch on tch.id = acd.attence_id
left join t_project pro on pro.id = c.projId 
where acd.id = #{data.acdId}
and acd.attence_id = (select attence_id from t_attence_check_detail where id =  #{data.acdId})
and c.submitTime >= DATE_FORMAT(tch.start_time,'%Y-%m-%d')
and c.submitTime <= DATE_FORMAT(tch.end_time,'%Y-%m-%d')

)M