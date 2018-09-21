select * from (
	select 
	m.name as parentName,
	m.id as id,
	m.id as pid
	from t_doc_cata as m
 ) a 