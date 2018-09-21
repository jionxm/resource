select * from (
	select 
	id,
	title
 	from t_issue  
 	where type='feature' OR type='improvement' 
 ) a 