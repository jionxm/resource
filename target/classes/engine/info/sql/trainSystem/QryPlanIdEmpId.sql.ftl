select * from (
   select plan_id,emp_id from t_train_plan_emp
   where id = #{data.id}
) a 
 
