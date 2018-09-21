update t_employee set status='work' ,update_time=now() ,update_by=#{data.session.userInfo.empId}

where id=#{primaryFieldValue} ;