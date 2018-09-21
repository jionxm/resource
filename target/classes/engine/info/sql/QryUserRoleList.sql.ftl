select * from (
	select 
	ur.id,ur.user_id as userId ,
	ur.role_id as roleId,
	r.name,u.name as userName,
	r.description,
	e1.name as updateByName,
	e2.name as createByName,
	r.update_by as updateBy,e.name as empName ,
	r.create_by as createBy,
	r.update_time as updateTime,
	r.create_time as createTime  ,
	d1.name as authTypeName ,
	d2.name as statusName 
	from t_user_role ur 
	left join t_role r  on ur.role_id=r.id 
	left join t_user u on ur.user_id = u.id 
	left join t_employee e on u.emp_id = e.id 
  	LEFT OUTER JOIN t_employee e1 ON ur.update_by=e1.id  
	LEFT OUTER JOIN t_employee e2 ON ur.create_by=e2.id  
	
	LEFT OUTER JOIN t_dict d1 ON u.auth_type=d1.code and d1.cata_code = 't_user.auth_type'  
	LEFT OUTER JOIN t_dict d2 ON u.status=d2.code and d2.cata_code = 't_user.status'  

 ) a 