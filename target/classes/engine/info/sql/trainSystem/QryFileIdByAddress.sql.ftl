select * from (
select ttf.id as id,ttcr.plan_id as planId,ttcr.start_time as startTime,ttcr.id as resultId from t_train_file ttf
left join t_train_course_result ttcr on ttcr.train_file_id = ttf.id
where ttf.file_address = #{data.addressid} and ttcr.plan_id=#{data.planid}
) a 
 
