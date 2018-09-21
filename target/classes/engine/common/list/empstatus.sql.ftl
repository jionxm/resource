select * from (
	select 
	CODE as value,
	NAME as text from t_dict WHERE cata_code='EMP.STATUS' 
 ) a 