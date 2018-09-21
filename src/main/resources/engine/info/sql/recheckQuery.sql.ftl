SELECT
 *
FROM
 (
  SELECT
   t.id AS id,
   t.proname AS proName, 
   t.follow_id AS followId,
   t.init_contacts AS initContacts
  FROM
   t_sales_clues t
  LEFT JOIN t_customer k ON t.customer_id = k.id
  LEFT JOIN t_employee e ON t.follow_id = e.id
  LEFT JOIN t_employee e1 ON t.create_by = e1.id
  LEFT JOIN t_employee e2 ON t.update_by = e2.id
  LEFT JOIN t_project p ON t.proname = p.name
  LEFT JOIN t_org o ON t.reportorg = o.id
  LEFT JOIN t_contacts l ON t.reportor = l.name
  LEFT JOIN t_dict d ON t.stage = d. CODE
  AND d.cata_code = 't_sales_clues.stage'
 ) a


