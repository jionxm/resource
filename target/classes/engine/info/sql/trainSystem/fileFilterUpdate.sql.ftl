
update  t_train_course_result  set end_time =now(),state='start'
where train_file_id=#{data.id} and trainee_id=#{data.traineeBy} and plan_id=#{data.planId}

