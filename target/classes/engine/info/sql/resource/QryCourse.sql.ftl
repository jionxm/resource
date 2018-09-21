 select * from (
SELECT
	l.id AS id,
	l.course_id AS courseId,
	l.system_name as systemName,
	l.system_code as systemCode,
	l.stage_id as stageId,
	l.version_name as versionName,
	l.version_id as versionId,
	l.stage_name as stageName,
	l.course_name as courseName,
	l.update_time as updateTime,
	l.update_count as updateCount
FROM t_exp_course l
 ) a 