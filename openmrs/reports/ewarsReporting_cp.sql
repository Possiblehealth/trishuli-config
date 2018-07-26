SELECT distinct
  date(o.obs_datetime) as 'date_diagnosed',
  pi.identifier AS 'Registration No',
  vt.name as Visit_Type,
  CONCAT_WS(' ', pn.given_name, pn.middle_name, pn.family_name) as 'Patient Name',
  TIMESTAMPDIFF(YEAR,p.birthdate,CURDATE()) AS Age,
  p.gender AS Sex,
  pa.county_district as 'District',
  pa.city_village as 'VDC',
  pa.address1 as 'Ward',
  (select name from concept_name where concept_id = o.value_coded AND o.voided IS FALSE and concept_name_type = 'FULLY_SPECIFIED' and voided = '0') as Disease
FROM person p
  INNER JOIN patient_identifier pi ON p.person_id = pi.patient_id AND pi.identifier != 'DTH203206' AND pi.voided = '0'
  INNER JOIN person_name pn ON pn.person_id = p.person_id AND pn.voided = '0'
  INNER JOIN person_address pa ON pa.person_id = pn.person_id AND pa.voided = '0'
  INNER JOIN visit v ON v.patient_id = p.person_id
  INNER JOIN visit_type vt ON v.visit_type_id = vt.visit_type_id
  INNER JOIN obs o ON o.person_id = p.person_id and o.voided = '0'
    and o.concept_id = '15' AND o.value_coded in ('395','1886', '1887', '1872', '4863', '5499', '5500', '4640', '6929', '5487', '5496', '4163', '4653','5486')
WHERE p.voided = '0' AND DATE(o.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
-- and pa.city_village in ('Bhimeshwar Municipality','Bocha','Babare','Susmachhemawati')
group by 'Registration No', 'Patient Name', Age, Sex, VDC, Ward, District, Disease
ORDER BY date_diagnosed ASC;