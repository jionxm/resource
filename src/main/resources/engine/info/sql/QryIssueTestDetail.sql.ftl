select * from (
	SELECT 
	issue.id as id,
	issue.title as `name`,
	employee1.`name` AS testDesignByName,
	employee3.`name` AS testByName,
	employee1.`id` AS testDesignBy,
	employee3.`id` AS testBy
	 from t_issue issue
	LEFT JOIN t_employee employee1 ON employee1.id=issue.test_design_by 
	LEFT JOIN t_employee employee3 ON employee3.id=issue.test_by
 ) a 