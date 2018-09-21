select * from (
 select 
    res.id as id,
    res.backups_record_id as backupsRecordId,
    file.filename as fileName,
    ser.name as targetServer,
    type.name as type,
    record.description as description,
    record.create_time as createTime,
    record.update_time as updateTime,
    record.create_by as createBy,
    record.update_by as updateBy,
    record.update_count as updateCount,
    empfir.name AS createByName,
    empsec.name AS updateByName
 from t_backups_resource res
 	left join t_backups_record record on  res.backups_record_id=record.id
 	left join t_server ser on record.target_server=ser.id
 	left join t_resource_type type on record.type=type.id
 	left join t_file_index file on res.resource_file_id = file.id
 	LEFT JOIN t_employee empfir ON record.create_by = empfir.id
	LEFT JOIN t_employee empsec ON record.update_by = empsec.id
 	group by res.id
) a