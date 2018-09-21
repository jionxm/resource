SELECT
	*
FROM
	(
		SELECT
			s.id AS id,
			s.code AS code,
			s.name AS name,
			s.ip AS ip,
			s.port AS port,
			s.description AS description,
			s.create_time AS createTime,
			s.create_by AS createBy,
			s.update_time AS updateTime,
			s.update_by AS updateBy,
			s.update_count AS updateCount
		FROM t_server s
	) a