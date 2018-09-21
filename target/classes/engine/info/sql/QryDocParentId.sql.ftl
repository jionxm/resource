select * from (
	select 
	m1.name as parentName,
	m1.id as pid,
	m.id as id,
	m.`name` as name ,
	m.seq as seq 
	from t_doc_cata as m 
left join t_doc_cata as m1 on m.pid = m1.id
 ) a 
