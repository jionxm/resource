select * from (
    SELECT
    *
    FROM
    (
    SELECT
    p.id as projId,
    p.name as projectName,
    count( e.id ) AS empCnt
    FROM
    t_project p
    INNER join t_proj_emp pm on p.id = pm.proj_id
    LEFT JOIN t_employee e ON pm.emp_id = e.id
    where p.status = 'open'
    GROUP BY
    p.name,p.id
    ) pro_emp
    where
    empCnt >= 0
) a