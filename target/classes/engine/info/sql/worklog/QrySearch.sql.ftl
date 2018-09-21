select * from 
(
select t.id as Id,  
d.category as category,
d.subcategory as subCategory,
DATE_FORMAT(t.submit_time,'%Y-%m-%d') as submitTime ,
t.submit_by as submitBy ,
e1.`name` submitByName,
 t.exam_by examBy1,e2.`name` as examBy,
  t.exam_time as examTime ,
  case when isnull(t.exam_res) or t.exam_res='' or t.exam_res='0' then '未审核' 
		when t.exam_res='1' then '未通过'
		else '通过' end as examResName,
		d.project_id  projId,p.`name` as projName,
t.submit_by as empId,org.id as orgId,org.`name` as orgName 
 from 
t_worklog t 
left join 
t_worklog_detail d on t.id = d.work_id 
left join t_project p on p.id = d.project_id 
left join t_employee e1 on e1.id = t.submit_by 
left join t_employee e2 on e2.id = t.exam_by  
left join t_org org on org.id = e1.org_id 
group by d.work_id 
)a





