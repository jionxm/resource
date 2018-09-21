select * from (
	SELECT 
	  ts.id as id,
	  ts.join_name as joinName,
	  ts.clues_id as cluesId,
	  ts.place as place,
	  ts.content as content,
	  ts.marks as marks,
	  ts.create_time as createTime,
	  ts.create_by as createBy,
	  ts.update_time as updateTime,
	  ts.update_by as updateBy
	  from t_sales_clues tsc 
	  left join t_saleact ts on tsc.id=ts.clues_id
) a  