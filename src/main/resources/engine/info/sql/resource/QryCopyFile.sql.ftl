select * from (
 select 
	f.id as fileId,
	f.url,
	f.path,
	f.file_type,
	f.filename
 from t_file_index f
) a