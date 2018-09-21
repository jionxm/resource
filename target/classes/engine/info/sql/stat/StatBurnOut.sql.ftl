select * from (
    select c.proj_id as projId,
    c.sprint_id as sprintId,
    c.name as date,
    c.lastDevWork,
    c.lastWork,
c.firstValue3 - (c.rownum - 1)*c.firstValue3/(c.total3-1) as lastDevWorkBase,
case when c.name <= convert(c.test_start_time,date) then c.firstValue4  else c.firstValue4 - (c.rownum+c.total4-c.total3-1)*c.firstValue4/(c.total4-1) end as lastWorkBase
    from
    (select aa.*,b.firstValue3 , b.firstValue4,cc.total3,cc1.total4 from (SELECT @rownum:=@rownum+1 rownum,
    case when a.proj_id is null then #{data.projId} else a.proj_id end as proj_id,
    case when a.sprint_id is null then #{data.sprintId} else a.sprint_id end as sprint_id,
    a.date  as name,
    a.test_start_time,
    case when a.report_date BETWEEN a.start_time  and a.end_time   then (a.issue_open+a.issue_workin+a.bug_open+a.bug_workin+a.bug_reopen)  else  '' end as lastDevWork,
    case when a.report_date BETWEEN a.start_time  and a.test_end_time then
    (a.issue_open+a.issue_workin+a.issue_reopen+a.issue_resolve+a.issue_test+a.bug_open+a.bug_workin+a.bug_reopen+a.bug_resolve+a.bug_test) else '' end as lastWork
    from (
select  @rownum:=0,  ca.date,
tt.* from (select date   from t_calendar
where workday =  '1'
and  date BETWEEN (select
		case when a3.reportData >  p.start_time  then a3.reportData else  p.start_time end  as report_start_data
		from (select  min(a2.report_date) as reportData,a2.proj_id,a2.sprint_id
		from t_report_burnout a2
		GROUP BY a2.proj_id,a2.sprint_id ) a3 inner join  t_sprint p
    on a3.sprint_id = p.id   where    p.proj_id = #{data.projId} and p.id = #{data.sprintId} )
  and (select t.end_time from t_sprint  t where t.proj_id = #{data.projId} and t.id= #{data.sprintId}) ) ca
 left  join
   ( select
    t.*,p.start_time,
    p.end_time,
    p.test_start_time,
    p.test_end_time
    from
    t_report_burnout t
    inner join t_sprint p
    on t.sprint_id = p.id
		where p.proj_id = #{data.projId} and p.id = #{data.sprintId}  )
		tt
		on  ca.date = convert(tt.report_date,date)
    ) a    ) aa left join
    (
    select
    t.proj_id,
    t.sprint_id ,
    case when DATE_FORMAT(t.report_date,'%Y-%m-%d')=DATE_FORMAT(a4.report_start_data,'%Y-%m-%d')  then (t.issue_open+t.issue_workin+t.bug_open+t.bug_workin+t.bug_reopen)  else  0 end as firstValue3,
    case when  DATE_FORMAT(t.report_date,'%Y-%m-%d')=DATE_FORMAT(a4.report_start_data,'%Y-%m-%d') then
    (t.issue_open+t.issue_workin+t.issue_reopen+t.issue_resolve+t.issue_test+t.bug_open+t.bug_workin+t.bug_reopen+t.bug_resolve+t.bug_test) else 0 end as firstValue4
    from
    t_report_burnout t
		inner join (select
		case when a3.reportData >  p.start_time  then a3.reportData else  p.start_time end  as report_start_data,
     case when a3.reportData > p1.test_start_time then a3.reportData else p.test_start_time end  as report_teststart_data,
    a3.proj_id,a3.sprint_id
		from (select  min(a2.report_date) as reportData,a2.proj_id,a2.sprint_id
		from t_report_burnout a2
		GROUP BY a2.proj_id,a2.sprint_id ) a3 inner join  t_sprint p
    on a3.sprint_id = p.id
    inner join t_sprint p1 on a3.sprint_id = p1.id
    ) a4
		on t.sprint_id = a4.sprint_id
		where t.report_date = a4.report_start_data
    ) b
    on aa.proj_id =b.proj_id
    and aa.sprint_id =b.sprint_id
    inner join
    (
 select count(date) as total3  from t_calendar
where workday =  '1'
and  date BETWEEN (select
		case when a3.reportData >  p.start_time  then a3.reportData else  p.start_time end  as report_start_data
		from (select  min(a2.report_date) as reportData,a2.proj_id,a2.sprint_id
		from t_report_burnout a2
		GROUP BY a2.proj_id,a2.sprint_id ) a3 inner join  t_sprint p
    on a3.sprint_id = p.id   where    p.proj_id = #{data.projId} and     p.id = #{data.sprintId} )
and (select t.end_time from t_sprint  t where t.proj_id = #{data.projId} and     t.id = #{data.sprintId} )
    ) cc
   inner join
    (
 select count(date) as total4  from t_calendar
where workday =  '1'
and  date BETWEEN (select
		 p.test_start_time end
		from (select  min(a2.report_date) as reportData,a2.proj_id,a2.sprint_id
		from t_report_burnout a2
		GROUP BY a2.proj_id,a2.sprint_id ) a3 inner join  t_sprint p
    on a3.sprint_id = p.id   where    p.proj_id = #{data.projId} and     p.id = #{data.sprintId} )
and (select t.test_end_time from t_sprint  t where t.proj_id = #{data.projId} and     t.id = #{data.sprintId} )
    ) cc1
    ) c
) burnOut