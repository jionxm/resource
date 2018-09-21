select * from (
	select 
	id ,
	name from t_sprint 
	where 
	case when isnull(#{data.id}) or #{data.id}='' then 1=2
	else proj_id=#{data.id}
	end
 ) a 