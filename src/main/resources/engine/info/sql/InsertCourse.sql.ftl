insert into t_train_course_result
(trainee_id,train_file_id,sum_time,state)
values (#{data.traineeId},#{data.fileId},0,'NoStart')