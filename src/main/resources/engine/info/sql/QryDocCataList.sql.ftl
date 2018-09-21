select * from (
	select concat(pid,id),
	id as id,
	pid as pid,
	name as text,
	id as DocId ,
		(case when  ISNULL(pid) then '1'
			when id in(SELECT pid from t_doc_cata o2) then '2'
     else '3' end

) nodeType,   /*是否可以被删除*/
 seq 
	from t_doc_cata
ORDER BY seq ASC ,concat(pid,id)
 ) a 

