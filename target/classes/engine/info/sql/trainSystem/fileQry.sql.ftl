select DISTINCT *  from (
select 		
case 
when (select count( train_file_id) from t_train_course_result r where r.train_file_id=f.prepostion_train_file_id 
and r.trainee_id=#{data.traineeBy})>=1 and ttf.state='start'
then '可以学习'
when f.prepostion_train_file_id is null and ttf.state='start'
then '可以学习'
when ttf.state='doing'
then '结束学习'
else '无法学习'
end as study,
		   f.id as id,
	       f.name as name,
	       case when (f.file_type ='videofile') then '视频文件' 
	       when (f.file_type ='PDF') then 'PDF课件' 
	       when (f.file_type ='TXT') then '文本文件' 
	       when (f.file_type ='jpg') then '图片文件' end as fileTypeName,
	       f.file_address as fileAddress,
	       f.train_course_id as courseId,
	       c.name as courseName,
	       f.expect_study_time as expectStudyTime,
	       f.train_course_file_introduction as fileIntroduction, 
	       f.prepostion_train_file_id as prepostionFileId,
	       f1.name as prepostionFileName,
	       emp.id as createBy,
	       emp.name as createByName,
	       f.create_time as createTime,
	       emp1.id as updateBy,
	       emp1.name as updateByName,
	       f.update_time as updateTime,
	       ttf.trainee_id as traineeId,
	       ttf.state as state,
	       m.resolvePercent as resolvePercent,
	      
	       m.sumTime as sumTime
	from t_train_course c
	left join t_trainee_file ttf on ttf.train_file_id=c.id	
	left join t_employee emp on emp.id=c.create_by
	left join t_employee emp1 on emp1.id=c.update_by
	
	left join t_train_file f on f.train_course_id=c.id	
	left join t_train_file f1  on f.prepostion_train_file_id=f1.id
	left join (select 
	       f.expect_study_time as expectStudyTime,
	       t2.train_file_id as trainFileId,
	       t2.trainee_id as traineeId,    
  		   sum.sum_time as sumTime,
		   CONCAT(round(sum.sum_time / f.expect_study_time *100,2),'%')as resolvePercent
  	       from t_train_course_result t2
		   left join t_train_file f on f.id = train_file_id
		   left join (select * from (
	select sum_time ,train_file_id as fileId ,trainee_id from t_train_course_result
   group by train_file_id,trainee_id having trainee_id=#{data.traineeBy}
) b ) sum on sum.fileId=train_file_id
		   GROUP BY train_file_id
	) m on m.trainFileId=f.id 
	where ttf.trainee_id=#{data.traineeBy}
) a




