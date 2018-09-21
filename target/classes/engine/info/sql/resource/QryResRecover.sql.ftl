select * from (
 select 
    res.id as id,
    ser.name as targetServer,
    type.name as type,
    res.description as description,
    res.create_time as createTime,
    res.update_time as updateTime,
    res.create_by as createBy,
    res.update_by as updateBy,
    empfir.name AS createByName,
    empsec.name AS updateByName
 from t_backups_record res
 	left join t_server ser on res.target_server=ser.id
 	left join t_resource_type type on res.type=type.id
 	LEFT JOIN t_employee empfir ON res.create_by = empfir.id
	LEFT JOIN t_employee empsec ON res.update_by = empsec.id
 	group by res.id
) a