select * from (
	select 
	a.id,
	a.name,
	o.name as orgName 
  from t_employee a 
	left join t_org o on a.org_id=o.id where a.id<>#{data.id}
 ) a 