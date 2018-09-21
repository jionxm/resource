select * from (
	select 
	id as value,
	NAME as text from t_sprint 
	where 
	case when isnull(#{data.projId}) or #{data.projId}='' then 1=2
	else proj_id=#{data.projId}
	end
 ) a 