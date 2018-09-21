select * from (
	SELECT 
	  sale.id as cId,
	  sale.clues_id as cluesId,
	  sale.join_name as joinName,
	  sale.place as place,
	  sale.content as content,
	  sale.marks as marks,
	  sale.create_time as createTime,
	  sale.update_time as updateTime,
	  e1.name as createByName,
  	  e2.name as updateByName,
  	  case when isnull(clues.proname) then '' else clues.proname end as proName
	  from t_saleact sale
	  left join t_employee e1 ON e1.id = sale.create_by
  	  left join t_employee e2 ON e2.id = sale.update_by
  	  left join t_sales_clues clues on sale.clues_id=clues.id
) a 