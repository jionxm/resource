select * from (
	select 
	m.name as parentName,
	m.code as id,
	m.code as parent,
d.`name` as typeName,
d.`code` as type
	from t_menu as m
LEFT JOIN t_dict d ON d.cata_code='t_menu.type' AND d.`code`=m.type
 ) a 