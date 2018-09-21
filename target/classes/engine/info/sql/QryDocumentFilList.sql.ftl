select * from 
(
	select 
	cum.id as id,
	cum.title as title ,
	cum.`status` as `status`,
	cum.create_time as createTime,
	cum.create_by as createBy,
	doc.id as docId,
	doc.name as docName,
	fi.id as fileId,
	fi.access_type as accessType,
	fi.create_time as fileCreateTime,
	doc1.id as pid,
	doc1.name as parentName

from t_document  cum
left join t_doc_cata doc on doc.id = cum.cata_id 
left join t_file_index fi on cum.file_id = fi.id
left join t_doc_cata doc1 on doc1.id=doc.pid

) a 