select *  from (
	SELECT 
	log.id AS id,
	log.trainee_id AS traineeId, 
	course.id AS courseId, 
	log.train_file_id AS trainFileId, 
	log.start_time AS startTime, 
	log.end_time AS endTime, 
	log.sum_time AS sumTime, 
	e.name AS traineeName, 
	course.name AS trainCourseName, 
	file.name AS trainFileName,
	file.expect_study_time as expectStudyTime,
	CONCAT(round(log.sum_time / file.expect_study_time *100,2),'%')as resolvePercent
	FROM t_train_course_result log
	LEFT JOIN t_employee e on e.id = log.trainee_id
	LEFT JOIN t_train_file file ON file.id = log.train_file_id
	LEFT JOIN t_train_course course ON course.id = file.train_course_id
) a
