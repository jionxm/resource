select * from (
    select
    i.title,
    i.id ,
    p.name as projectName,
    s.name as sprintName,
    e1.name AS assignee,
	e2.name AS reporter,
    i.create_time as createTime,
    ci.change_id as changeId
    from t_issue i
    left join t_project p on i.proj_id = p.id
    left join t_change_apply_issue ci on i.id = ci.issue_id
    left join t_sprint s on i.sprint_id = s.id
    left join  t_employee e1 ON e1.id = i.assignee
    left join  t_employee e2 ON e2.id = i.reporter
    where ci.id is null or ci.change_id <> #{model.changeId}
    order by i.id
) a