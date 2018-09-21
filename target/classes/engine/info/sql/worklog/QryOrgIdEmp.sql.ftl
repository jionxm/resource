select * from (
select a.eid as id,a.tid as orgId,a.mid as managerId
 from 
(
select t.id tid,e.id eid,t.manager_id mid from t_org t 
left join t_employee e on t.id = e.org_id 
)a
left join t_employee b on a.mid = b.id  
 ) S