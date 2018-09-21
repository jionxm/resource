select * from (
   select course_id from t_train_plan_course
   where plan_id = #{data.planId}
) a 
 
