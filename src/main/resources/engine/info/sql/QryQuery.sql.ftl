select * from (
	SELECT 
	  ts.id as cId,
	  tsc.id as id,
	  ts.clues_id as cluesId,
	  ts.join_name as joinName,
	  ts.place as place,
	  ts.content as content,
	  ts.marks as marks,
	  ts.create_time as createTime,
	  ts.update_time as updateTime,
	  e1.name as createByName,
  	  e2.name as updateByName
	  from t_saleact ts
	  left join t_sales_clues tsc  on tsc.id=ts.clues_id
	  left join t_employee e1 ON e1.id = tsc.create_by
  	  left join t_employee e2 ON e2.id = tsc.update_by
) a 