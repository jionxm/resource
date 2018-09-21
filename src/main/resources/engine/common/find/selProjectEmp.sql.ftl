select * from (
SELECT
e.id,
e.code,
e.name,
o.name as orgName
FROM
t_employee e inner join t_org o on e.org_id = o.id
WHERE e.id
NOT IN (SELECT emp_id
FROM t_proj_emp p
WHERE p.proj_id = (#{data.id}))
order by o.name,e.name
) a