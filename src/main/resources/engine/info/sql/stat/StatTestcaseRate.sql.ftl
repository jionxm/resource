select * from(
select
t.proj_id as projId,
t.sprint_id as sprintId,
t.report_date as date,
case when t.feature_num is null or t.feature_num = 0 then 0 else
convert(t.testcase_cover *100 /t.feature_num ,decimal(10,2)) end as testCaseCoverRate,
case when t.testcase_num is null or t.testcase_num = 0 then 0 else
convert(t.testcase_pass * 100 /t.testcase_num,decimal(10,2)) end as testCasePassRate
from
t_report_testcase t
left join t_sprint s  on t.sprint_id = s.id
where t.report_date in(select date  from t_calendar where workday =  '1')
and t.report_date BETWEEN s.start_time  and s.end_time
and  case when isnull(#{data.projId}) or #{data.projId}=''  then 1=1  else t.proj_id = #{data.projId} end
and  case when isnull(#{data.sprintId}) or #{data.sprintId}=''  then 1=1  else t.sprint_id = #{data.sprintId} end

) testCaseCover