insert into t_exp_course
 (  system_code,
 	course_id,
 	system_name,
 	course_name,
 	version_id,
 	version_name,
 	stage_id,
 	stage_name,
 	update_time,
 	update_count
 ) 
values
 (	#{data.systemCode},
 	#{data.courseId},
 	#{data.systemName},
 	#{data.courseName},
 	#{data.versionId},
 	#{data.versionName},
 	#{data.stageId},
 	#{data.stageName},
 	now(),1
 )
