select * from (
SELECT
	e.id AS id,
	e.id AS empId,
	e.id AS traineeId,
	e.name AS name,
	e.code AS code,
	e.ext_code AS extCode,
	e.org_id AS orgId,
	o.name AS orgName,
	e.id_card AS idCard,
	e.status AS status,
	d1.name AS statusName,
	e.type AS type,
	d4.name as typeName,
	e.gender AS gender,
	d2.name AS genderName,
	e.nationality AS nationality,
	n.name AS nationalityName,
	e.birth_place AS birthPlace,
	c.name AS birthPlaceName,
	e.birth_date AS birthDate,
	e.marital as marital,
	d3.name as maritalName,
	e.mobile AS mobile,
	e.office_phone AS officePhone,
	e.home_phone AS homePhone,
	e.email AS email,
	e.position_id AS positionId,
	p.name AS positionName,
	e.entry_date AS entryDate,
	e.home_address AS homeAddress,
	e.home_postcode AS homePostcode,
	e.remark AS remark,
	e.photo_id AS photoId
FROM t_employee e
LEFT JOIN t_org o on e.org_id = o.id
LEFT JOIN t_city c on e.birth_place = c.code
LEFT JOIN t_nationality n on e.nationality = n.code
LEFT JOIN t_dict d1 on e.status = d1.code and d1.cata_code='t_employee.status' 
LEFT JOIN t_dict d2 on e.gender = d2.code and d2.cata_code='t_employee.gender' 
LEFT JOIN t_dict d3 on e.marital = d3.code and d3.cata_code='t_employee.marital'
LEFT JOIN t_dict d4 on e.type = d4.code and d4.cata_code='t_employee.type'
LEFT JOIN t_position p on p.id = e.position_id 

 ) a 