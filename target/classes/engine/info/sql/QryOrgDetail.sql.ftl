select * from (
	select 
	o.id as id,
	(case when  ISNULL(pid) then '1'
			when o.id in(SELECT pid from t_org o2) then '2'
     else '3' end) nodeType,
	o.pid as pid,
	o.name as name,
	o.code as code,
	IFNULL(o.fullname,"")  as fullname,
	o.ext_code as extCode,
	o.phone as phone,
	o.fax as fax,
	o.address as address,
	o.postcode as postcode,
	o.manager_id as managerId,
	e1.name as managerName,
	o.description as description,
	o.create_time as createTime,
	e2.name as createByName,
	o.update_time as updateTime,
	e3.name as updateByName
	from t_org as o
	left join t_employee e1 on e1.id=o.manager_id
	left join t_employee e2 on e2.id=o.create_by
	left join t_employee e3 on e3.id=o.update_by
 ) a 