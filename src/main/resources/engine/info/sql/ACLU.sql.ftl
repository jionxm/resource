select * from (
select distinct res.url,res.name,rf.data_auth as dataAuth from t_user_role ur 
left join t_user u on ur.user_id = u.id 
left join t_role_func rf on ur.role_id=rf.role_id 
left join t_res_func rsf on rf.func_id = rsf.func_id 
left join t_resource res on rsf.res_id = res.id 
where res.is_auth=1 and type<>'component' and url is not null and u.name=#{data.session.userInfo.userName} 
)  a 
union 
select * from (
	select url,name,'' as  dataAuth from t_resource where is_auth=0 and url is not null and type<>'component'
)  b 
