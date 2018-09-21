select * from (
select 
    ttp.id as id,
    ttp.title as title,
    ttp.context as context,
    ttp.create_by as createBy,
    ttp.create_time as createTime,
    ttp.update_by as updateBy,
    ttp.update_time as updateTime,
    e1.name as createByName,
    e2.name as updateByName
   
from t_train_plan ttp
left join t_employee e1 on e1.id = ttp.create_by
left join t_employee e2 on e2.id = ttp.update_by
) a 
 
