select * from (
	select 
	CODE as value,
	NAME as text from t_dict t WHERE cata_code='t_sales_clues.stage' and t.code <> 'potentialbusiness'
	order by seq
 ) a 