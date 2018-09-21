select *  from (
	select tp.id as id,
	ttc.id as courseId,
	ttc.name as courseIdName,
	tt1.name as createByName,
	tp.create_by as createBy,
	tp.content as content,
	tp.create_time as createTime
	from t_post tp 
	left join t_train_course ttc on tp.course_id=ttc.id
	left join t_employee tt1 on tp.create_by=tt1.id       
) a 


