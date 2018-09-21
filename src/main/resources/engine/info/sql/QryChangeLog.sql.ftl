select * from (
SELECT
a.id,
a.entity_id   AS entityId,
a.type,
a.proc,
a.old_content AS oldContent,
a.new_content AS newContent,
a.create_time AS createTime,
e.name    AS createByName,
a.create_by   AS createBy,
a.entity_name AS entityName,
a.flow_id     AS flowId
FROM t_change_log a
LEFT JOIN t_employee e ON a.create_by = e.id
) a