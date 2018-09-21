select * from (
	select 
	e.ID as id,
	e.ID as empId,
	e.NAME as empName,
	e.EMAIL as email,
	e.MOBILE as mobile,
	e.CODE as empCode,
	e.EXT_CODE as externalCode,
	e.GENDER as gender,
	e.STATUS as status,
	e.BIRTH_PLACE as birthPlace,
	d1.name as birthPlaceName,
	e.BIRTH_DATE as birthDate,
	e.MARITAL as marital,
	e.OFFICE_PHONE as officePhone,
	e.HOME_PHONE as homePhone,
	e.position_id as positionId,
	e.ID_CARD as idCard,
	e.HOME_ADDRESS as homeAddress,
	e.HOME_POSTCODE as homePostcode,
	e.update_time as updateTime,
	e.update_by as updateBy,
	e.REMARK as remark from t_employee e 
	LEFT JOIN t_dict d1 ON e.birth_place=d1.code and d1.cata_code='PROVINCE' 
 ) a 