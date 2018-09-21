select * from (
SELECT issue.id AS id,
project.name as projectName,
issue.proj_id as projId,
sprint.`name` AS sprintName,
sprint.`id` AS sprintId,
issue.title AS title,
dict1.`name` as typeName,
dict2.`name` as `statusName`,
dict3.`name` as priorityName,
dict1.`code` as type,
dict2.`code` as `status`,
dict3.`code` as priority,
employee1.`name` AS testDesignByName,
employee1.id AS testDesignBy,
employee3.`name` AS assignee,
employee2.`name` AS testByName,
employee2.id AS testBy,
employee4.`name` AS reporter,
CASE WHEN ISNULL(t2.bugno) THEN '-' ELSE t2.bugno END AS bugno,
CASE WHEN ISNULL(t2.endbugno) THEN '-' ELSE t2.endbugno END AS endbugno,
CASE WHEN ISNULL(t1.passNo) THEN '-' ELSE t1.passNo END AS passNo,
CASE WHEN ISNULL(t1.testNo) THEN '-' ELSE t1.testNo END AS testNo,
issue.create_time as createTime
 from t_issue issue
LEFT JOIN t_project project ON project.id=issue.proj_id
LEFT JOIN t_sprint sprint ON sprint.id=issue.sprint_id
LEFT JOIN t_dict dict1 ON dict1.code=issue.type AND dict1.cata_code='t_issue.type'
LEFT JOIN t_dict dict3 ON dict3.code=issue.priority AND dict3.cata_code='t_issue.priority'
LEFT JOIN t_dict dict2 ON dict2.code=issue.`status` AND dict2.cata_code='t_issue.status'
LEFT JOIN t_employee employee1 ON employee1.id=issue.test_design_by 
LEFT JOIN t_employee employee3 ON employee3.id=issue.assignee 
LEFT JOIN t_employee employee2 ON employee2.id=issue.test_by 
LEFT JOIN t_employee employee4 ON employee4.id=issue.reporter 
 LEFT JOIN (
				SELECT A.ISSUE_ID 
						,SUM(CASE WHEN last_result ='pass' THEN 1 ELSE 0 END ) AS passno 
						,COUNT(B.id) as testno
					FROM t_testcase A 
					LEFT JOIN t_issue B on A.ISSUE_ID=B.id 
					group by ISSUE_ID			
  		)	T1 ON  T1.issue_id=issue.id 

 LEFT JOIN (
				SELECT A.ISSUE_ID 
						,COUNT(B.id) AS bugno
						,SUM(CASE WHEN B.status IN ('close','cancel') THEN 1 ELSE 0 END) as endbugno 
					FROM t_testcase A 
					LEFT JOIN t_issue B on A.id=B.testcase_id 
					group by ISSUE_ID			
  		)	T2 ON  T2.issue_id=issue.id 

where issue.type='feature' OR issue.type='improvement' 
 ) a 