select * from (
		SELECT
			tcr.id as id,
			tcr.testcase_id as testcaseId,
			tcr.CREATE_TIME as createTime,
			d. NAME as resultName,
			e.name as createByName,
			tc.`name` as `name`,
			tc.`level` AS `level`,
			tc.precondition AS precondition,
			tc.last_result AS lastResult
			
		FROM
			T_TESTCASE_RECORD tcr
		LEFT JOIN t_testcase tc ON tc.id=tcr.testcase_id
		LEFT JOIN t_dict d ON d. CODE = tcr.result
		AND d.CATA_CODE = 'T_TESTCASE_RECORD.RESULT'
		LEFT JOIN T_EMPLOYEE e ON tcr.create_by = e.id
 ) a 