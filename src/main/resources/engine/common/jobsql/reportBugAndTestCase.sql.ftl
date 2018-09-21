delete from t_report_bug where report_date = DATE_FORMAT(adddate(now(),-1),'%Y-%m-%d');INSERT INTO t_report_bug (report_date, proj_id, sprint_id, blocker, critical, major, minor)
select DATE_FORMAT(case when t.update_time is null then t.create_time else t.update_time end,'%Y-%m-%d'),
s.proj_id ,
s.id ,
sum(case when t.priority =  'blocker' then 1 else 0 end ) as  blocker,
sum(case when t.priority =  'critical' then 1 else 0 end ) as  critical,
sum(case when t.priority =  'major' then 1 else 0 end ) as  major,
sum(case when t.priority =  'minor' then 1 else 0 end ) as  minor
from
t_sprint s
inner join t_issue t on  t.sprint_id = s.id
where t.type = 'bug'  and t.status not  in  ('close','cancel')
and case when t.update_time is null then t.create_time else t.update_time end BETWEEN s.test_start_time  and s.test_end_time
and  DATE_FORMAT(case when t.update_time is null then t.create_time else t.update_time end,'%Y-%m-%d') =  DATE_FORMAT(adddate(now(),-1),'%Y-%m-%d')
GROUP BY s.proj_id,s.id,DATE_FORMAT(case when t.update_time is null then t.create_time else t.update_time end,'%Y-%m-%d');delete from t_report_testcase where report_date = DATE_FORMAT(adddate(now(),-1),'%Y-%m-%d');INSERT INTO t_report_testcase (proj_id, sprint_id, report_date, feature_num, testcase_num, testcase_cover, testcase_pass)
select
i.proj_id ,
i.sprint_id ,
DATE_FORMAT( case when i.update_time is null then i.create_time else i.update_time end,'%Y-%m-%d'),
count(distinct i.id),
sum( case when t.last_result != 'invalid' then 1 else 0 end ) ,
case when t.id is not  null or t.id <> '' then count(distinct i.id) else 0 end ,
sum( case when t.last_result = 'pass' then 1 else 0 end )
from
t_issue  i
left join t_testcase t on i.id = t.issue_id
where i.type in( 'feature','improvement')
and  DATE_FORMAT(case when i.update_time is null then i.create_time else i.update_time end,'%Y-%m-%d') =  DATE_FORMAT(adddate(now(),-1),'%Y-%m-%d')
GROUP BY i.proj_id,i.sprint_id,DATE_FORMAT(case when i.update_time is null then i.create_time else i.update_time end,'%Y-%m-%d');
