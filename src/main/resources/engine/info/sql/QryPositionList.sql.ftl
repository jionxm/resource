select * from (
	select p.id as id,
	p.`name` as name ,
	p.remark as remark,
	p.create_time as createTime,
	p.create_by as createBy,
	p.update_by as updateBy,
	p.update_time as updateTime,
	count(e.id) as empCount 
	from t_position p
	left join t_employee e on p.id = e.position_id 
	group by p.id
)a 
