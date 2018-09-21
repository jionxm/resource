select * from 
(
select 
	td.work_id as Id,
	td.work_id as workid,
	td.Issue_id as issueId,
	iss.title as title,
	td.project_id as projId,
	pro.`name` as projName,
	td.sprint_id as sprintId ,
	spr.`name` as sprintName,
	iss.type as issueType,
	case when iss.type = 'bug' then '缺陷'
		when iss.type = 'feature' then '新需求'
		when iss.type = 'improvement' then '改进'
		else '任务' end as issueTypeName ,	td.category as category,td.subcategory  as subCategory 
 from t_worklog_detail  td
 left join t_issue iss on iss.id = td.Issue_id
LEFT JOIN  t_project pro  ON td.project_id = pro.id	
left join t_sprint spr on spr.id = td.sprint_id
where td.work_id = #{data.workid}
)a