select * from (
SELECT src.code AS id,src.NAME as name,m2.name as parentName FROM ( 
  SELECT code,parent,name
     , @pathnodes:= IF( ISNULL(parent)||parent='',code, 
           CONCAT_WS(',',
           IF( LOCATE( CONCAT('|',parent,':'),@pathall) > 0  , 
               SUBSTRING_INDEX( SUBSTRING_INDEX(@pathall,CONCAT('|',parent,':'),-1),'|',1)
              ,@pathnodes ) ,code  ) )paths
    ,@pathall:=CONCAT(@pathall,'|',code,':', @pathnodes ,'|') pathall 
        FROM  t_menu, 
    (SELECT  @pathall:='',@pathnodes:='') vv

)src
LEFT JOIN t_menu m2 ON m2.`code`=src.parent
where 
case when ISNULL(#{data.id})||#{data.id}='' then 1=1
ELSE
paths 
NOT like CONCAT(
(
SELECT paths from (
     SELECT  @pathnodes:= IF( ISNULL(parent)||parent='',code, 
           CONCAT_WS(',',
           IF( LOCATE( CONCAT('|',parent,':'),@pathall) > 0  , 
               SUBSTRING_INDEX( SUBSTRING_INDEX(@pathall,CONCAT('|',parent,':'),-1),'|',1)
              ,@pathnodes ) ,code  ) )paths
    ,@pathall:=CONCAT(@pathall,'|',code,':', @pathnodes ,'|') pathall ,code,name
        FROM  t_menu, 
    (SELECT  @pathall:='',@pathnodes:='') vv

)a where code=#{data.id}
 
),'%'
)
end
AND src.code <>(SELECT o2.parent from t_menu o2 where code=#{data.id})
 ) a 