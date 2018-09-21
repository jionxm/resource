select * from (
        SELECT
        *
        FROM
        (
        SELECT
        case when p.name is null then '未指派职位' else p.name end as postName,
        count( e.id )
        as empCnt
        FROM t_employee e
        LEFT JOIN t_position p
        ON p.id = e.position_id
        GROUP BY
        p.name
        ) post_emp
        WHERE
        empCnt
        >= 0
) a