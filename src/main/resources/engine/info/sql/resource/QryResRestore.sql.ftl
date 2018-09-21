select * from (
 select 
    res.id as id,
    res.backups_record_id as backupsRecordId,
    ser.name as targetServer,
    type.name as type,
    record.description as description,
    res.create_time as createTime,
    res.update_time as updateTime,
    res.create_by as createBy,
    res.update_by as updateBy,
    res.update_count as updateCount,
    empfir.name AS createByName,
    empsec.name AS updateByName
 from t_restore_record res
 	left join t_backups_record record on  res.backups_record_id=record.id
 	left join t_server ser on record.target_server=ser.id
 	left join t_resource_type type on record.type=type.id
 	LEFT JOIN t_employee empfir ON res.create_by = empfir.id
	LEFT JOIN t_employee empsec ON res.update_by = empsec.id
 	group by res.id
) a