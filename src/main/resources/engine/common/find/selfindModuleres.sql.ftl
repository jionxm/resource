select * from (
SELECT id,name from t_resource WHERE type='Module'
AND id <>(SELECT o2.parent from t_resource o2 where id=#{data.id})
) a
