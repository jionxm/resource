select * from (
	select 
  p.id as id,
  d1.`code` as code,
  p.value as pvalue,
	j.description,
	p.job_id as jobId
  from t_schedule_param p
  left join t_schedule_job j on j.id=p.job_id
  left join t_dict d1 on d1.cata_code='t_schedule_param.name' and p.`name`=d1.`code`
 ) a 