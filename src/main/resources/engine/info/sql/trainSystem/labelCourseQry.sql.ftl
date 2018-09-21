select *  from (
	select 
		lc.id as id,
		l.id as labelId,
		c.id as courseId,
		l.name as labelName,
		c.name as courseName,
		l.update_by as updateBy,
		l.update_time as updateTime
	from t_train_label_course lc
	left join t_train_course_label l on l.id=lc.train_course_label_id
	left join t_train_course c on c.id=lc.train_course_id
) a
