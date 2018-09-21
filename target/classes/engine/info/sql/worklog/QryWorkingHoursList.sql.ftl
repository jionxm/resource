select * from 
(
select 
case when e.`name` is not null then e.`name` else '合计' end as total,
o.id as orgId,a.resValue as resValue,
/*a.sumTime, a.subBy, */
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-01'),a.hours,0)) AS ri1,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-02'),a.hours,0)) AS ri2,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-03'),a.hours,0)) AS ri3,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-04'),a.hours,0)) AS ri4,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-05'),a.hours,0)) AS ri5,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-06'),a.hours,0)) AS ri6,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-07'),a.hours,0)) AS ri7,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-08'),a.hours,0)) AS ri8,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-09'),a.hours,0)) AS ri9,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-10'),a.hours,0)) AS ri10,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-11'),a.hours,0)) AS ri11,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-12'),a.hours,0)) AS ri12,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-13'),a.hours,0)) AS ri13,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-14'),a.hours,0)) AS ri14,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-15'),a.hours,0)) AS ri15,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-16'),a.hours,0)) AS ri16,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-17'),a.hours,0)) AS ri17,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-18'),a.hours,0)) AS ri18,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-19'),a.hours,0)) AS ri19,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-20'),a.hours,0)) AS ri20,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-21'),a.hours,0)) AS ri21,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-22'),a.hours,0)) AS ri22,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-23'),a.hours,0)) AS ri23,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-24'),a.hours,0)) AS ri24,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-25'),a.hours,0)) AS ri25,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-26'),a.hours,0)) AS ri26,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-27'),a.hours,0)) AS ri27,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-28'),a.hours,0)) AS ri28,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-29'),a.hours,0)) AS ri29,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-30'),a.hours,0)) AS ri30,
sum(if(a.sumTime=CONCAT(DATE_FORMAT(#{data.submitTime}, '%Y-%m'),'-31'),a.hours,0)) AS ri31,
sum(a.hours) sumHours 
from 
(
select DATE_FORMAT(w.submit_time,'%Y-%m-%d') as sumTime,
	w.submit_by as subBy,
	w.hours as hours,
	w.exam_by as examBy,
	w.exam_res as resValue
	from t_worklog w 
	where case when isnull(#{data.resValue}) or #{data.resValue}=''  then 1=1    else  w.exam_res = #{data.resValue}  end  
) a 
right join t_employee e on a.subBy = e.id 
right join t_org o on e.org_id = o.id
where DATE_FORMAT(a.sumTime,'%Y-%m') = DATE_FORMAT(#{data.submitTime}, '%Y-%m')
and o.id = #{data.orgId}
order by CONVERT( total USING gbk ) COLLATE gbk_chinese_ci ASC
)m