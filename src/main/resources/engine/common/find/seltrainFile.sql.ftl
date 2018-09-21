select * from (
    select 
    	tc.id as id,
    	tc.name as name
    from t_train_course tc
) a