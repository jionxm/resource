select * from (
    SELECT
    l.id as id,
    emp.id as empId,
    emp.name as empName,
    l.id as userId,
    user.name as userName,
    l.create_time as createTime,
    l.action,
    d.name as actionName,
    l.ui_name as uiName,
    l.ui_title as uiTitle,
    l.panel_name as panelName,
    l.panel_title as panelTitle,
    l.flow_id as flowId,
    l.exec_result as execResult,
    l.error_reason as errorReason,
    l.client_ip as clientIp,
    t.flow_id as changeLogFlowId,
    t.old_content as old,
    t.new_content as new,
    l.session_id as sessionId,
    e.name  as createByName,
    l.control_title as controlTitle,
    l.create_by as createBy
    from (select l1.*
    FROM t_user_log l1
    where case when #{data.ge_createTime} is null then 1=1  else DATE_FORMAT(l1.create_time,'%Y-%m-%d')>=DATE_FORMAT(#{data.ge_createTime},'%Y-%m-%d')  end
    and case when #{data.dl_createTime} is null then 1=1  else DATE_FORMAT(l1.create_time,'%Y-%m-%d')< DATE_FORMAT(date_add(#{data.dl_createTime}, interval 1 day),'%Y-%m-%d') end
     )l
    LEFT JOIN t_user user
    on l.user_id =user.id
    LEFT JOIN t_employee  emp
    on l.emp_id= emp.id
    LEFT JOIN t_employee e
    on l.create_by =e.id
    Left join t_dict d
    on d.code = l.action
    Left join t_change_log t
    on l.flow_id =t.flow_id
    where d.cata_code = 't_user_log.action'
) a