select * from (
	select 
	o.id as id,
	o.name as name,
	o1.name   as upDocName
	from t_doc_cata o 
	left join t_doc_cata o1 on o1.id = o.pid
 ) a 