select * from (
    select 
    	tc.id as id,
    	tc.name as name
    from t_train_file tc
    where tc.train_course_id=#{data.id}
) a