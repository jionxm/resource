select * from (
select * from (
	  select
      case when isnull(#{data.projId}) or #{data.projId}='' then '' else p.name end  as projName,
      case when isnull(#{data.projId}) or #{data.projId}=''  then '$ALL'  else p.id end as projId, 
      case when m.proj_id != #{data.projId}   then '$NULL' else m.id end as moduleId,
      case when m.proj_id != #{data.projId} then '$NULL' else m.name end as moduleName,
	 
	  sum(case when i.status='open' then 1 else 0 end ) as open,
      sum(case when i.status='reopen' then 1 else 0 end ) as reopen,
   	  sum(case when i.status='workin' then 1 else 0 end ) as workin,
   	  sum(case when i.status='resolve' then 1 else 0 end ) as resolve,
   	  sum(case when i.status='test' then 1 else 0 end ) as test,
  	  sum(case when i.status='close' then 1 else 0 end ) as close,
   	  sum(case when i.status='cancel' then 1 else 0 end ) as cancel,
  	  sum(case when i.status in ('open','reopen','workin','resolve','test') then 1 else 0 end) as unComplete,
      sum(case when i.status in ('open','reopen') then 1 else 0 end) as unDoing,
  	  sum(case when i.status in ('open','reopen','workin') then 1 else 0 end) as unSolve,
  	  sum(case when i.status in ('open','reopen','workin','resolve','test','close') then 1 else 0 end) as total,
  	  CONCAT(convert(case when sum(case when i.status in('open','reopen','workin','resolve','test','close') then 1 else 0 end) = 0
   	  then 0 else
   	  sum(case when i.status in ('resolve','test','close') then 1 else 0 end ) /sum(case when i.status in ('open','reopen','workin','resolve','test','close') then 1 else 0 end) *100
   	  end ,decimal(10,2)),'%')
   	  as percent,
   	  CONCAT(convert(case when sum(case when i.status in( 'open' ,'reopen' ,'workin','resolve','test','close') then 1 else 0 end) = 0
    	then 0 else
    sum(case when i.status in ('close') then 1 else 0 end ) /sum(case when i.status in ('open','reopen','workin','resolve','test','close') then 1 else 0 end) *100
    	 end ,decimal(10,2)),'%') as resolvePercent
	  from 
   	  t_module m
	  left join (select * from t_project il where 
     case when isnull(#{data.projId}) or #{data.projId}=''  then 1=1    else  il.id = #{data.projId} end
  	  )  p   on m.proj_id=p.id
	  left join t_employee e1  on m.create_by=e1.id
	  left join t_employee e2  on m.update_by=e2.id
	  left join t_issue i on m.id = i.module_id
	    GROUP BY m.id
    order by moduleName
) a 
union all
select
    case when isnull(#{data.projId}) or #{data.projId}='' then '' else p.name end  as projName,
          case when isnull(#{data.projId}) or #{data.projId}=''  then '$ALL'  else p.id end as projId,
    '' as moduleName,
     '合计' as moduleId, 
 
    sum(case when i.status='open' then 1 else 0 end ) as open,
    sum(case when i.status='reopen' then 1 else 0 end ) as reopen,
    sum(case when i.status='workin' then 1 else 0 end ) as workin,
    sum(case when i.status='resolve' then 1 else 0 end ) as resolve,
    sum(case when i.status='test' then 1 else 0 end ) as test,
    sum(case when i.status='close' then 1 else 0 end ) as close,
    sum(case when i.status='cancel' then 1 else 0 end ) as cancel,
  sum(case when i.status in ('open','reopen','workin','resolve','test') then 1 else 0 end) as unComplete,
    sum(case when i.status in ('open','reopen') then 1 else 0 end) as unDoing,
    sum(case when i.status in ('open','reopen','workin') then 1 else 0 end) as unSolve,
    sum(case when i.status in ('open','reopen','workin','resolve','test','close') then 1 else 0 end) as total,
   CONCAT(convert(case when sum(case when i.status in('open','reopen','workin','resolve','test','close') then 1 else 0 end) = 0
    then
    0
    else
    sum(case when i.status in ('resolve','test','close') then 1 else 0 end ) /sum(case when i.status in ('open','reopen','workin','resolve','test','close') then 1 else 0 end) *100
    end ,decimal(10,2)),'%')
    as percent,
    CONCAT(convert(case when sum(case when i.status in( 'open' ,'reopen' ,'workin','resolve','test','close') then 1 else 0 end) = 0
    then
    0
    else
    sum(case when i.status in ('close') then 1 else 0 end ) /sum(case when i.status in ('open','reopen','workin','resolve','test','close') then 1 else 0 end) *100
    end ,decimal(10,2)),'%')
    as resolvePercent
    from
    t_module m
    left join t_issue i on m.id = i.module_id
    left join t_project p  on m.proj_id=p.id
    	where 
    	  case when isnull(#{data.projId}) or #{data.projId}=''  then 1=1    else  p.id = #{data.projId} end
)  a

where total is not null and moduleId !='$NULL'

