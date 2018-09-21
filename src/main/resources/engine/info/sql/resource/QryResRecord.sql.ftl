select * from (
 select 
    res.id as id,
    res.origin_server as originServer,
    res.type as type,
    res.target_server as targetServer,
    res.description as description,
    res.create_time as createTime,
    res.update_time as updateTime,
    res.create_by as createBy,
    res.update_by as updateBy,
    res.update_count as updateCount
 from t_backups_record res
) a