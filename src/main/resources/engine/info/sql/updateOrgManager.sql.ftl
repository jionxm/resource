update t_org set pid=#{data.pid} ,update_time=#{data.updateTime} ,update_by=#{data.updateBy} 
where id=#{primaryFieldValue} ;