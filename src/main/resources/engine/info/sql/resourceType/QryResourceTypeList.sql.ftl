select * from
(SELECT 
	t.id as id,
	t.name as name,
	t.pic_id as picId,
	t.description as description,
	t.create_time as createTime,
	t.create_by as createBy,
	t.update_time as updateTime,
	t.update_by as updateBy,
	t.update_count as updateCount,
	file.filename as picName
    FROM t_resource_type t
    left join t_file_index file on t.pic_id=file.id
) a 
