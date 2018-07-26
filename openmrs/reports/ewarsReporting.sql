SELECT 
  DATE_FORMAT(o.obs_datetime, "%Y-%m-%d ") as 'Date',
  pi.identifier AS 'Registration No',
  visit_attribute.value_reference AS 'Location',
  CONCAT_WS(' ', pn.given_name, pn.middle_name, pn.family_name) as 'Patient Name',
  TIMESTAMPDIFF(YEAR,p.birthdate,CURDATE()) AS Age,
  p.gender AS Sex,
  pa.county_district as 'District',
  pa.city_village as 'VDC',
  pa.address1 as 'Ward',
  CASE
    WHEN icd.code IN('A09') THEN 'AGE'
    WHEN icd.code IN('A00','A00.9') THEN 'Cholera'
    WHEN icd.code IN('J15','J22') THEN 'SARI'
    WHEN icd.code IN('B50.9') THEN 'Malaria Falciparum'
    WHEN icd.code IN('B51.9') THEN 'Malaria Vivax'
    WHEN icd.code IN('B55.9') THEN 'Dengue'
    WHEN icd.code IN('B55.9') THEN 'Kala-Azar'
    ELSE cn.name
  END AS Disease
FROM obs o 
  INNER JOIN person p on o.person_id = p.person_id AND p.person_id NOT IN(290)
  INNER JOIN patient_identifier pi ON p.person_id = pi.patient_id AND pi.identifier != 'DTH203206' AND pi.identifier != 'DTH100000' AND pi.voided = '0'
  INNER JOIN person_name pn ON pn.person_id = p.person_id AND pn.voided = '0'
  INNER JOIN person_address pa ON pa.person_id = pn.person_id AND pa.voided = '0'
  INNER JOIN concept c ON c.concept_id = o.value_coded
  INNER JOIN concept_name cn ON c.concept_id = cn.concept_id
  INNER JOIN concept_reference_term_map_view icd ON o.value_coded = icd.concept_id AND icd.code IN('A09','B50.9','B51.9','A90','B55.9','A01.0','A00','A00.9','J15','J22')
  INNER JOIN encounter e ON e.encounter_id = o.encounter_id
  INNER JOIN visit v ON v.visit_id = e.visit_id
  INNER JOIN visit_attribute on v.visit_id = visit_attribute.visit_id
  INNER JOIN visit_attribute_type on visit_attribute_type.visit_attribute_type_id = visit_attribute.attribute_type_id and visit_attribute_type.name = "Visit Status"
WHERE o.concept_id IN(14,15,16) AND e.encounter_datetime BETWEEN DATE('#startDate#') AND DATE('#endDate#');