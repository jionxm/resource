select * from (
	select concat(parent,id),
	id as id,
	parent as parent,
	name as text,
	CASE
	WHEN type = 'System' THEN
		'1'
	WHEN type = 'SubSystem' THEN
		'2'
	WHEN type = 'Module' THEN
		'3'
	ELSE
		'4'
	END as popupType
	from t_resource
	where type<>'Component'
ORDER BY convert(text using gbk) asc
 ) a 