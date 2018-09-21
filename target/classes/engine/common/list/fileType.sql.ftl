select * from (
	select 
	CODE as value,
	NAME as text from t_dict WHERE cata_code='t_train_file.file_type' 
 ) a 