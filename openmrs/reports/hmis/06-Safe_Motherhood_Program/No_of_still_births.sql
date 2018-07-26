SELECT FINAL.Type, FINAL.Number
FROM (
  SELECT cn2.name as Type, COUNT(*) as Number 
  FROM obs o
    INNER JOIN concept_name cn1 ON o.concept_id = cn1.concept_id AND cn1.concept_name_type = 'FULLY_SPECIFIED' AND cn1.name = 'Delivery Note-Stillbirth type' AND o.voided = 0 AND cn1.voided = 0
    INNER JOIN concept_name cn2 on o.value_coded = cn2.concept_id AND cn2.name IN('Fresh stillbirth','Macerated stillbirth')
    INNER JOIN encounter e ON o.encounter_id = e.encounter_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    INNER JOIN person p ON o.person_id = p.person_id AND p.voided = 0
    INNER JOIN patient_identifier pi ON pi.patient_id = p.person_id AND pi.voided = '0' AND pi.identifier != 'DTH100000'
  WHERE DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
  GROUP BY cn2.name
  UNION ALL SELECT 'Fresh stillbirth',0
  UNION ALL SELECT 'Macerated stillbirth',0
) AS FINAL
GROUP BY FINAL.Type