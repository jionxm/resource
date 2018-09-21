update t_project set status='close' ,update_time=now() ,update_by=#{data.session.userInfo.empId}

where id=#{primaryFieldValue} ;