#包含所有资源,id不为-1的或不在此列表中的为用户可访问资源
select a.url,ifnull(b.id,'-1') as id,dataAuth from t_resource a 
left join (
select id,url,name,dataAuth from (
select distinct res.id,res.url,res.name,rf.data_auth as dataAuth  from t_user_role ur 
left join t_user u on ur.user_id = u.id 
left join t_role_func rf on ur.role_id=rf.role_id 
left join t_res_func rsf on rf.func_id = rsf.func_id 
left join t_resource res on rsf.res_id = res.id 
where  u.name is not null and type='component' and u.name=#{data.session.userInfo.userName} 
)  a   
union  
select * from (
select id,url,name,'' as dataAuth from t_resource where type='component' and (is_auth is null or is_auth=0) 
)  a ) b on a.id = b.id where a.type='component' 