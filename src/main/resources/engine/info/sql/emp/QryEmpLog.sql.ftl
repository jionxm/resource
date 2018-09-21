 select * from (
SELECT
	l.id AS id,
	l.emp_id AS empId,
	l.type AS type,
	l.log_content AS logContent,
	e1.name as createByName,
	e2.name as updateByName,
	l.update_by as updateBy,
	l.create_by as createBy,
	l.update_time as createTime,
	l.create_time as updateTime  
FROM t_emp_log l
  LEFT OUTER JOIN t_employee e1 ON l.update_by=e1.id  
	LEFT OUTER JOIN t_employee e2 ON l.create_by=e2.id  
 ) a 