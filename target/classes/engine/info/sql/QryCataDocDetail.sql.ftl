select * from 
(
	select d.id as id,d.file_id as fileId,d.cata_id as cataId,d.title as title,d.keyword as keyword,d.`status` as `status`,
	d.create_time as createTime,d.create_by as createBy,d.update_time as updateTime,
	d.update_by as updateBy ,
c.`name` as cataName
 from t_document d
left join t_doc_cata c on c.id = d.cata_id
) a 