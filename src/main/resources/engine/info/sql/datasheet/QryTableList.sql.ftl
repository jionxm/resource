select * from
(SELECT 
    t.TABLE_NAME as tableName,
    t.TABLE_COMMENT as tableComment,
    t.Auto_increment as extraNumber,
    COUNT(DISTINCT c.COLUMN_NAME) AS fieldNum,
		t.TABLE_ROWS AS recordNum,
		ta.update_time AS updateTime
	FROM information_schema.TABLES t
	LEFT JOIN information_schema.columns c
	ON t.TABLE_NAME=c.TABLE_NAME
	LEFT JOIN t_total ta
	ON ta.table_name=t.TABLE_NAME
WHERE t.table_schema=(select database())
GROUP BY t.TABLE_NAME
) a 