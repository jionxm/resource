select * from (
	select 
	f.id as id,
	f.uuid as uuid,
	f.filename as filename,
	f.file_type as fileType,
	f.length as fileLength,
	f.storage_type as storageType,
	d1.name as storageTypeName,
	f.access_type as accessType,
	d2.name as accessTypeName,
	f.source as source,
	d3.name as sourceName,
	f.description as description,
	f.create_time as createTime,
	f.create_by as createBy,
	e.name as createByName
	from t_file_index f
	left join t_dict d1 on d1.code=f.storage_type and d1.cata_code='t_file_index.storage_type'
	left join t_dict d2 on d2.code=f.access_type and d2.cata_code='t_file_index.access_type' 
	left join t_dict d3 on d3.code=f.source and d3.cata_code='t_file_index.source' 
	left join t_employee e on e.id = f.create_by
	where f.file_type='md.dat'
 ) a 