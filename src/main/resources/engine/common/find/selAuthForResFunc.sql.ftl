select * from (
	select d.code as id,d.name from t_dict d 
	left join  (select data_auth from t_role_func where id=#{data.id}) rf on d.code = rf.data_auth 
	where d.cata_code='t_role_func.data_auth' and rf.data_auth is null 
) a 
