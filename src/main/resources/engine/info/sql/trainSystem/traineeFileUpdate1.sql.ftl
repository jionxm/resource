update  t_trainee_file  set state='doing'
where train_file_id=#{data.id} and trainee_id=#{data.traineeBy}
