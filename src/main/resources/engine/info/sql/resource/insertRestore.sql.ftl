insert into t_backups_resource(
	backups_record_id,resource_file_id )
	values(
		#{data.recordId},
		#{data.fileId}
		)