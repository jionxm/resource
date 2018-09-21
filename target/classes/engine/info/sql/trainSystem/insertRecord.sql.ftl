insert into t_train_course_record
(result_id,start_time,end_time,update_by,update_time)
values (#{data.resultId},#{data.startTime},now(),#{data.traineeBy},now())