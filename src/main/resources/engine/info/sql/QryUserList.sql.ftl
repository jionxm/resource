select * from (
	select u.id,u.name,e.id as empId,e.name as empName,e.email,e.mobile,
u.auth_type as authType, u.status ,d1.name as statusName ,d2.name as authTypeName ,
e.gender ,e.code as empCode,e.ext_code as empExtCode ,
u.update_time as updateTime,u.create_time as createTime ,e.position_id,
e1.name as createByName,e2.name as updateByName ,d3.name as genderName ,o.name as orgName ,d4.name as empTypeName ,
d5.name as empStatusName,e.status as empStatus  ,e.type as empType 
from t_user u 
left join t_employee e on u.emp_id = e.id 
left join t_employee e1 on u.create_by = e1.id 
left join t_employee e2 on u.update_by = e2.id 
left join t_org o on e.org_id = o.id 
left join t_dict d1 on u.status = d1.code and d1.cata_code='t_user.status' 
left join t_dict d2 on u.auth_type = d2.code and d2.cata_code='t_user.auth_type' 
left join t_dict d3 on e.gender = d3.code and d3.cata_code='t_employee.gender' 
left join t_dict d4 on e.type = d4.code and d4.cata_code='t_employee.type' 
left join t_dict d5 on e.status = d5.code and d5.cata_code='t_employee.status' 

 ) a 