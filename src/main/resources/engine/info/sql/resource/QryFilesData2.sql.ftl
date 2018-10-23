select * from (
 select 
 		f.id as id,
 		f.name as name,
 		f.path as path
 from t_file_data f
) a