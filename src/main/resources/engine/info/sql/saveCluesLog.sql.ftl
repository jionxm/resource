insert into t_sales_log (id,clues_id,log_content,create_time,create_by)    
values (
	#{data.id},#{data.cluesId},#{data.logContent},
	#{data.createTime},#{data.createBy}
);