select * from (
	select  
	f.id,
	f.name,f.description as remark 
 	from t_function f
left join (select * from t_role_func where role_id=#{data.id}) rf on  f.id=rf.func_id 
where rf.func_id is null order by convert(f.name USING gbk) 
) a 
