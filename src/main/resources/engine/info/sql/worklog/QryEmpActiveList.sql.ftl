select * from 
(
select * from 
(
select distinct e.id as empId,
	e.`name` empName,
	o.id as orgId,
	o.`name` orgName,
	dei.issueCount as devNum,   /*开发待办工作项数*/
	dwork.issueIdCount as doingNum, /*开发进行中工作项数*/
	ted.iTestCount as testNum,    /*待办测试工作项数*/
	wtest.tingCount	as testingNum,        /*进行中测试工作项数*/
	b.leaveTime, /*最后活跃时间*/
	c.subTime,  /*git代码最后提交时间*/
	wg.createTime				/*工作日报最后提交日期*/

 from  t_employee e
left join t_org o on e.org_id = o.id
left join t_proj_emp pe on pe.emp_id=e.id
left join t_project pj  on  pe.proj_id = pj.id
left join 
	(
		select count(c.id) issueCount,c.assignee
		from (
				select max(isso.id)as logId
				from t_issue_log isso
				group by isso.issue_id
					)a 
		left join t_issue_log b on a.logId = b.id 
		left join  t_issue c on b.issue_id = c.id 
		and b.update_status in('open','reopen') 
		group by c.assignee 
	) dei on dei.assignee = e.id
left join 
	(
		select
				count(c.id) issueIdCount,
				c.assignee
			from (
				select max(isso.id)as logId
				from t_issue_log isso
				group by isso.issue_id
			)a 
			left join t_issue_log b on a.logId = b.id 
			left join t_issue c on b.issue_id = c.id 
			and b.update_status in('workin')
			group by c.assignee 
		) dwork on dwork.assignee = e.id
left join 
		(
			select
					count(c.id) iTestCount,
					c.test_by
				from (
					select max(isso.id)as logId
					from t_issue_log isso
					group by isso.issue_id
				)a 
				left join t_issue_log b on a.logId = b.id 
				left join  
					(select case when test_by is null  then reporter
						else test_by  end  as test_by,
						sprint_id as sprint_id,
						type as type,proj_id as proj_id,
						title as title ,id as id 
				from t_issue 
					) c on b.issue_id = c.id 
				where 1=1 /*(c.test_by = '193' or c.reporter = '193')*/
				and b.update_status = 'resolve'
				group by c.test_by
				order by DATE_FORMAT(b.create_time,'%Y-%m-%d') desc 
		) ted on ted.test_by = e.id
left join 
	(
			select
				count(c.id) tingCount,
				c.test_by
			from (
				select max(isso.id)as logId
				from t_issue_log isso
				group by isso.issue_id
			)a 
			left join t_issue_log b on a.logId = b.id 
			left join 
				(select 
					case when test_by is null  then reporter
					else test_by  end  as test_by,
					sprint_id as sprint_id,type as type,proj_id as proj_id,
					title as title ,id as id ,reporter as reporter
			from t_issue 
					) c on b.issue_id = c.id 
			/**where c.test_by = '193' **/
			where b.update_status in('test')
			group by c.test_by 
	) wtest on wtest.test_by = e.id

left join 
	(
		select max(date) subTime, u.`name`,u.emp_id from	t_commit_log cl 
		left join t_user u on cl.author = u.`name`
		left join t_employee e on u.emp_id = e.id
		group by u.emp_id
	) c on  c.emp_id = e.id
left join 
	(
		select max(update_time) leaveTime,update_by from t_issue_log  group  by update_by  
	) b on e.id = b.update_by
left JOIN
	(
		select max(wl.create_time) createTime,wl.create_by createBy from t_worklog wl group by wl.create_by
	)wg on wg.createBy = e.id

) M 
where M.orgId = #{data.orgId}
union
select * from 
(
select distinct e.id as empId,
	e.`name` empName,
	o.pid as orgId,
	o.`name` orgName,
	dei.issueCount as devNum,   /*开发待办工作项数*/
	dwork.issueIdCount as doingNum, /*开发进行中工作项数*/
	ted.iTestCount as testNum,    /*待办测试工作项数*/
	wtest.tingCount	as testingNum,        /*进行中测试工作项数*/
	b.leaveTime, /*最后活跃时间*/
	c.subTime,  /*git代码最后提交时间*/
	wg.createTime				/*工作日报最后提交日期*/

 from  t_employee e
left join t_org o on e.org_id = o.id
left join t_proj_emp pe on pe.emp_id=e.id
left join t_project pj  on  pe.proj_id = pj.id
left join 
	(
		select count(c.id) issueCount,c.assignee
		from (
				select max(isso.id)as logId
				from t_issue_log isso
				group by isso.issue_id
					)a 
		left join t_issue_log b on a.logId = b.id 
		left join  t_issue c on b.issue_id = c.id 
		and b.update_status in('open','reopen') 
		group by c.assignee 
	) dei on dei.assignee = e.id
left join 
	(
		select
				count(c.id) issueIdCount,
				c.assignee
			from (
				select max(isso.id)as logId
				from t_issue_log isso
				group by isso.issue_id
			)a 
			left join t_issue_log b on a.logId = b.id 
			left join t_issue c on b.issue_id = c.id 
			and b.update_status in('workin')
			group by c.assignee 
		) dwork on dwork.assignee = e.id
left join 
		(
			select
					count(c.id) iTestCount,
					c.test_by
				from (
					select max(isso.id)as logId
					from t_issue_log isso
					group by isso.issue_id
				)a 
				left join t_issue_log b on a.logId = b.id 
				left join  
					(select case when test_by is null  then reporter
						else test_by  end  as test_by,
						sprint_id as sprint_id,
						type as type,proj_id as proj_id,
						title as title ,id as id 
				from t_issue 
					) c on b.issue_id = c.id 
				where 1=1 /*(c.test_by = '193' or c.reporter = '193')*/
				and b.update_status = 'resolve'
				group by c.test_by
				order by DATE_FORMAT(b.create_time,'%Y-%m-%d') desc 
		) ted on ted.test_by = e.id
left join 
	(
			select
				count(c.id) tingCount,
				c.test_by
			from (
				select max(isso.id)as logId
				from t_issue_log isso
				group by isso.issue_id
			)a 
			left join t_issue_log b on a.logId = b.id 
			left join 
				(select 
					case when test_by is null  then reporter
					else test_by  end  as test_by,
					sprint_id as sprint_id,type as type,proj_id as proj_id,
					title as title ,id as id ,reporter as reporter
			from t_issue 
					) c on b.issue_id = c.id 
			/**where c.test_by = '193' **/
			where b.update_status in('test')
			group by c.test_by 
	) wtest on wtest.test_by = e.id

left join 
	(
		select max(date) subTime, u.`name`,u.emp_id from	t_commit_log cl 
		left join t_user u on cl.author = u.`name`
		left join t_employee e on u.emp_id = e.id
		group by u.emp_id
	) c on  c.emp_id = e.id
left join 
	(
		select max(update_time) leaveTime,update_by from t_issue_log  group  by update_by  
	) b on e.id = b.update_by
left JOIN
	(
		select max(wl.create_time) createTime,wl.create_by createBy from t_worklog wl group by wl.create_by
	)wg on wg.createBy = e.id
) N
where N.orgId = #{data.orgId}
union
select * from 
(
select distinct e.id as empId,
	e.`name` empName,
	o.pid as orgId,
	o.`name` orgName,
	dei.issueCount as devNum,   /*开发待办工作项数*/
	dwork.issueIdCount as doingNum, /*开发进行中工作项数*/
	ted.iTestCount as testNum,    /*待办测试工作项数*/
	wtest.tingCount	as testingNum,        /*进行中测试工作项数*/
	b.leaveTime, /*最后活跃时间*/
	c.subTime,  /*git代码最后提交时间*/
	wg.createTime				/*工作日报最后提交日期*/

 from  
(select pid as pid,name ,id   from t_org where pid in 
(select id from t_org where pid = #{data.orgId})
) o  
left join t_employee e on e.org_id = o.id
left join t_proj_emp pe on pe.emp_id=e.id
left join t_project pj  on  pe.proj_id = pj.id
left join 
	(
		select count(c.id) issueCount,c.assignee
		from (
				select max(isso.id)as logId
				from t_issue_log isso
				group by isso.issue_id
					)a 
		left join t_issue_log b on a.logId = b.id 
		left join  t_issue c on b.issue_id = c.id 
		and b.update_status in('open','reopen') 
		group by c.assignee 
	) dei on dei.assignee = e.id
left join 
	(
		select
				count(c.id) issueIdCount,
				c.assignee
			from (
				select max(isso.id)as logId
				from t_issue_log isso
				group by isso.issue_id
			)a 
			left join t_issue_log b on a.logId = b.id 
			left join t_issue c on b.issue_id = c.id 
			and b.update_status in('workin')
			group by c.assignee 
		) dwork on dwork.assignee = e.id
left join 
		(
			select
					count(c.id) iTestCount,
					c.test_by
				from (
					select max(isso.id)as logId
					from t_issue_log isso
					group by isso.issue_id
				)a 
				left join t_issue_log b on a.logId = b.id 
				left join  
					(select case when test_by is null  then reporter
						else test_by  end  as test_by,
						sprint_id as sprint_id,
						type as type,proj_id as proj_id,
						title as title ,id as id 
				from t_issue 
					) c on b.issue_id = c.id 
				where 1=1 /*(c.test_by = '193' or c.reporter = '193')*/
				and b.update_status = 'resolve'
				group by c.test_by
				order by DATE_FORMAT(b.create_time,'%Y-%m-%d') desc 
		) ted on ted.test_by = e.id
left join 
	(
			select
				count(c.id) tingCount,
				c.test_by
			from (
				select max(isso.id)as logId
				from t_issue_log isso
				group by isso.issue_id
			)a 
			left join t_issue_log b on a.logId = b.id 
			left join 
				(select 
					case when test_by is null  then reporter
					else test_by  end  as test_by,
					sprint_id as sprint_id,type as type,proj_id as proj_id,
					title as title ,id as id ,reporter as reporter
			from t_issue 
					) c on b.issue_id = c.id 
			/**where c.test_by = '193' **/
			where b.update_status in('test')
			group by c.test_by 
	) wtest on wtest.test_by = e.id

left join 
	(
		select max(date) subTime, u.`name`,u.emp_id from	t_commit_log cl 
		left join t_user u on cl.author = u.`name`
		left join t_employee e on u.emp_id = e.id
		group by u.emp_id
	) c on  c.emp_id = e.id
left join 
	(
		select max(update_time) leaveTime,update_by from t_issue_log  group  by update_by  
	) b on e.id = b.update_by
left JOIN
	(
		select max(wl.create_time) createTime,wl.create_by createBy from t_worklog wl group by wl.create_by
	)wg on wg.createBy = e.id
) S

)aaa