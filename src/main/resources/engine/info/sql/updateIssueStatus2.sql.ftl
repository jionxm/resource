update t_issue set status='test' ,update_time=#{data.updateTime} ,update_by=#{data.updateBy} 
where id=#{primaryFieldValue} ;