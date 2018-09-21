update t_sales_clues
set status = 'building' ,stage='presales',by_inputting_time=now(),update_time=now()
where id=#{primaryFieldValue} ;