update t_review set review_result = 'unpass'  ,update_time=now() ,update_by=#{data.session.userInfo.empId}

where id=#{primaryFieldValue} ;