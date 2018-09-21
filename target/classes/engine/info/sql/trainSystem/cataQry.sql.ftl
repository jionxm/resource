select *  from (
	select case when (select count(f.id) from t_train_label_course f where f.train_course_label_id =cata.id) >=1 then 0 else 1 end as det,
		   cata.id as id,
	       cata.name as name,
	       cata.create_by as createBy,
	       cata.update_by as updateBy,
	       emp.name as createByName,
	       emp1.name as updateByName,
	       cata.create_time as createTime,
	       cata.update_time as updateTime
	from t_train_course_label cata
	left join t_employee emp on emp.id=cata.create_by
	left join t_employee emp1 on emp1.id=cata.update_by
) a
