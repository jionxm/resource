select * from(
select 
   COLUMN_NAME as filed,
   COLUMN_TYPE as dataTypeAndLength,
   IS_NULLABLE as isNull,
   EXTRA as extra ,
   COLUMN_COMMENT as columnComment ,
   (case 
       when information_schema.columns.COLUMN_KEY = 'PRI' then '主键' 
       when information_schema.columns.COLUMN_KEY = 'UNI' then '唯一' 
       when information_schema.columns.COLUMN_KEY = 'MUL' then '可重复' 
       else information_schema.columns.COLUMN_KEY 
    end) as colkey
from information_schema.columns
where table_schema = (select database()) 
  and table_name = #{data.tableName}
) a 