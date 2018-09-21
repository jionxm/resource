select * from (
	select
	ID as id,
	NAME as name
	 from t_project
     where case when locate('Administrator',#{data.session.userInfo.roleName}) >0  then 1=1
     else   id in (select proj_id  from t_proj_emp where emp_id = #{data.session.userInfo.empId}) end
 ) a