
update  t_train_course_result  set start_time =now(),state='end'
where train_file_id=#{data.id} and trainee_id=#{data.traineeBy} and plan_id=#{data.eq_planId}

