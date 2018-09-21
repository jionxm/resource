select * from (
	select concat(parent,id),
	id as id,
	parent as parent,
	name as text
	from t_resource
ORDER BY concat(parent,id)
 ) a 