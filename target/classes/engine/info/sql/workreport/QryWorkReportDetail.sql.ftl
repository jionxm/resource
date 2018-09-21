select * from (
	 select 
	 s.id as id,
	 s.submit_time as submitTime,
	 s.submit_by as submitBy,
	 e2.name as submitByName,
	 s.work_summary as workSummary,
	 s.problem as problem,
	 s.tom_workplan as tomWorkplan,
	 e2.org_id as orgId,
	 o.name as orgName,
	 o.manager_id as managerId,
	 e3.name as managerName,
	 s.create_time as createTime,
	 s.create_by as createBy,
	 s.update_time as updateTime,
	 s.update_by as updateBy,
	 e.name as createByName,
	 e1.name as updateByName
	 from t_work_report s
	  
	 left join t_employee e on e.id = s.create_by
	 left join t_employee e1 on e1.id = s.update_by
	 left join t_employee e2 on e2.id = s.submit_by
	 left join t_org o on e2.org_id=o.id
	 left join t_employee e3 on e3.id = o.manager_id
	
 ) a   