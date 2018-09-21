select * from(
   select
     t.id as id,
     t.proname as proName,   
     t.follow_id as followId,
     te.name as followName,
     t.stage as stage,
     t.init_contacts_tel as initContactsTel,
     t.init_contacts as initContacts,
     t.key_tel1 as keyTel1,
     t.key_contact1 as keyContact1,
     t.key_tel2 as keyTel2,
     t.key_contact2 as keyContact2,
     t.customer_id as customerId,
     tcus.name as customerName,
     t.budget as budget,
     t.content as content,
     t.reportor as reportName,
     t.reportorg reportOrg,
     t.report_contact as reportContact,
     t.estimate_time as estimateTime,
    
     t.success_rate as successRate,
     t.create_time as createTime,
     t.create_by createBy,
     e1.name as createByName,
     t.update_time as updateTime,
     t.update_by as updateBy,
     e2.name as updateByName,
     d.name as stageName,
     d2.name as statusName
     from t_sales_clues t
     left join t_customer tcus on tcus.id=t.customer_id
     left join t_employee te on te.id=t.follow_id
     left join t_employee e1 on e1.id=t.create_by
     left join t_employee e2 on e2.id=t.update_by
     
	 left join t_dict d on t.stage=d.code and d.cata_code='t_sales_clues.stage'
	 left join t_dict d2 on t.status=d2.code and d2.cata_code='t_sales_clues.status'
	 where t.status<>'notbuilding'
) a