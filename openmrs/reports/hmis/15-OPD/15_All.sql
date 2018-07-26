SELECT diagnosis.ICD AS "ICD Code", diagnosis.Disease AS "Name of Disease",
  SUM(IF(diagnosis.Gender = 'F', 1, 0)) as "Female",
  SUM(IF(diagnosis.Gender = "M",1,0)) as "Male"
FROM (SELECT IF(icd.code != ' ', icd.code, 'NA') AS 'ICD', cn.name AS 'Disease', p.gender as 'Gender' FROM obs o 
  INNER JOIN person p on o.person_id = p.person_id AND p.person_id NOT IN(290)
  INNER JOIN concept c ON c.concept_id = o.value_coded
  INNER JOIN concept_name cn ON c.concept_id = cn.concept_id
  LEFT JOIN concept_reference_term_map_view icd ON o.value_coded = icd.concept_id
  INNER JOIN encounter e ON e.encounter_id = o.encounter_id
  INNER JOIN visit v ON v.visit_id = e.visit_id
    INNER JOIN visit_attribute on v.visit_id = visit_attribute.visit_id AND visit_attribute.value_reference IN ('OPD')
    INNER JOIN visit_attribute_type on visit_attribute_type.visit_attribute_type_id = visit_attribute.attribute_type_id and visit_attribute_type.name = "Visit Status"
WHERE o.concept_id IN(14,15) AND e.encounter_datetime BETWEEN DATE('#startDate#') AND DATE('#endDate#')) diagnosis
GROUP BY diagnosis.icd, diagnosis.Disease
ORDER BY "ICD Code";