select * from (
 select 
    res.id as id,
    res.name as name,
    res.file_id as fileId,
    res.status as status,
    res.resource_type as resourceType,
    type.name as resourceTypeName,
    type.pic_id as picId,
    res.course_id as courseId,
	course.stage_name as courseName,
    res.description as description,
    file.length/1000 as length,
    res.create_time as createTime,
    res.update_time as updateTime,
    case when res.status=0 then '正常'
    	 when res.status=1 then '已删除' end as statusName
 from t_resource_file res
 	left join t_file_index file on res.file_id=file.id
 	left join t_resource_type type on res.resource_type=type.id
 	left join t_exp_course course on res.course_id = course.id
) a