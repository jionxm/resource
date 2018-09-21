select *  from (
	select t.id as id,
		   t.status as status,
		   t.del_reason as delReason,
		   t.id as cluesId,
		   t.proname as proName,
		   t.follow_id as followId,
		   e.name as followName,
		   t.stage as stage,
		   d.name as stageName,
		   t.init_contacts as initContacts,
		   t.init_contacts_tel as initContactsTel,
		   t.customer_id as customerId,
		   t.budget as budget,
		   t.content as content,
		   t.reportor as reportName,
		   t.reportorg as reportOrg,
		   t.report_contact as reportContact,
		   t.create_time as createTime,
		   t.create_by as createBy,
		   t.key_tel1 as keyTel1,
		   t.key1_post as key1Post,
		   t.key1_duty as key1Duty,
		   t.key_contact1 as keyContact1,
		   t.key_tel2 as keyTel2,
		   t.key2_post as key2Post,
		   t.key2_duty as key2Duty,
		   t.key_contact2 as keyContact2,
		   t.key_tel3 as keyTel3,
		   t.key3_post as key3Post,
		   t.key3_duty as key3Duty,
		   t.key_contact3 as keyContact3,
		   e1.name as createByName,
		   t.update_time as updateTime,
		   t.update_by as updateBy,
		   e2.name as updateByName,
		   e4.name as sellerName,
		   t.contract_amount as contractAmount,
		   t.sales_revenue as salesRevenue,
		   t.bid,
		   t.urgency,
		   t.seller,
		   t.presales,
		   (select saler.sales_update from t_seller_act saler  where saler.id=max(tp.id) ) as preSalesUpdate,
		   (select saler.sales_update_time from t_seller_act saler  where saler.id=max(tp.id) ) as preUpdateTime,
		   (select saler.sales_update from t_seller_act saler  where saler.id=max(ts.id) ) as salesUpdate,
		   (select saler.sales_update_time from t_seller_act saler  where saler.id=max(ts.id) ) as salesUpdateTime,
		   t.estimate_time as estimateTime,
		   e3.name as presalesName,
		   case when t.urgency=0 then '正常'
		        when t.urgency=1 then '紧急' end as urgencyName,
		   case when t.bid=0 then '否'
		        when t.bid=1 then '是' end as bidName,
		   t.importance_degree as importanceDegree,
		   t.project_type as projectType,
		   t.by_inputting_time as byInputtingTime,
		   d1.name as importanceDegreeName,
		   d2.name as projectTypeName,
		   t.project_start_time as projectStartTime,
		   t.success_rate as successRate,
		   report_time as reportTime,
		   case when isnull(k.name) then '' else k.name end as customerName,
		   (SELECT COUNT(s.id) FROM t_seller_act s where  s.clues_id = t.id)as actNum, 
		   (SELECT COUNT(sf.id) FROM t_sales_file sf where sf.clues_id = t.id) as filesNum,
         (SELECT update_time FROM t_saleact where clues_id = t.id ORDER BY update_time desc LIMIT 0,1) as fianlTime
   from t_sales_clues t
	left join t_customer k on t.customer_id=k.id
	left join t_employee e on t.follow_id=e.id
	left join t_employee e1 on t.create_by=e1.id
	left join t_employee e2 on t.update_by=e2.id
	left join t_dict d on t.stage=d.code and d.cata_code='t_sales_clues.stage'
	left join t_dict d1 on t.importance_degree=d1.code and d1.cata_code='t_sales_clues.importance_degree' 
	left join t_dict d2 on t.project_type=d2.code and d2.cata_code='t_sales_clues.priject_type' 
	left join t_seller_act tp ON  t.id=tp.clues_id and tp.type='preSale'
	left join t_seller_act ts ON t.id=ts.clues_id and ts.type='saler'
	left join t_employee e3 on t.presales=e3.id 
	left join t_employee e4 on t.seller=e4.id
	group by t.id
    )a