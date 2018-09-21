select * from (
	select  
	r.id,
	r.name
 	from t_role r
left join (select * from t_user_role where user_id=#{data.id}) rf on  r.id=rf.role_id 
where rf.role_id is null 
) a 