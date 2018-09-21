select * from (
	select  
	r.id,
	r.name,
	r.url 
 	from t_resource r 
left join (select * from t_res_func where func_id=#{data.id}) rf on  r.id=rf.res_id  
where rf.res_id   is null and r.Is_auth=1
) a 