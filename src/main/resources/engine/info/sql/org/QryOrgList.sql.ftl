select * from (
 select 
    o.id as id,
 	o.id as orgId,
 	o.name as orgName 
 from t_org o
) a