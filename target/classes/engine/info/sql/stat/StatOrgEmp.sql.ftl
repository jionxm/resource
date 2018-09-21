select * from (
    SELECT
    *
    FROM
    (
    SELECT
    o.name as orgName,
    count( e.id ) AS
    empCnt
    FROM
    t_org o
    LEFT JOIN t_employee e ON o.id = e.org_id
    GROUP BY
    o.name
    ) org_emp
    WHERE
    empCnt
    > 0
) a