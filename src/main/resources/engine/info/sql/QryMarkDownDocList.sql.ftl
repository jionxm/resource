select * from (
	select  
	d.name as name,
	d.title as title,
	d.property as property,
	case when d.type = '1' then '表单定义'
	else '其他' end as  type,
	d.path as path,
	d.file_id as fileId,
	f.length fileSize,
	d.create_time createTime 
from t_markdown_doc d
left join t_file_index f on d.file_id = f.id 
 ) a 