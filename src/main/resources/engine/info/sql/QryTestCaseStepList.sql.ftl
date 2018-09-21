select * from (
SELECT tp.number AS number,
tp.id as id,
tp.testcase_id as testcaseId,
tp.`description` AS `description`,
tp.expect_result as expectResult
 from t_testcase_step tp
 ) a 