select * from (
	select a.id,a.event,a.create_time as createTime,a.create_by as createBy,
	ui_name as  uiName,ui_title as uiTitle,panel_name as panelName,panel_title as panelTitle,control_name as controlName,control_title as controlTitle,
	b.emp_name as createByName,a.flow_id as flowId ,
  count(c.flow_id) as changeCount 
	from t_user_log a  
	left join t_employee b on a.create_by =b.emp_id 
  left outer join t_change_log c on a.id=c.user_log_id 
  group by  a.flow_id 
 ) a 