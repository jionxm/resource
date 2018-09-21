select * from (
	select concat(pid,id),
	id as id,
	pid as pid,
	name as text
	from t_org
ORDER BY concat(pid,id)
 ) a 