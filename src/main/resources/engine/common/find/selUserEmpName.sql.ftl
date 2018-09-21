select * from (
	select 
	a.id,
	a.name,
	o.name as orgName 
  from t_employee a 
  left join t_user b on a.id = b.emp_id 
	left join t_org o on a.org_id=o.id where 
	a.status not in ('unavailable','dimission') and 
	a.id not in (select emp_id from t_user) order by o.name,a.name
 ) a 
