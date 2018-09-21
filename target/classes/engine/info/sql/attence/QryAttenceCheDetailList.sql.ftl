select * from 
(
select  d.id as attenceId,attence_id as Id,
	commit_day as commitDay,
 	commit_hours as commitHours,
 	attence_day as attenceDay,
	d.user_id as userId,
	e.`name` as userName
 from t_attence_check_detail d
left join t_employee e on d.user_id = e.id

)c