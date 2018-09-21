select distinct * from (
		select
			case 			
			when ttf.prepostion_train_file_id is null and ttcr.state='start'
			then '可以学习'
			when ttf.prepostion_train_file_id is not null   and 
			(
				
				(
					select  distinct
					case when isnull(tcr.sum_time) or tcr.sum_time='' then 0 else tcr.sum_time end
					from t_train_course_result tcr
					where tcr.train_file_id = (select prepostion_train_file_id from t_train_file where id = ttf.id) and tcr.trainee_id=#{data.traineeBy} and tcr.plan_id=#{data.eq_planId}
				)/
				(
					select distinct
					expect_study_time
					from t_train_file
					where id = (select prepostion_train_file_id from t_train_file where id = ttf.id)
				)
			)<1 
			then '无法学习'
			when ttcr.state='end'
			then '可以学习'
			else '可以学习'
			end as study,
			ttf.id as id,
			ttf.train_course_id as courseId,
			ttf.file_address as fileAddress,
			ttf.create_time as createTime,
			ttf.update_time as updateTime,
			ttf.name as name,
			d1.name as fileTypeName,
			ttf1.name as prepostionFileName,
			ttf.train_course_file_introduction as fileIntroduction,
			ttf.expect_study_time as expectStudyTime,
			ttcr.sum_time as sumTime,
			ttcr.plan_id as planId,
			case when CONCAT(round(ttcr.sum_time / ttf.expect_study_time *100,2)>='100','%') then '100%' 
		  else CONCAT(round(ttcr.sum_time / ttf.expect_study_time *100,2),'%') end as resolvePercent	  
			
			from t_train_plan_emp ttpe
			left join t_train_plan ttp on ttp.id=ttpe.plan_id
			left join t_train_plan_course ttpc on ttpc.plan_id=ttpe.plan_id
			left join t_train_file ttf on ttf.train_course_id = ttpc.course_id
			left join t_train_course_result ttcr on ttcr.train_file_id = ttf.id
			left join t_dict d1 on ttf.file_type = d1.code and d1.cata_code='t_train_file.file_type'
			left join t_train_file ttf1 on ttf1.id=ttf.prepostion_train_file_id
			where ttcr.trainee_id =#{data.traineeBy}
) a