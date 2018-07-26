SELECT 
    SUM(IF(procedureObs.gender = 'F', 1, 0)) as 'Female',
    SUM(IF(procedureObs.gender = 'M', 1, 0)) as 'Male'
FROM (SELECT distinct pi.identifier AS ip, p.gender as gender, visit_attribute.value_reference as visit_type
    FROM obs o
    INNER JOIN concept_name cn1 ON o.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name = 'Operative Notes, Procedure'
        AND o.voided = 0
        AND cn1.voided = 0
    INNER JOIN encounter e ON o.encounter_id = e.encounter_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    INNER JOIN visit_attribute on v.visit_id = visit_attribute.visit_id
    INNER JOIN visit_attribute_type on visit_attribute_type.visit_attribute_type_id = visit_attribute.attribute_type_id and visit_attribute_type.name = "Visit Status"
    INNER JOIN person p ON o.person_id = p.person_id AND p.voided = 0
    INNER JOIN patient_identifier pi ON pi.patient_id = p.person_id AND pi.voided = '0'
    WHERE(o.value_coded IS NOT NULL) AND DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#') group by pi.identifier) procedureObs
GROUP BY procedureObs.visit_type;
