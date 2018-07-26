SELECT 'Plaster', SUM(if(p.gender = 'F',1,0)) AS Female, SUM(IF(p.gender = 'M',1,0)) AS 'Male'
FROM obs o
    INNER JOIN concept_name cn1 ON o.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Procedure Notes, Ortho Procedure, Procedure')
        AND o.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
		AND cn2.name IN ('Cast application' , 'High Groin Cast', 'Slab application', 'Thumb Spica Cast', 'Figure 8 Bandage')

        AND cn2.voided = 0
    INNER JOIN encounter e ON o.encounter_id = e.encounter_id
    INNER JOIN person p ON o.person_id = p.person_id
WHERE DATE(e.encounter_datetime) BETWEEN '#startDate#' AND '#endDate#' AND o.value_coded IS NOT NULL