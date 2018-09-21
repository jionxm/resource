SELECT
	t.id AS id
FROM t_issue t where t.status not in ('close','cancel') and t.sprint_id = #{data.id} limit 1
