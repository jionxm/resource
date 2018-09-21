SELECT
	*
FROM
	(
		SELECT
			r.id AS id,
			(
				CASE
				WHEN r.type = 'System' THEN
					'1'
				WHEN r.type = 'SubSystem' THEN
					'2'
				WHEN r.type = 'Module' THEN
					'3'
				ELSE
					'4'
				END
			) popupType,
			(case when  ISNULL(r.parent) then '1'
			when r.id in(SELECT parent from t_resource o2) then '2'
     		else '3' end) nodeType,
			r. NAME AS name,
			r1. NAME AS parentName,
			r.url AS url,
			r.parent as parent,
			(
				CASE
				WHEN r.is_auth = '1' THEN
					'是'
				ELSE
					'否'
				END
			) isAuth,
			d.`name` AS type,
			r.create_time AS createTime,
			e2. NAME AS createByName,
			r.update_time AS updateTime,
			e3. NAME AS updateByName,
			f. NAME AS funcName,
			m. NAME AS menuName
		FROM
			t_resource AS r
		LEFT JOIN t_employee e2 ON e2.id = r.create_by
		LEFT JOIN t_employee e3 ON e3.id = r.update_by
		LEFT JOIN t_resource r1 ON r1.id = r.parent
		LEFT JOIN t_res_func rf ON rf.res_id = r.id
		LEFT JOIN t_function f ON f.id = rf.func_id
		LEFT JOIN t_menu m ON m.res_id = r.id
		LEFT JOIN t_dict d ON d. CODE = r.type
		AND d.cata_code = 't_resource.type'
		GROUP BY r.id
			order by convert(r.name using gbk) asc
	) a