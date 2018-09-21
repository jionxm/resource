select * from (
select id,topic,create_time as createTime,end_time as endTime,cost,message_class as messageClass,message,
type,case when type='send' then '消息发出' else '消息处理' end as typeName, status  from t_message_log  
) a 