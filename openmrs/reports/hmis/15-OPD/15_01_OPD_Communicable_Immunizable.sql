SELECT icd.code AS "ICD Code", cn.name "Name of Disease",
  SUM(IF(p.gender = 'F', 1, 0)) as "Female",
  SUM(IF(p.gender = "M",1,0)) as "Male"
FROM obs o 
  INNER JOIN person p on o.person_id = p.person_id AND p.person_id NOT IN(290)
  INNER JOIN concept c ON c.concept_id = o.value_coded
  INNER JOIN concept_name cn ON c.concept_id = cn.concept_id
  INNER JOIN concept_reference_term_map_view icd ON o.value_coded = icd.concept_id AND icd.code IN ('B05.9', 'A36.9', 'A37.9','A33','A35','A16.9','G83','B06.9','B26.9','B01.9','B16.9')
  INNER JOIN encounter e ON e.encounter_id = o.encounter_id
  INNER JOIN visit v ON v.visit_id = e.visit_id
    INNER JOIN visit_attribute on v.visit_id = visit_attribute.visit_id AND visit_attribute.value_reference IN ('OPD')
    INNER JOIN visit_attribute_type on visit_attribute_type.visit_attribute_type_id = visit_attribute.attribute_type_id and visit_attribute_type.name = "Visit Status"
WHERE o.concept_id IN(14,15) AND o.value_coded IS NOT NULL AND e.encounter_datetime BETWEEN DATE('#startDate#') AND DATE('#endDate#')
GROUP BY cn.name
ORDER BY FIELD(icd.code,'B05.9', 'A36.9', 'A37.9','A33','A35','A16.9','G83','B06.9','B26.9','B01.9','B16.9');