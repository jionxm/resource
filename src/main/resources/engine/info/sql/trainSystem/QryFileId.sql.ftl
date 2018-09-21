select * from (
select train_file_id,trainee_id from t_trainee_file 
where id = #{data.id}
) a 
 
