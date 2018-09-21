Update t_exp_course
 set system_code=#{data.systemCode},
 	course_id=#{data.courseId},
 	system_name=#{data.systemName},
 	course_name=#{data.courseName},
 	version_id=#{data.versionId},
 	version_name=#{data.versionName},
 	stage_id=#{data.stageId},
 	stage_name=#{data.stageName},
 	update_time=now(),
 	update_count=#{data.updateCount}
 where id = #{data.id}