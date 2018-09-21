select * from (
select url,name from t_resource where type='component' and is_auth=1
)  a 