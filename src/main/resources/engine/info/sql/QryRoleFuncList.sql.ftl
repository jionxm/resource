select * from (
select a.id,a.role_id as roleId,a.func_id as funcId,b.name,b.description ,
a.create_time as createTime,a.create_by as createBy,r.name as roleName,userCount 
,a.data_auth as dataAuth,d1.name as dataAuthName ,e.name as createByName 
from t_role_func a  
left join t_role r on a.role_id=r.id 
left join (select role_id,count(1) as userCount from t_user_role group by role_id) ur on r.id = ur.role_id 
left join t_function b on a.func_id=b.id
left join t_employee e on a.create_by=e.id
left join t_dict d1 on a.data_auth=d1.code and d1.cata_code='t_role_func.data_auth'
 ) a 