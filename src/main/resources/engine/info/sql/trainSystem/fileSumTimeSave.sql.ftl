

update t_train_course_result bb set sum_time = sum_time+
(select aa.sum from
 (select id,start_time,end_time,TIMESTAMPDIFF(minute,start_time,end_time) as sum 
  from t_train_course_result ) aa where aa.id=bb.id)
where bb.train_file_id=#{data.id} and bb.trainee_id=#{data.traineeBy} and bb.plan_id=#{data.planId}