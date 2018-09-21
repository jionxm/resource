select * from (
select distinct u.name as userName,res.url,res.name,case when type='component' then 'c' else 'u' end as  type from t_user_role ur 
left join t_user u on ur.user_id = u.id 
left join t_role_func rf on ur.role_id=rf.role_id 
left join t_res_func rsf on rf.func_id = rsf.func_id 
left join t_resource res on rsf.res_id = res.id 
where  u.name is not null 
)  a 