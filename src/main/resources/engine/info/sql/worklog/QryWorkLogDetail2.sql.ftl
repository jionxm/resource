SELECT
	*
FROM
	(
		SELECT
			t.id AS Id,
			t.id AS workid,
			t.remark AS remark,
			e1.name as submitByName
	FROM
		t_worklog t
		left join t_employee e1 on e1.id = t.submit_by  
	) a