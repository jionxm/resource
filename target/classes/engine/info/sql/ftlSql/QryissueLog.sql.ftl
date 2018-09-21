select 
	til.id,
	log_content as log,
	til.create_time as time,
	t.title
from 
	t_issue_log til
left join  t_issue t
on
t.id=til.issue_id
order by til.create_time desc