SELECT * FROM(
	SELECT
		a.id as id,
		a.title as title,
		a.type as type,
		a.org_id as orgId,
		a.context as context,
		a.create_by as createBy,
		a.update_by as updateBy,
		a.create_time as createTime,
		a.update_time as updateTime,
		d.name as typeName,
		o.name as orgName,
		e.name as createName,
		e2.name as updateName
	FROM t_announcement a
	left JOIN t_org o
	ON a.org_id=o.id
	left JOIN t_employee e
	ON a.create_by=e.id
	left JOIN t_dict d
	ON a.type=d.code
	AND d.cata_code='t_announcement.type'
	left JOIN t_employee e2
	ON a.update_by=e2.id
)a