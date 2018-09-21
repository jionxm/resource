select * from (
	select r.id,r.name,r.parent,case when r.is_auth=1 then '是' else '否' end as isAuth,
	r.create_time as createTime,
	r.update_time as updateTime,d1.name as typeName,
	b.name as parentName ,e1.name as updateByName,e2.name as createByName ,
	r.update_by as updateBy,rf.name as funcName ,rof.roleName,
	r.create_by as createBy  ,r.url ,
	case when rf.name is null then null else r.type end as resType  
	from t_resource r 
	left join t_resource b on r.parent=b.id 
	left join t_employee e1 ON r.update_by=e1.id  
	left join t_employee e2 ON r.create_by=e2.id  
	left join t_dict d1 ON r.type=d1.code and d1.cata_code='t_resource.type'
	left join (
		select res_id,group_concat(f.name order by f.name separator ",") as name from t_res_func  rf 
		left join t_function f on rf.func_id=f.id 
		group by res_id
		) rf on r.id=rf.res_id 
	left join (
		select rf.res_id
		,group_concat(distinct r.name order by r.name separator ",") as roleName
		from t_res_func  rf 
		left join t_function f on rf.func_id=f.id 
		left join t_role_func rof on f.id=rof.func_id
		left join t_role r on rof.role_id=r.id
		group by rf.res_id
	) rof on r.id=rof.res_id  

	order by r.name 
 ) a 