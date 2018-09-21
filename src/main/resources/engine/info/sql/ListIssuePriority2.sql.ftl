select * from (
	/*tc.id as id,
	tcs.id as cId,
	tcs.name as contactsName,
	tcs.duty as duty,
	tcs.mobile as mobile,
	tcs.mail as mail,
	tcs.create_time as createTime,
	tcs.create_by as createBy,
	tcs.update_time as updateTime,
	e1.name as createByName,
	e2.name as updateByName,
	tcs.update_by as updateBy
    from  t_contacts  tcs
    left join t_customer tc on tcs.customer_id=tc.id
     left join t_employee e1 ON e1.id = tc.create_by
 	 left join t_employee e2 ON e2.id = tc.update_by*/
 	 select 
 	 c.id as id ,
 	 c.coop_degree as coopDegree,
 	 c.department as department,
 	 c.duty as duty,
 	 c.name as name ,
 	 c.tel as tel ,
 	 tc.name as customerName, 
 	 c.status as status , 
 	 c.customer_id as customerId ,
 	 c.type from t_contacts c
 	 left join t_dict dict on c.type=dict.code and cata_code='t_contacts.type'
 	 left join t_customer tc on c.customer_id=tc.id 
 	 where c.status=0
 ) a 