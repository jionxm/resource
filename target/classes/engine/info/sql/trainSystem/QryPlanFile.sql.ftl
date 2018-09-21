select * from (
   select id from t_train_file
   where train_course_id = #{data.courseId}
) a 
 
