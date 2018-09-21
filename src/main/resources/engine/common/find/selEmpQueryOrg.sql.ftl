select * from (
	select 
	o.id as id,
	o.name as name,
	o1.name   as upOrgName,
	o.manager_id as managerId
	from t_org o 
	left join t_org o1 on o1.id = o.pid
 ) a 