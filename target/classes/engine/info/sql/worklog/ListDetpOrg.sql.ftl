select * from (
select 
case when a3.`name` is null and a2.`name` is null then a1.`name` 
	when a3.`name` is null then concat(ifnull(a2.name,''),' - ',ifnull(a1.name,''))
	else concat(ifnull(a3.name,'') ,' - ',ifnull(a2.name,''),' - ',ifnull(a1.name,'')) end  as text,
	a1.id as value 
from t_org a1 
left join  t_org a2 on a1.pid=a2.id 
left join  t_org a3 on a2.pid=a3.id 
order by a3.name,a2.name,a3.name  
 ) a 