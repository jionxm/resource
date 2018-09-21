select * from ( SELECT src.id AS id,src.NAME as name,o3.name as pName,src.pid FROM (
   SELECT id,pid,name
     , @pathnodes:= IF( ISNULL(pid),id, 
           CONCAT_WS(',',
           IF( LOCATE( CONCAT('|',pid,':'),@pathall) > 0  , 
               SUBSTRING_INDEX( SUBSTRING_INDEX(@pathall,CONCAT('|',pid,':'),-1),'|',1)
              ,@pathnodes ) ,id  ) )paths
    ,@pathall:=CONCAT(@pathall,'|',id,':', @pathnodes ,'|') pathall 
        FROM  t_org, 
    (SELECT  @pathall:='',@pathnodes:='') vv

)src
LEFT JOIN t_org o3 ON o3.id=src.pid
where 
case when ISNULL(#{data.id})||#{data.id}='' then 1=1
ELSE
paths 
NOT like CONCAT(
(
SELECT paths from (
     SELECT  @pathnodes:= IF( ISNULL(pid),id, 
           CONCAT_WS(',',
           IF( LOCATE( CONCAT('|',pid,':'),@pathall) > 0  , 
               SUBSTRING_INDEX( SUBSTRING_INDEX(@pathall,CONCAT('|',pid,':'),-1),'|',1)
              ,@pathnodes ) ,id  ) )paths
    ,@pathall:=CONCAT(@pathall,'|',id,':', @pathnodes ,'|') pathall ,id,name
        FROM  t_org, 
    (SELECT  @pathall:='',@pathnodes:='') vv

)a where id=#{data.id}
 
),'%'
)
end
AND src.id <>(SELECT o2.pid from t_org o2 where id=#{data.id})
ORDER BY src.pid, src.name
) a
