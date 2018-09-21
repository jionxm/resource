select *  from (
select 
		f.id as id,
	       f.name as name,
	       f.file_type as fileType,
	       d1.name as fileTypeName,
	       f.file_address as fileAddress,
	       file.filename as fileAddressName,
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
	       case when (select count(f1.id) from t_train_file f1 where f1.prepostion_train_file_id =f.id) >=1 then 0 else 1 end as det
	from t_train_file f
	left join t_train_course c on c.id=f.train_course_id
	left join t_train_file f1 on f1.id=f.prepostion_train_file_id
	LEFT JOIN t_dict d1 on f.file_type = d1.code and d1.cata_code='t_train_file.file_type' 
	left join t_employee emp on emp.id=f.create_by
	left join t_employee emp1 on emp1.id=f.update_by
	left join t_file_index file on f.file_address=file.id
) a
