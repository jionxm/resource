insert into t_emp_log (emp_id,type,log_content,create_time,create_by,update_time,update_by)    
values (
	#{data.id},#{data.type},#{data.logContent},
	#{data.createTime},#{data.createBy},#{data.updateTime},#{data.updateBy}
);