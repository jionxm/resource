select * from (
select a.role_id as roleId,a.func_id as funcId,b.name ,b.description 
from t_role_func1 a 
left join t_function1 b on a.func_id = b.func_id 
left join t_employee e1 ON a.update_by=e1.emp_id  
left join t_employee e2 ON a.create_by=e2.emp_id  
 ) a 