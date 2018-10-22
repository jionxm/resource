select * from(
    select
    t.proj_id as projId,
    t.sprint_id as sprintId,
    t.report_date as date,
    t.blocker as blocker,
    t.critical as critical,
    t.major as major,
    t.minor as minor,
    (t.blocker+t.critical+t.major+t.minor) as total
    from
    t_report_bug_new t
    left join t_sprint s  on t.sprint_id = s.id
    where t.report_date BETWEEN s.start_time  and s.test_end_time
    and  case when isnull(#{data.projId}) or #{data.projId}=''  then 1=1  else t.proj_id = #{data.projId} end
    and  case when isnull(#{data.sprintId}) or #{data.sprintId}=''  then 1=1  else t.sprint_id = #{data.sprintId} end
) testCaseCover