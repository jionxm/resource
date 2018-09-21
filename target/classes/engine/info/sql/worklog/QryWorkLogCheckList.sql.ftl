select * from (
	select 
	id as isCheck ,
	DATE_FORMAT(submit_time,'%Y-%m-%d') as submitTime  
from t_worklog
where 
/* exam_time != '' and  */
submit_by = #{data.submitBy} and 
DATE_FORMAT(submit_time,'%Y-%m-%d')>=DATE_FORMAT(#{data.submitTime},'%Y-%m-%d')
   order by create_time desc
)a