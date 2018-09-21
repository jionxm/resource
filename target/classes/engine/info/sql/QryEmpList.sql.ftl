select * from (
	select 
	e.ID as id,
	e.ID as empId,
	e.name as empName,
	e.EMAIL as email,
	e.MOBILE as mobile,
	e.CODE as empCode,
	e.GENDER as gender,
	d1.name as genderName,
	e.STATUS as status,
	e.BIRTH_PLACE as birthPlace,
	d2.name as birthPlaceName,
	e.BIRTH_DATE as birthDate,
	e.MARITAL as marital,
	e.OFFICE_PHONE as officePhone,
	e.HOME_PHONE as homePhone,
	e.position_id as positionId,
	e.ID_CARD as idCard,
	e.HOME_ADDRESS as homeAddress,
	e.HOME_POSTCODE as homePostcode,
	e.update_time as updateTime,
	e.REMARK as remark,e1.name as updateByName from t_employee e  
	LEFT JOIN t_dict d1 on e.gender=d1.code and d1.cata_code='GENDER' 
	LEFT JOIN t_dict d2 ON e.birth_place=d2.code and d2.cata_code='PROVINCE' 
  LEFT OUTER JOIN t_employee e1 ON e.update_by=e1.id  
 ) a 