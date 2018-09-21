select * from (
	select 
	m.name as parentName,
	m.id as parent,
	m.id
	from t_resource as m
 ) a 