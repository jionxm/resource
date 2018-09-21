 select * from (
SELECT
	l.id AS id,
	l.clues_id AS cluesId,
	l.log_content AS logContent,
	e2.name as createByName,
	l.create_by as createBy,
	l.create_time as createTime  
FROM t_sales_log l
	LEFT OUTER JOIN t_employee e2 ON l.create_by=e2.id  
 ) a 