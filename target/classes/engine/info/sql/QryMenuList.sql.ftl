select * from (
	select concat(parent,code),
	code as code,
	code as id,
	parent as parent,
	name as text
	from t_menu
ORDER BY seq
 ) a 