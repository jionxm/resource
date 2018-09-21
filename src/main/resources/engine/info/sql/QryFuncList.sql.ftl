select * from (
select f.id,f.name ,f.description as description,
f.create_time as createTime,f.create_by as createBy,
e.name as createByName ,f.update_time as updateTime ,e2.name as updateByName
from t_function f 
left join t_employee e on f.create_by=e.id
left join t_employee e2 on f.update_by=e2.id

 ) a 