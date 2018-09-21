SELECT
	*
FROM
	(
		SELECT
			id AS Id,
			id AS workid,
			exam_time AS examTime,
			CASE
		WHEN exam_res = '2' THEN
			'通过'
		WHEN exam_res = '1' THEN
			'未通过'
		ELSE
			'未审核'
		END AS examRes,
		exam_view AS examView,
		hours AS hours,
		remark AS remark
	FROM
		t_worklog t
	) a