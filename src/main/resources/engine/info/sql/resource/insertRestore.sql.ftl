insert into t_backups_resource(
	backups_record_id,resource_file_id,backups_path)
	values(
		#{data.recordId},
		#{data.fileId},
		#{data.backupsPath}
		)