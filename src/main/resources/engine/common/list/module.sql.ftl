select * from (
	select 
	id as value,
	NAME as text from t_module 
	where 
	case when isnull(#{data.eq_projId}) or #{data.eq_projId}='' then 1=2
	else proj_id=#{data.eq_projId}
	end
 ) a  