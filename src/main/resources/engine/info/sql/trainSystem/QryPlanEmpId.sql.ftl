select * from (
   select emp_id from t_train_plan_emp
   where plan_id = #{data.planId}
) a 
 
