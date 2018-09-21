select * from (
   select plan_id,course_id from t_train_plan_course
   where id = #{data.id}
) a 
 
