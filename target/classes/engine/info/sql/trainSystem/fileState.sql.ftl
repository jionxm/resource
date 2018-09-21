
update  t_train_course_result  set state='end'
where train_file_id=#{data.id} and trainee_id=#{data.traineeBy}

