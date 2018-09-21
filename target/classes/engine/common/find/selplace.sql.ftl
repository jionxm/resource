select * from (
	select 
	CODE as id,
	NAME as name from t_dict 
	WHERE dict_cata_code='PROVINCE' 
	and code<>#{data.id}
 ) a 