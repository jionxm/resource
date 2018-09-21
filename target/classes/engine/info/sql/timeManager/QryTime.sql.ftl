select * from 
(
   select 
   d.ID as id,
   d.DAY_SHORT_DESC as dayShort,
   d.DAY_LONG_DESC as dayLong,
   d.MONTH_LONG_DESC as monthLong,
   d.QUARTER_LONG_DESC as quarterLong,
   d.WEEK_DESC as week,
   t.name as type
   from dim_day d
   left join t_dict t on t.code = d.type and t.cata_code = 'dim_day.type'
   
)a





