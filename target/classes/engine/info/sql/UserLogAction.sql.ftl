select * from (
select d.name as text,
d.code as value
from t_dict d LEFT JOIN t_dict_cata dc
on d.cata_code = dc.code
where  dc.code ='t_user_log.action'
) a
