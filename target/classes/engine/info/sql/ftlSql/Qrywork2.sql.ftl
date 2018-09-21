select '我发起的工作项' as item,'eq_reporter' as itemField,'reporterName' as itemFieldName,e.name as empName
	,IFNULL(SUM(CASE issue.status WHEN 'open' THEN 1 ELSE 0 END ),0) 	 openc
	,IFNULL(SUM(CASE issue.status WHEN 'reopen' THEN 1 ELSE 0 END ),0)    reopenc
	,IFNULL(SUM(CASE issue.status WHEN 'workin' THEN 1 ELSE 0 END ),0)    workinc
	,IFNULL(SUM(CASE issue.status WHEN 'resolve' THEN 1 ELSE 0 END ),0)   resolvec
	,IFNULL(SUM(CASE issue.status WHEN 'test' THEN 1 ELSE 0 END ),0) 	 testc
	,IFNULL(SUM(CASE WHEN issue.status in ('open','reopen','workin') THEN 1 ELSE 0 END ),0)   unresolvec 
	,SUM(CASE WHEN issue.status IN ('open','reopen','workin','resolve','test') THEN 1 ELSE 0 END)	as total 
from 
		t_employee e left join t_issue  issue  on e.id = reporter   
		where e.id=#{data.id}  
GROUP BY	e.id 