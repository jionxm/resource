select * from (
SELECT
	a.id AS id,
	a.emp_id AS empId,
	a.start_date AS startDate,
	a.name AS name,
	a.result AS result,
	a.score AS score
FROM t_assessment a
 ) a 