select * from (
	select 
	t.id as id,
	t.name as name,
	o.name AS orgName
	from t_employee t
	LEFT JOIN t_org o on t.org_id = o.id
 ) a 