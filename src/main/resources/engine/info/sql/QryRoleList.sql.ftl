select * from (
	select 
	r.id,
	r.name,
	r.description,
	e1.name as updateByName,
	e2.name as createByName,
	r.update_by as updateBy,
	r.create_by as createBy,
	r.update_time as updateTime,
	r.create_time as createTime,  
	ifnull(r.update_count,1) as updateCount 
	from t_role r  
  LEFT OUTER JOIN t_employee e1 ON r.update_by=e1.id  
	LEFT OUTER JOIN t_employee e2 ON r.create_by=e2.id  
 ) a 