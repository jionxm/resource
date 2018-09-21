select * from (
		SELECT
		i.testcase_id as testcaseId,
			i.create_time as createTime,
			i.title as title,
			e.name as testByName
		FROM
			t_issue i
		LEFT JOIN t_employee e ON i.reporter= e.id
	
 ) a 