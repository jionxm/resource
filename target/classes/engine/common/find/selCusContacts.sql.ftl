select * from (
	select 
	t.id as id,
	t.name as name,
	t.tel AS tel
	from t_contacts t
	where customer_id=#{data.id}
 ) a 