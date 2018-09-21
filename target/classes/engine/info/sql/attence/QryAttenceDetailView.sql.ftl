select * from 
(
select 
	wd.project_id as projId,
	tw.submit_by as userId,
	te.`name` as userName,
	DATE_FORMAT(tw.submit_time,'%Y-%m-%d') as createTime,
	tw.hours as commitHours,tp.`name` as projName  
	from t_worklog_detail wd
left join t_worklog tw on wd.work_id = tw.id
left join t_project tp on wd.project_id = tp.id
left join t_employee te on te.id = tw.submit_by 
where 1=1 
/*DATE_FORMAT(tw.submit_time,'%Y-%m-%d') >= #{data.createTime}
	  and DATE_FORMAT(tw.submit_time,'%Y-%m-%d') <= #{data.createTime}*/
and tw.exam_res = '2'
group by project_id,tw.submit_by,DATE_FORMAT(tw.submit_time,'%Y-%m-%d') 
)c