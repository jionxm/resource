select * from (
	select 
	case when isnull(j.name)
	then '数据库定时任务刷新'
	else
	j.name
	end  as name,
	l.id as id,
	l.create_time as createTime,
	l.cost as cost,
 	d1.code as type,
 	d2.code as concurrent,
	l.param as param,
	l.result as result
	from t_job_log l
	left join t_schedule_job j on j.id=l.job_id
	left join t_dict d1 on d1.code=l.type and d1.cata_code='t_schedule_job.type'
	left join t_dict d2 on d2.code=l.concurrent and d2.cata_code='t_schedule_job.concurrent' 
	
 ) a 