delete from t_report_burnout where report_date = DATE_FORMAT(adddate(now(),-1),'%Y-%m-%d');INSERT INTO t_report_burnout (proj_id, sprint_id, report_date, issue_open, issue_workin, issue_resolve, issue_test, issue_close, issue_cancel, issue_reopen,
bug_open, bug_workin, bug_resolve, bug_test, bug_close, bug_cancel, bug_reopen,
issue_open_workload, issue_workin_workload, issue_resolve_workload, issue_test_workload, issue_close_workload, issue_cancel_workload, issue_reopen_workload,
task_open, task_workin, task_resolve, task_test, task_close, task_cancel, task_reopen
)
select
i.proj_id,
i.sprint_id,
DATE_FORMAT(adddate(now(),-1),'%Y-%m-%d') as report_date,
sum(case when i.status='open' and i.type in ('feature','improvement') then 1 else 0 end ) as issue_open,
sum(case when i.status='workin' and i.type in ('feature','improvement') then 1 else 0 end ) as issue_workin,
sum(case when i.status='resolve' and i.type in ('feature','improvement') then 1 else 0 end ) as issue_resolve,
sum(case when i.status='test' and i.type in ('feature','improvement') then 1 else 0 end ) as issue_test,
sum(case when i.status='close' and i.type in ('feature','improvement') then 1 else 0 end ) as issue_close,
sum(case when i.status='cancel' and i.type in ('feature','improvement') then 1 else 0 end ) as issue_cancel,
sum(case when i.status='reopen' and i.type in ('feature','improvement') then 1 else 0 end ) as issue_reopen,

sum(case when i.status='open' and  i.type = 'bug' then 1 else 0 end ) as bug_open,
sum(case when i.status='workin' and  i.type = 'bug' then 1 else 0 end ) as bug_workin,
sum(case when i.status='resolve' and  i.type = 'bug' then 1 else 0 end ) as bug_resolve,
sum(case when i.status='test' and  i.type = 'bug' then 1 else 0 end ) as bug_test,
sum(case when i.status='close' and  i.type = 'bug' then 1 else 0 end ) as bug_close,
sum(case when i.status='cancel' and  i.type = 'bug' then 1 else 0 end ) as bug_cancel,
sum(case when i.status='reopen' and  i.type = 'bug' then 1 else 0 end ) as bug_reopen,

sum(case when i.status='open' and i.type in ('feature','improvement') then if(isnull(workload),0,workload) else 0 end ) as issue_open_workload,
sum(case when i.status='workin' and i.type in ('feature','improvement') then if(isnull(workload),0,workload)  else 0 end ) as issue_workin_workload,
sum(case when i.status='resolve' and i.type in ('feature','improvement') then if(isnull(workload),0,workload)  else 0 end ) as issue_resolve_workload,
sum(case when i.status='test' and i.type in ('feature','improvement') then if(isnull(workload),0,workload)  else 0 end ) as issue_test_workload,
sum(case when i.status='close' and i.type in ('feature','improvement') then if(isnull(workload),0,workload)  else 0 end ) as issue_close_workload,
sum(case when i.status='cancel' and i.type in ('feature','improvement') then if(isnull(workload),0,workload)  else 0 end ) as issue_cancel_workload,
sum(case when i.status='reopen' and i.type in ('feature','improvement') then if(isnull(workload),0,workload)  else 0 end ) as issue_reopen_workload,

sum(case when i.status='open' and  i.type = 'task' then 1 else 0 end ) as task_open,
sum(case when i.status='workin' and  i.type = 'task' then 1 else 0 end ) as task_workin,
sum(case when i.status='resolve' and  i.type = 'task' then 1 else 0 end ) as task_resolve,
sum(case when i.status='test' and  i.type = 'task' then 1 else 0 end ) as task_test,
sum(case when i.status='close' and  i.type = 'task' then 1 else 0 end ) as task_close,
sum(case when i.status='cancel' and  i.type = 'task' then 1 else 0 end ) as task_cancel,
sum(case when i.status='reopen' and  i.type = 'task' then 1 else 0 end ) as task_reopen
from
t_issue  i
group by i.proj_id,i.sprint_id

