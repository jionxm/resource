select * from (
SELECT
	t.id AS id,
	t.emp_id AS empId,
	t.start_date AS startDate,
	t.end_date AS endDate,
	t.agency AS agency,
	t.content AS content,
	t.certificate AS certificate
FROM t_training t
 ) a 