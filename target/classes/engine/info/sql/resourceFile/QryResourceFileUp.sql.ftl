INSERT INTO t_resource_file (
	file_id,
	resource_type,
	server,
	name,
	status,
	description,
	create_by,
	create_time,
	update_time,
	update_by,
	update_count,
	course_id
)
VALUES (
	#{data.ctlfileId},
	#{data.resourceType},
	#{data.server},
	#{data.name},
	#{data.status},
	#{data.description},
	#{data.createBy},
	#{data.createTime},
	#{data.updateTime},
	#{data.updateBy},
	#{data.updateCount},
	#{data.eq_courseId}
)

 