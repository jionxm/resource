select * from (
	select 
	id as value,
	NAME as text from t_sprint 
	where 1=1 and 
	case when isnull(#{data.projId}) or #{data.projId}='' then 1=2 and status = 'open'
	else proj_id=#{data.projId} and status = 'open'
	end
		
 ) a 