 select * from 
(
	select 
	cum.id as fileId,
	cum.id as id,
	cum.title as title ,
	cum.`status` as `status`,
	cum.create_time as createTime,
	e2.name as createByName,
	doc.id as docId,
	doc.name as docName,
	fi.id as fileId,
	fi.access_type as accessType,
	fi.create_time as fileCreateTime,
	doc1.id as pid,
	doc1.name as parentName,
	doc.pid as parent, 
	cum.update_time as updateTime,
	e3.name as updateByName,
	cum.keyword as keyword
	
from t_document  cum
left join t_doc_cata doc on doc.id = cum.cata_id 
left join t_file_index fi on cum.file_id = fi.id
left join t_doc_cata doc1 on doc1.id=doc.pid
left join t_employee e2 on e2.id=doc.create_by
left join t_employee e3 on e3.id=doc.update_by
) a 