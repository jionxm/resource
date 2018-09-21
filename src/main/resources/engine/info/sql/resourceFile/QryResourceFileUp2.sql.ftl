select * from (
	select 
	f.id as id,
	f.file_id as fileId,
	i.uuid as fileIdName,
	f.resource_type as resourceType,
	c.name as resourceTypeName,
	f.server as server,
	b.name as serverName,
	f.name as name,
	f.description as description,
	f.create_time as createTime,
	f.create_by as createBy,
	f.update_time as updateTime,
	f.update_by as updateBy,
	f.update_count as updateCount,
	e.name as createByName,
	g.name as updateByName
	from t_resource_file f
	left join t_file_index i on i.id = f.file_id
	left join t_resource_type c on c.id = f.resource_type
	left join t_server b on b.id = f.server
	left join t_employee e on e.id = f.create_by
	left join t_employee g on g.id = f.update_by
	
 ) a 