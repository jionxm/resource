SELECT
	*
FROM
	(
		SELECT
			bt.id AS id,
			bt.name AS name,
			bt.description AS description,
			bt.create_time AS createTime,
			bt.create_by AS createBy,
			bt.update_time AS updateTime,
			bt.update_by AS updateBy,
			bt.update_count AS updateCount
		FROM t_backups_type bt
	) a