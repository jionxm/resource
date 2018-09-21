select * from (
	select 
	m.name as name,
	m.id as id,
	m.url as url,
	m.parent as parent,
	m2.name as parentName,
	m.type as parentType,
	m.is_auth as isAuth,
	m.type as type
	from t_resource as m
	left join t_resource as m2 on m2.id=m.parent
 ) a 