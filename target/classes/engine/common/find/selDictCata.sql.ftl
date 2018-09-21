select * from (
	select 
	dc.code as id,
	dc.name as name
	from t_dict_cata dc 

 ) a 