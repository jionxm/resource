select * from (
select u.id as userId,ur.role_id as roleId,b.name ,b.description as description,
rf.create_time as createTime,rf.create_by as createBy,
e.name as createByName ,rf.create_time as updateTime,a.url
from t_user u 
left join t_user_role ur on u.id = ur.user_id 
left join t_role_func rf on ur.role_id=rf.role_id  
left join t_function b on rf.func_id=b.id
left join t_employee e on rf.create_by=e.id 
left join t_res_func z on rf.func_id=z.func_id
left join t_resource a on z.res_id=a.id 
left join t_resource g on a.parent=g.id
where b.id is not null
 ) a 