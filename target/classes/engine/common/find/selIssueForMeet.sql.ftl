select * from (
SELECT
	issue.id as id,
	e1.`name` AS assignee,
	e2.`name` AS reporter,
	issue.title as title,
	issue.create_time as creatTime
FROM
	t_issue issue
LEFT JOIN t_employee e1 ON e1.id = issue.assignee
LEFT JOIN t_employee e2 ON e2.id = issue.reporter
 ) a 