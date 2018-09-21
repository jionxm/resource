select * from (
    SELECT
    *
    FROM
    (
    SELECT
    d.name as status,
    count(e.id ) as empCnt
    FROM
    t_employee e
    LEFT JOIN t_dict d ON e.`status` = d.CODE
    WHERE
    d.cata_code = 't_employee.status'
    GROUP BY
    d.name
    ) emp_status
) a