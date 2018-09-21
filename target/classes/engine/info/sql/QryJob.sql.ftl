select * from (
	select 
  j.id as id,
  j.name as name,
  j.status as status,
  j.cron_expression cronExpression,
  j.concurrent as concurrent,
  j.type as type,
  j.description as description,
  j.create_time as createTime,
  j.create_by as createBy,
  j.update_time as updateTime,
  j.update_by as updateBy
  from t_schedule_job j
 ) a 