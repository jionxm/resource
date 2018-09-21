select * from (
SELECT
	e.id AS id,
	e.emp_id AS empId,
	e.start_date AS startDate,
	e.end_date AS endDate,
	e.school AS school,
	e.speciality AS speciality,
	e.degree AS degree,
	d1.name AS degreeName,
	e.learning_style AS learningStyle,
	d2.name AS learningStyleName
FROM t_education e
LEFT JOIN t_dict d1 on e.degree = d1.code and d1.cata_code='t_education.degree' 
LEFT JOIN t_dict d2 on e.learning_style = d2.code and d2.cata_code='t_education.learning_style' 
 ) a 