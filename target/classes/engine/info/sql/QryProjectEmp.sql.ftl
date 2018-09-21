select * from (
    select
    pe.id,
    pe.proj_id as proId,
    e.name as empName,
    e.code as empCode,
    o.name as orgName,
    e.mobile ,
    e.email,
    pe.create_time as joinTime,
    e1.name as joinByName
    FROM t_proj_emp pe
    LEFT JOIN t_employee e
    on pe.emp_id =e.Id
    LEFT JOIN t_org o
    on e.org_id=o.id
    LEFT JOIN t_employee e1
    on pe.create_by  = e1.id
) a