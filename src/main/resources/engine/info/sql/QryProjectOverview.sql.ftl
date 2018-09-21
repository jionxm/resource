select * from (
        select a.* ,count(pe.emp_id) as empCnt from  (select
        p.create_time,
        p.name ,
        p.id,
        sum(case when i.status not in ( 'close', 'cancel' ) and i.type in ( 'feature', 'improvement' )then 1 else 0 end ) as featureUnfix,
        sum(case when i.type in ( 'feature', 'improvement' ) then 1 else 0 end ) as feature,
        sum(case when i.type = 'bug' and  i.status not in ( 'close', 'cancel' ) then 1 else 0 end ) as bugUnclose,
        sum(case when i.type = 'bug' then 1 else 0 end ) as bug,
        case when (sum(case when i.status not in ( 'close', 'cancel' ) and i.type in ( 'feature', 'improvement' )then 1 else 0 end ) = 0 ) then '0.00%' 
			 else (CONCAT(convert((sum(case when i.status in ( 'close', 'cancel' ) and i.type in ( 'feature', 'improvement' )then 1 else 0 end )/ sum(case when i.type in ( 'feature', 'improvement' ) then 1 else 0 end ) * 100) 
							,decimal(10,2)),'%'))
			 end as completeFtPer,
		case when (sum(case when i.type = 'bug' and  i.status not in ( 'close', 'cancel' ) then 1 else 0 end ) = 0) then '0.00%'
			 else (CONCAT(convert((sum(case when i.type = 'bug' and  i.status in ( 'close', 'cancel' ) then 1 else 0 end )/sum(case when i.type = 'bug' then 1 else 0 end ) * 100) 
							,decimal(10,2)),'%'))
			 end as closeBugPer
        from
        t_project p
        Left join t_issue i on p.id = i.proj_id
        where p.status = 'open'
        GROUP BY p.name
        order by p.create_time desc
        ) a
        Left join t_proj_emp pe on a.id = pe.proj_id
        GROUP BY a.name
        order by a.create_time desc

) projOverview