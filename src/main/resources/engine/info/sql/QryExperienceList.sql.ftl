select * from (
SELECT
	e.id AS id,
	e.emp_id AS empId,
	e.start_date AS startDate,
	e.end_date AS endDate,
	e.company AS company,
	e.department AS department,
	e.position AS position
FROM t_experience e
 ) a 