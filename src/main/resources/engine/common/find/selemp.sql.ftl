select * from (
	select 
	e.ID as id,
	e.NAME as name,
	o.`name` as oName,
	e.email as email,
    e.code as code
	 from t_employee e
	 LEFT JOIN t_org o ON o.id=e.org_id
ORDER BY e.org_id, e.`name`
 ) a 