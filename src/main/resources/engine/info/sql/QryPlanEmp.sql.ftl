select * from (
select 
    ttpe.id as id,
    ttpe.plan_id as planId,
    ttpe.emp_id as empId,
    ttpe.create_time as createTime,
    ttpe.update_time as updateTime,
    e.name as name,
    e.mobile as mobile,
    e1.name as createByName,
    e2.name as updateByName,
    g.name as orgName
    
    from t_train_plan_emp ttpe
    left join t_employee e on e.id = ttpe.emp_id
    left join t_employee e1 on e1.id = ttpe.create_by
    left join t_employee e2 on e2.id = ttpe.update_by
    left join t_org g on g.id = e.org_id
    where  ttpe.plan_id = #{data.ctlPlanId}
) a 
 
