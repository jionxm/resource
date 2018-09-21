select * from 
(
select 
	S.category as category,
	S.subCategory as subCategory,
	S.title as title,
	S.submitTime as submitTime,
	S.projId as projId,
	pro.`name` projName,
	S.sprintId as sprintId,
	sprint.`name` sprintName,
	S.issType as issueType,
	case when S.issType='feature' then '新需求' 
		when S.issType='improvement' then '改进' 
		when S.issType='bug' then '缺陷' 
		ELSe '任务' end as issueTypeName,
	S.issueId as issueId 
 
FROM
(

/*已解决的工作项 --处理人*/
select
	'已完成的工作' as category,
	'今日已解决的工作项' as subCategory,
	c.id issueId,
	c.title as title,0 as countCas,
	c.proj_id as projId,
    c.sprint_id as sprintId,
    c.type as issType,
	DATE_FORMAT(b.create_time,'%Y-%m-%d') as submitTime
from (
	select max(isso.id)as logId
  		from t_issue_log isso
		where 
	  	DATE_FORMAT(isso.create_time,'%Y-%m-%d') = #{data.submitTime}
	  	and isso.create_by = #{data.createBy}
		group by isso.issue_id
	)a 
left join t_issue_log b on a.logId = b.id 
left join t_issue c on b.issue_id = c.id 
where c.assignee = #{data.createBy}
and b.update_status ='resolve'
/* and b.update_status in( 'resolve','close','test') */
union all 
/*已关闭的缺陷 --报告人*/
select
'已完成的工作' as category,
'今日已关闭的缺陷' as subCategory,
	c.id issueId,
	c.title as title,0 as countCas,
	c.proj_id as projId,
  	c.sprint_id as sprintId,c.type as issType,
	DATE_FORMAT(b.create_time,'%Y-%m-%d') as submitTime
from (
	select max(isso.id)as logId
  from t_issue_log isso
	where 
	  DATE_FORMAT(isso.create_time,'%Y-%m-%d') = #{data.submitTime}
	group by isso.issue_id
)a 
left join t_issue_log b on a.logId = b.id 
left join t_issue c on b.issue_id = c.id 
where b.update_status = 'close'
and c.reporter = #{data.createBy}
and c.type = 'bug'
 union all 
/*已关闭的需求 -测试人*/
select
'已完成的工作' as category,
'今日已关闭的需求' as subCategory,
	c.id issueId,
	c.title as title,0 as countCas,
	c.proj_id as projId,
  c.sprint_id as sprintId,c.type as issType,
	DATE_FORMAT(b.create_time,'%Y-%m-%d') as submitTime
from (
	select max(isso.id)as logId
  from t_issue_log isso
	where 
	  DATE_FORMAT(isso.create_time,'%Y-%m-%d') = #{data.submitTime}
	group by isso.issue_id
)a 
left join t_issue_log b on a.logId = b.id 
left join 
(select 
	case when test_by is null  then reporter
	else test_by  end  as test_by,
	sprint_id as sprint_id,type as type,proj_id as proj_id,title as title ,id as id ,
	reporter as reporter
from t_issue
)
c on b.issue_id = c.id 
where b.update_status = 'close'
and c.test_by = #{data.createBy}
and c.type in ('feature','improvement')
union all 
/*今日新设计的测试用例 --测试设计人*/
select 
	'已完成的工作' as category,
	CONCAT(subCategory,countCas,'个') as subCategory ,
	issueId,title,countCas,projId,
	sprintId,issType,submitTime
 from 
(
select '已完成的工作' as category,'今日新设计的测试用例' as subCategory,
iss.id issueId ,
iss.title as title ,count(tca.name) as countCas 
,iss.proj_id as projId,iss.sprint_id as sprintId ,iss.type issType,DATE_FORMAT(tca.create_time,'%Y-%m-%d') as submitTime 
from  t_testcase tca 
left join t_issue iss on  tca.issue_id = iss.id
where DATE_FORMAT(tca.create_time,'%Y-%m-%d') = #{data.submitTime}
and iss.test_design_by = #{data.createBy}
group by tca.issue_id
) a
union all 
/*今日新报告的缺陷 --报告人*/
select
'已完成的工作' as category,
	case when c.type in ('feature','improvement') then '今日新报告的需求'
	else '今日新报告的缺陷' end  as subCategory,
	c.id issueId,
	c.title as title,0 as countCas,
	c.proj_id as projId,
  c.sprint_id as sprintId,c.type as issType,
	DATE_FORMAT(b.create_time,'%Y-%m-%d') as submitTime
from (
	select max(isso.id)as logId
  from t_issue_log isso
	where 
	  DATE_FORMAT(isso.create_time,'%Y-%m-%d') = #{data.submitTime}
	  /*and isso.type = 'new'*/
	group by isso.issue_id
)a 
left join t_issue_log b on a.logId = b.id 
left join t_issue c on b.issue_id = c.id 
where b.update_status = 'open'
and c.reporter =  #{data.createBy}
union all 

/*进行中的工作项 --处理人*/
select
'进行中的工作' as category,
'进行中的工作项' as subCategory,
	c.id issueId,
	c.title as title,0 as countCas,
	c.proj_id as projId,
  c.sprint_id as sprintId,c.type as issType,
	DATE_FORMAT(b.create_time,'%Y-%m-%d') as submitTime
from (
	select max(isso.id)as logId
  from t_issue_log isso
	where 
	  DATE_FORMAT(isso.create_time,'%Y-%m-%d') <= #{data.submitTime}
	group by isso.issue_id
)a 
left join t_issue_log b on a.logId = b.id 
left join t_issue c on b.issue_id = c.id 
where c.assignee = #{data.createBy}
and b.update_status in('workin')

union all 
/*测试中的工作项--测试人+报告人*/
select
'进行中的工作' as category,
'测试中的工作项' as subCategory,
	c.id issueId,
	c.title as title,0 as countCas,
	c.proj_id as projId,
  c.sprint_id as sprintId,c.type as issType,
	DATE_FORMAT(b.create_time,'%Y-%m-%d') as submitTime
from (
	select max(isso.id)as logId
  from t_issue_log isso
	where 
	  DATE_FORMAT(isso.create_time,'%Y-%m-%d') <= #{data.submitTime}
	group by isso.issue_id
)a 
left join t_issue_log b on a.logId = b.id 
left join 
(select 
	case when test_by is null  then reporter
		else test_by  end  as test_by,
sprint_id as sprint_id,type as type,proj_id as proj_id,title as title ,id as id ,reporter as reporter

from t_issue )
c on b.issue_id = c.id 
where c.test_by = #{data.createBy}
and b.update_status in('test')

union all 
/*待办工作项--处理人*/
select
'待办的工作' as category,'待办工作项' as subCategory,
	c.id issueId,
	c.title as title,0 as countCas,
	c.proj_id as projId,
  c.sprint_id as sprintId,c.type as issType,
	DATE_FORMAT(b.create_time,'%Y-%m-%d') as submitTime
from (
	select max(isso.id)as logId
  from t_issue_log isso
	where 
	  DATE_FORMAT(isso.create_time,'%Y-%m-%d') <= #{data.submitTime}
	group by isso.issue_id
)a 
left join t_issue_log b on a.logId = b.id 
left join  t_issue c on b.issue_id = c.id 
where c.assignee = #{data.createBy}
and b.update_status in('open','reopen')

union all 
/*待办的工作--测试人取需求*/
select
'待办的工作' as category,'已解决的需求' as subCategory ,
	c.id issueId,
	c.title as title,0 as countCas,
	c.proj_id as projId,
  c.sprint_id as sprintId,c.type as issType,
	DATE_FORMAT(b.create_time,'%Y-%m-%d') as submitTime
from (
	select max(isso.id)as logId
  from t_issue_log isso
	where 
	  DATE_FORMAT(isso.create_time,'%Y-%m-%d') <= #{data.submitTime}
	group by isso.issue_id
)a 
left join t_issue_log b on a.logId = b.id 
left join  (select 
	case when test_by is null  then reporter
		else test_by  end  as test_by,sprint_id as sprint_id,type as type,proj_id as proj_id,title as title ,id as id ,reporter as reporter

from t_issue ) c on b.issue_id = c.id 
where c.test_by = #{data.createBy}
and c.type in ('feature','improvement')
and b.update_status = 'resolve'

union all 
/*待办的工作--报告人取缺陷*/
select
'待办的工作' as category,'已解决的缺陷' as subCategory ,
	c.id issueId,
	c.title as title,0 as countCas,
	c.proj_id as projId,
  	c.sprint_id as sprintId,c.type as issType,
	DATE_FORMAT(b.create_time,'%Y-%m-%d') as submitTime
from (
	select max(isso.id)as logId
  from t_issue_log isso
	where 
	  DATE_FORMAT(isso.create_time,'%Y-%m-%d') <=  #{data.submitTime}
	group by isso.issue_id
)a 
left join t_issue_log b on a.logId = b.id 
left join t_issue  c on b.issue_id = c.id 
where c.reporter = #{data.createBy}
and c.type = 'bug'
and b.update_status = 'resolve'

) S
left join t_issue b on S.issueId = b.id 
LEFT JOIN 
		t_project pro 
	ON 
		S.projId = pro.id		
	LEFT JOIN 
		t_sprint sprint
	ON 
		S.sprintId = sprint.id 	


) M 