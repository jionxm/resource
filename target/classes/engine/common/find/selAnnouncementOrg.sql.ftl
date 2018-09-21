select * from (
	select DISTINCT 
	o.id as orgId,o.name as orgName
	from t_org o
	left join t_employee e
	on o.id=e.org_id
	order by orgId,orgName
 ) a 