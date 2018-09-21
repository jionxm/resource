select * from (
select train_course_id from t_train_file 
where  id = #{data.id}
) a 
 
