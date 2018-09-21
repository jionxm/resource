select * from 
(
select 
    w.submit_time as submitTime,
    e.name as empName,
    o.name as orgName,
    sum(case when d.subcategory='今日已关闭的工作项' then 1 else 0 end ) as woeked,
    sum(case when d.subcategory='今日已关闭的缺陷' then 1 else 0 end ) as buged,
    sum(case when d.subcategory='今日已关闭的需求' then 1 else 0 end ) as needed,
    sum(case when d.subcategory='进行中的工作项' then 1 else 0 end ) as working,
    sum(case when d.subcategory='测试中的工作项' then 1 else 0 end ) as testing,
    sum(case when d.subcategory='待办工作项' then 1 else 0 end ) as toWork,
    sum(case when d.subcategory='已解决的需求' then 1 else 0 end ) as toNeed,
    sum(case when d.subcategory='已解决的缺陷' then 1 else 0 end ) as toBug
   from t_worklog w
   left join  t_employee e on w.submit_by = e.id
   left join t_org o on e.org_id =o.id
   left join t_worklog_detail d on w.id = d.work_id
   GROUP BY submitTime,empName,orgName  
)a





