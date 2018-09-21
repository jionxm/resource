select * from (
   select
   ttpc.id as id,
   ttpc.plan_id as planId,
   ttpc.course_id as courseId,
   ttpc.create_by as createBy,
   ttpc.create_time as createTime,
   ttpc.update_by as updateBy,
   ttpc.update_time as updateTime,
   ttc.name as name,
   ttc.train_course_introduction as courseIntroduction,
   e1.name as createByName,
   e2.name as updateByName
   from t_train_plan_course ttpc
   left join t_train_course ttc on ttc.id = ttpc.course_id
   left join t_employee e1 on e1.id = ttpc.create_by
    left join t_employee e2 on e2.id = ttpc.update_by
   where  ttpc.plan_id = #{data.ctlPlanId}
) a 
 
