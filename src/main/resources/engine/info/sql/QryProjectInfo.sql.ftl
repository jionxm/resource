select * from (
    SELECT
    p.id ,
    p.name,
    p.create_by as createBy,
    p.update_by as updateBy,
    p.status,
    d.name  AS statusName,
    e.name  AS createByName,
    em.name AS updateByName,
    p.create_time as createTime,
    p.update_time as updateTime,
    p.description
    FROM t_project p
    LEFT JOIN t_dict d
    ON p.status = d.code
    LEFT JOIN t_employee e
    ON p.create_by = e.id
    LEFT JOIN t_employee em
    ON p.update_by = em.id
    where d.cata_code = 't_project.status'
) a