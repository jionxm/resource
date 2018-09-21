select * from (
select 
    t.id,
    ttf.trainee_id from t_trainee_file ttf
    left join t_train_file t on t.train_course_id = ttf.train_file_id
    where   train_file_id = #{data.courseId}
) a 
 
