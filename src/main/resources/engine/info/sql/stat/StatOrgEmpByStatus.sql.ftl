select * from (
    SELECT
    *
    FROM
    (
    SELECT
    case when o.name is null or o.name = '' then  '无部门' else   o.name end  as orgName,
    d.name as status,
    count(e.id) AS
    empCnt
    FROM
    t_employee e
    LEFT JOIN  t_org o ON o.id = e.org_id
    inner join t_dict d ON e.`status` = d.CODE
    GROUP BY
    o.name,d.name
    ) org_emp
    WHERE
    empCnt
    > 0
) a