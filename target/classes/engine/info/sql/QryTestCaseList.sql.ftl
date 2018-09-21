
select * from (
		SELECT
			tc.id as id,
			tc.issue_id as issueId,
			tc.`name` as name,
			d.name as levelName,
			d.`code` as level,
			tc.last_result as lastResult,
			tc.create_time as createTime,
			e.name as createByName,
			e.id as createBy,
			tc.update_time as updateTime,
			e1.name as updateByName,
			d1.name as lastResultName,
			i.title as title,
            i.proj_id as projId,
			tc.create_time
		FROM
			t_testcase tc
		LEFT JOIN t_issue i ON i.id = tc.issue_id
		LEFT JOIN t_dict d ON d.code = tc. LEVEL  and d.CATA_CODE='T_TESTCASE.LEVEL'
		LEFT JOIN t_employee e ON tc.create_by = e.id
		LEFT JOIN t_employee e1 ON tc.update_by = e1.id
		LEFT JOIN t_dict d1 ON d1.code = tc.last_result and d1.CATA_CODE='T_TESTCASE_RECORD.RESULT'

 ) a 