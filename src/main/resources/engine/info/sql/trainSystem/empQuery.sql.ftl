select *  from (
	select cata.id as id,
	       cata.name as name,
	       emp.name as createBy,
	       emp1.name as updateBy,
	       cata.create_time as createTime,
	       cata.update_time as updateTime
	from t_tain_course_cata cata
	left join t_train_course course on course.train_course_cata_id=cata.id
	left join t_employee emp on emp.id=cata.create_by
	left join t_employee emp1 on emp1.id=cata.update_by
) a
