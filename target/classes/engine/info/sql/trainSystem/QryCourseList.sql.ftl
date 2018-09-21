select * from (
select case when (select count(f.id) from t_train_file f where f.train_course_id =tc.id) >=1 then 0 else 1 end as det,
	tc.id as id,
	tc.name as name,
	tc.train_course_introduction as courseIntroduction,
	tc.create_time as createTime,
	e.id as createBy,
	e.name as createByName,
	tc.update_time as updateTime,
	e1.id as updateBy,
	e1.name as updateByName
	FROM t_train_course tc
LEFT JOIN t_employee e on e.id = tc.create_by
LEFT JOIN t_employee e1 on e1.id = tc.update_by 
) a 
 
