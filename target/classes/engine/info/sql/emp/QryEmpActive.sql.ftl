select * from (
SELECT
	e.code as code,
	e.name as name,
	o.name as orgName,
	d1.name as genderName,
	e.mobile as moblie,
	e.email as email,
	d2.name as typeName,
	max(l.update_time) as lastTime
	
FROM
	t_issue_log l
	LEFT JOIN t_employee e on e.id = l.update_by
	LEFT JOIN t_org o on o.id = e.org_id
	LEFT JOIN t_dict d1 on e.gender=d1.code and d1.cata_code = 't_employee.gender'
	LEFT JOIN t_dict d2 on e.type=d2.code and d2.cata_code = 't_employee.type'
WHERE
	l.update_by IS NOT NULL and  e.status not in ('reserve','unavailable','dimission')
GROUP BY
	l.update_by
 ) a 