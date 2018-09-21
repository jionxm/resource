update t_employee set status=1 ,update_time=#{data.updateTime} ,update_by=#{data.updateBy} 
where emp_id=#{primaryFieldValue} ;
select * from t_employee where emp_id=#{primaryFieldValue} ;