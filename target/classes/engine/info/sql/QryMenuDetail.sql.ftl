select * from (
 SELECT
	m.code as id,
	m.code as code,
		(case when  ISNULL(m.parent)OR m.parent=''  then '1'
			when m.code in(SELECT parent from t_menu o2) then '2'
     else '3' end) nodeType,

	m.parent as parent,
	m.name as name,
	m1.name as parentName,
	r.name as resName,
	m.res_id as resId,
	m.target as target,
	d.code as type,
	d.name as typeName,
	m.seq,
	m.create_time as createTime,
	e2.name as createByName,
	m.update_time as updateTime,
	e3.name as updateByName,
	m.levels as levels
 FROM (
     SELECT name,code,parent,res_id,target,seq,create_time,update_time,create_by,update_by,
     @le:= IF (parent=''||ISNULL(parent) ,0,  
         IF( LOCATE( CONCAT('|',parent,':'),@pathlevel)   > 0  ,      
                  SUBSTRING_INDEX( SUBSTRING_INDEX(@pathlevel,CONCAT('|',parent,':'),-1),'|',1) +1
        ,@le+1) ) levels,type
     , @pathlevel:= CONCAT(@pathlevel,'|',code,':', @le ,'|') pathlevel

    ,@pathall:=CONCAT(@pathall,'|',code,':', @pathnodes ,'|') pathall 
        FROM  t_menu, 
    (SELECT @le:=0,@pathlevel:='', @pathall:='',@pathnodes:='') vv
    ORDER BY  parent,code
    ) m
	left join t_employee e2 on e2.id=m.create_by
	left join t_employee e3 on e3.id=m.update_by
	left join t_menu m1 on m1.code=m.parent
	left join t_resource r on r.id=m.res_id
    left join t_dict d on m.type=d.code and d.cata_code='t_menu.type' 

 ) a 