select * from (
	select 
	proj_id as id,
	id as value,
	name as text from t_sprint 
 ) a