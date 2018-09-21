select * from (
	select  
	r.id,
	r.name
 	from t_role r
left join (select * from t_role_func where func_id=#{data.id}) rf on  r.id=rf.role_id 
where rf.role_id is null 
) a 