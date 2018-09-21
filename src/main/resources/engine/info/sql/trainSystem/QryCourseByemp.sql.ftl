select distinct * from (
select 
	tc.id as id,
	tc.name as name,
	tc.train_course_introduction as courseIntroduction,
	e.id as createBy,
	e.name as createByName,
	e1.id as updateBy,
	d.pid as planId,
	d.planname as planName,
	d.empid as traineeBy	
	FROM t_train_course tc	
LEFT JOIN t_employee e on e.id = tc.create_by
LEFT JOIN t_employee e1 on e1.id = tc.update_by
LEFT JOIN (
	select pc.course_id as cid,pc.plan_id as pid,pe.emp_id as empid,tp.title as planname from t_train_plan_course pc 
	left join t_train_plan_emp pe on pe.plan_id=pc.plan_id
	left join t_train_plan tp on tp.id=pc.plan_id
) d on d.cid = tc.id
) a 
