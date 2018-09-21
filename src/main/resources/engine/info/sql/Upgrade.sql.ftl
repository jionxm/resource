update t_sales_clues 
set stage = case when stage = 'potentialbusiness' then 'presales' 
		when stage ='presales' then 'bid' 
		when stage ='bid' then 'approve' 
		when stage ='approve' then 'signing' 
		when stage ='signing' then 'close' 
		end ,update_time=now()
where id=#{primaryFieldValue} 
