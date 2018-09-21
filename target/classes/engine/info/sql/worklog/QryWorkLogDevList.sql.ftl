select * from (
select 
		iss.reporter,
		iss.assignee,
	/*	iss.test_design_by,
		iss.test_by,*/
		iss.create_by,
		e1.`name` createBy,
		iss.update_by updateBy,
		pro.id as projId,
		pro.`name` as projName,
		spr.id as sprintId ,spr.`name` as sprintName,
		iss.id as issueId, iss.title as title,
		iss.type as issueTypeName,log.type,log.update_status as category 
from 
t_issue_log log 
left join t_issue iss on log.issue_id = iss.id 
left join t_project pro on pro.id = iss.proj_id 
left join t_sprint spr on spr.id = iss.sprint_id 
left join t_employee e1 on e1.id = iss.assignee

order by log.create_time desc 
)a