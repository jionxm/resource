select * from (
	select concat(pid,id),
	id as id,
	pid as pid,
	name as text
	from t_tree
ORDER BY concat(pid,id)
 ) a 