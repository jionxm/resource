select * from (
 select 
	duc.file_id as fileId,
	ca.id as id,
	duc.id as cataId, /*文档ID*/
	duc.id as DocId,
	duc.id as pid,
	ca.name as cataName, /*目录名称*/
    duc.title as title,
	duc.keyword as keyword,
	duc.status as status,
	duc.create_time as createTime,
	e2.name as createBy,
	duc.update_time as updateTime,
	(case when  ISNULL(pid) then '1'
			when ca.id in(SELECT pid from t_doc_cata o2) then '2'
     else '3' end

) nodeType   /*是否可以被删除*/
from 	
 t_document duc 
	left join t_doc_cata ca on duc.cata_id = ca.id
	left join t_employee e2 on e2.id=duc.create_by
	left join t_employee e3 on e3.id=duc.update_by
 ) a 

