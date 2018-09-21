insert into t_testcase_record(testcase_id,result,create_time,create_by,update_time,update_by) 
values(#{data.testcaseId},#{data.result},#{data.updateTime},#{data.updateBy},#{data.updateTime},#{data.updateBy} );update t_testcase set last_result=#{data.result} ,update_time=#{data.updateTime} ,update_by=#{data.updateBy} 
where id=#{data.testcaseId} ;