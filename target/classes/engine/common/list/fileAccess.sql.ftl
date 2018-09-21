select * from (
	select 
	CODE as value,
	NAME as text from t_dict WHERE cata_code='t_file_index.access_type' 
 ) a 