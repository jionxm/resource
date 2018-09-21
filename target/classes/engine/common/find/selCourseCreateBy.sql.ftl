select * from (
    select 
    	t.id as id,
    	t.name as name
    from t_employee t
) a