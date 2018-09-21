select * from 
(
select n.numb as isCheck,
	a.Id as Id,
	a.empId as empId,
	a.orgId as orgId,
	a.examResName as examResName,
	a.remark as remark,
	a.submitByName as submitByName,
	a.work_summary as workSummary,
	a.problem as problem,
	a.tom_workplan as tomWorkplan,
	a.submitBy as submitBy,
	a.examRes as examRes,
	a.examBy as examBy,
	a.examByName as examByName,
	a.examTime as examTime,
	a.examView as examView,
	a.hours as hours,
	a.submitTime as submitTime,
	a.updateBy as updateBy,
	a.updateTime as updateTime,
	a.managerId  as managerId 
from 
(
select 
  tw.id as Id,
  emp.id as empId,
  emp.org_id as orgId,
	tw.exam_by as examBy,
	e3.`name` as examByName,
  case when isnull(tw.exam_res) or tw.exam_res='' or tw.exam_res='0' then '未审核' 
		when tw.exam_res='1' then '未通过'
	else '通过' end as examResName,
	tw.remark as remark,
	e2.`name` as submitByName,
	tw.exam_res as examRes,
	tw.exam_time as examTime,
	tw.exam_view as examView,
	tw.hours as hours,
	tw.submit_by as submitBy,
    DATE_FORMAT(tw.submit_time,'%Y-%m-%d') as submitTime,
	tw.update_by as updateBy,
	tw.update_time as updateTime,
	tw.manager_id as managerId,
tw.work_summary,tw.problem,tw.tom_workplan
 from t_employee emp 
 left join t_worklog tw on emp.id = tw.submit_by 
left join t_employee e2 on e2.id = emp.id  
left join t_employee e3 on e3.id = tw.exam_by  
where case when  isnull(#{data.submitTimeS}) or  #{data.submitTimeS }='' then 1=1  else DATE_FORMAT(tw.submit_time,'%Y-%m-%d')>=DATE_FORMAT(#{data.submitTimeS},'%Y-%m-%d') end
and case when isnull(#{data.submitTimeE}) or  #{data.submitTimeE }='' then 1=1  else DATE_FORMAT(tw.submit_time,'%Y-%m-%d') <= DATE_FORMAT(#{data.submitTimeE},'%Y-%m-%d') end
)a
left join 
(
select sum(checkO) numb ,subBy,subTime  from (
select 
	case when (exam_time is not null and exam_res = '1') then 0
	when exam_time is null then 0
	else 1  end as checkO,
	submit_by subBy,
	DATE_FORMAT(submit_time,'%Y-%m-%d') subTime
from t_worklog 
) a
group by subBy,subTime
)
n on a.submitBy = n.subBy and a.submitTime = n.subTime 
where submitBy != #{data.empId} and a.managerId = #{data.empId}
and case when isnull(#{data.examRes}) or #{data.examRes}=''  then  1=1  when  #{data.examRes}='1' then n.numb =0  else   a.examRes = #{data.examRes}  end
)M




