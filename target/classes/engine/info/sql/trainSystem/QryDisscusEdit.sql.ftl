select *  from (
	select tp.id as id,
	ttc.name as courseIdName,
	tp.create_by as createBy,
	te.name as createByName,
	tp.content as content
	from t_post tp 
	left join t_train_course ttc on tp.course_id=ttc.id 
	left join t_employee te on te.id =tp.create_by 
) a 

