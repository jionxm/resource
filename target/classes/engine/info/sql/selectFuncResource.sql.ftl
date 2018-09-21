	select * from (
		select rf.id as rfId,rf.func_id as funcId,a.id,a.name,a.parent,a.is_auth as isAuth,
		rf.create_time as createTime,
		a.update_time as updateTime,
		b.name as parentName ,e1.name as updateByName,e2.name as createByName ,
		a.update_by as updateBy,f.name as funcName ,
		a.create_by as createBy  ,a.url 
		from t_res_func rf 
		left join t_function f on rf.func_id=f.id 
		left join t_resource a on rf.res_id=a.id 
		left join t_resource b on a.parent=b.id 
		left join t_employee e1 ON rf.update_by=e1.id  
		left join t_employee e2 ON rf.create_by=e2.id  
	 ) a 