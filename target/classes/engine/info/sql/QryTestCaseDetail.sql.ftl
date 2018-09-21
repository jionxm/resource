select * from (
		SELECT
		i.id as issueId,
		i.title as issueName, 
		i.proj_id as projId,
		i.sprint_id as sprintId,
		tc.id as testcaseId,
		'bug' as type,
		i.test_design_by as testDesignBy,
		i.test_by as testBy,
		i.assignee as assignee,
		e2.name as assigneeName,
		i.workload as workload,
		'open' as status,
		i.reporter as reporter,
			tc.id as id,
			tc.name as name,
			d.name as levelName,
			d.code as level,
			tc.precondition,
			d2.`name` as lastResultName,
			d2.`code` as lastResult,
			e.name as createByName,
			e.id as createBy,
			tc.create_time as createTime,
			e1.name as updateByName,
			e1.id as updateBy,
			tc.update_time as updateTime
		FROM
			t_testcase tc
		LEFT JOIN t_issue i ON i.id = tc.issue_id
		LEFT JOIN t_dict d ON d.code = tc. LEVEL  and d.CATA_CODE='T_TESTCASE.LEVEL'
		LEFT JOIN t_dict d2 ON d2.code = tc. last_result  and d2.CATA_CODE='t_testcase_record.result'
		LEFT JOIN t_employee e ON tc.create_by = e.id
		LEFT JOIN t_employee e1 ON tc.update_by = e1.id
		LEFT JOIN t_employee e2 ON i.assignee = e2.id

 ) a 