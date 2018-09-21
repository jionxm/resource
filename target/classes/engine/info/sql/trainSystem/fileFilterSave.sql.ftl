select *  from (
select distinct
Case 
WHEN 
(select count( train_file_id) from t_train_course_result r where r.train_file_id=f.prepostion_train_file_id 
and r.trainee_id=#{data.traineeBy})>=1
THEN '可以学习'  

when f.prepostion_train_file_id is  null
then '可以学习' 
ELSE '无法学习' 
END as study,

Case 
WHEN (select aa.end_time from(select log.id ,log.train_file_id,log.end_time from t_train_course_result log
left join t_train_file f on  log.train_file_id =f.id
 where train_file_id=f.id and trainee_id=#{data.traineeBy}) aa 
 order by aa.id desc limit 1) is not null
then 0
ELSE 1 
END as det,

			f.id as id,
	       f.name as name,
	       f.file_type as fileType,
	       d1.name as fileTypeName,
	       f.file_address as fileAddress,
	       f.train_course_id as courseId,
	       f.expect_study_time as expectStudyTime,
	       f.train_course_file_introduction as fileIntroduction, 
	       f.prepostion_train_file_id as prepostionFileId,
	       f1.name as prepostionFileName,
	       c.name as courseName,
	       f.create_time as createTime,
	       f.update_time as updateTime,
	       emp.name as createByName,
	       emp1.name as updateByName,
	       log.sum_time as sumTime,
	       CONCAT(round(log.sum_time / f.expect_study_time *100,2),'%')as resolvePercent
	from t_train_file f
	left join t_train_file f1  on f.prepostion_train_file_id=f1.id
	left join t_train_course_result log on f.id = log.train_file_id
	left join t_train_course c on c.id=f.train_course_id
	LEFT JOIN t_dict d1 on f.file_type = d1.code and d1.cata_code='t_train_file.file_type' 
	left join t_employee emp on emp.id=f.create_by
	left join t_employee emp1 on emp1.id=f.update_by
	order by f.create_time asc
) a
