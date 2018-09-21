select * from (
	select 
	CODE as value,
	NAME as text from t_dict WHERE cata_code='T_TESTCASE_RECORD.RESULT'
 ) a