select *  from (
	select
	tfile.id as id,
	t.id as traineeId,
	course.id as trainFileId,
	t.name as traineeName,	
	tfile.state as state,
	course.name as trainStudyName
	from t_trainee_file tfile
	left join t_employee t on t.id=tfile.trainee_id
	left join t_train_course course on course.id=tfile.train_file_id
) a
