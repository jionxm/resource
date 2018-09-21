
select distinct * from ( select
concat_ws('_',w.CATEGORY_ ,w.NAME_) as text, w.KEY_ as value
from
act_re_procdef w
) a
