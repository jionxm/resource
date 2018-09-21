update t_user set status='enable' ,update_time=#{data.updateTime} ,update_by=#{data.updateBy} 
where id=#{primaryFieldValue} ;