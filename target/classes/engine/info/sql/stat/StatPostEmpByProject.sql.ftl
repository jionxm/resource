select * from (

    select p.id as projId,
    case when c.postName is null then  '未指派职位' else   c.postName end as postName,
    c.empCnt
    from  t_project p left join 	(
    select t.name as postName, pe.proj_id,
    count(e.id) as empCnt
    from  t_proj_emp pe
    inner join t_employee e on pe.emp_id = e.id
    Left join t_position t on t.id = e.position_id
    GROUP BY t.name ,pe.proj_id
    ) c on p.id = c.proj_id
    where empCnt > 0
) a