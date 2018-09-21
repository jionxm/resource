select * from (
    SELECT
    l.id as id,
    l.emp_id as empId,
    emp.name as empName,
    l.user_id as userId,
     user.name as userName,
    l.access_time as accessTime,
    l.url ,
    l.result ,
    l.cost ,
    l.client_ip as clientIp,
    l.server_ip as serverIp,
    l.server_port as serverPort,
    l.user_agent as userAgent
    FROM (select l1.*
    FROM t_access_log l1
    where case when #{data.ge_accessTime} is null then 1=1  else DATE_FORMAT(l1.access_time,'%Y-%m-%d')>=DATE_FORMAT(#{data.ge_accessTime},'%Y-%m-%d')  end
    and case when #{data.dl_accessTime} is null then 1=1  else DATE_FORMAT(l1.access_time,'%Y-%m-%d')< DATE_FORMAT(date_add(#{data.dl_accessTime}, interval 1 day),'%Y-%m-%d') end
    )l
    LEFT JOIN t_user user
    on l.user_id =user.id
    LEFT JOIN t_employee  emp
    on l.emp_id= emp.id
    order by accessTime desc
) a