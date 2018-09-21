update t_user set
    password=#{data.password},
    update_time=now() ,
    update_by=#{session.userInfo.empId},
    update_count=update_count+1
where id=#{primaryFieldValue} and auth_type = 'local';