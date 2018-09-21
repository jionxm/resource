select * from (
	select  
	u.id,
	u.name
 	from t_user u
left join (select * from t_user_role where role_id=#{data.id}) ur on  u.id=ur.user_id 
where ur.user_id is null 
) a 