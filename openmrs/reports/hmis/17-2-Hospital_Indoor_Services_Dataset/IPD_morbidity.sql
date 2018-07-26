SELECT discharged.icd, discharged.age_group AS 'Age Group',
    SUM(if(discharged.age_group = '<= 28 Days' AND discharged.patient_gender = 'F', 1, 0)) AS '<=28 Days - Female',
    SUM(if(discharged.age_group = '<= 28 Days' AND discharged.patient_gender = 'M', 1, 0)) AS 'Recovered-Male',
    SUM(if(discharged.age_group = '<= 28 Days' AND discharged.patient_gender = 'F', 1, 0)) AS 'Not Improved-Female',
    SUM(if(discharged.age_group = '<= 28 Days' AND discharged.patient_gender = 'M', 1, 0)) AS 'Not Improved-Male',
    SUM(if(discharged.age_group = '<= 28 Days' AND discharged.patient_gender = 'F', 1, 0)) AS 'Referred Out-Female',
    SUM(if(discharged.age_group = '<= 28 Days' AND discharged.patient_gender = 'M', 1, 0)) AS 'Referred Out-Male',
    SUM(if(discharged.age_group = '<= 28 Days' AND discharged.patient_gender = 'F', 1, 0)) AS 'DOR/LAMA/DAMA-Female',
    SUM(if(discharged.age_group = '<= 28 Days' AND discharged.patient_gender = 'M', 1, 0)) AS 'DOR/LAMA/DAMA-Male',
    SUM(if(discharged.age_group = '<= 28 Days' AND discharged.patient_gender = 'F', 1, 0)) AS 'Absconded-Female',
    SUM(if(discharged.age_group = '<= 28 Days' AND discharged.patient_gender = 'M', 1, 0)) AS 'Absconded-Male',
    SUM(IF(discharged.age_group = '<= 28 Days' AND discharged.patient_gender = 'F', 1, 0)) AS 'Death < 48 Hours-Female',
    SUM(IF(discharged.age_group = '<= 28 Days' AND discharged.patient_gender = 'M', 1, 0)) AS 'Death < 48 Hours-Male',
    SUM(IF(discharged.age_group = '<= 28 Days' AND discharged.patient_gender = 'F', 1, 0)) AS 'Death >= 48 Hours-Female',
    SUM(IF(discharged.age_group = '<= 28 Days' AND discharged.patient_gender = 'M', 1, 0)) AS 'Death >= 48 Hours-Male'
    
FROM
  (SELECT DISTINCT patient.patient_id AS patient_id,
                   observed_age_group.name AS age_group,
                   observed_age_group.id as age_group_id,
                   person.gender AS patient_gender,
                   if(icd.code IS NULL OR icd.code = '',o1.value_text,icd.code)as icd,
                   o1.value_coded AS outcome_id,
                   cn2.name,
                   va.value_reference,
                   observed_age_group.sort_order AS sort_order
   FROM
        obs o1
    INNER JOIN concept_name cn1 ON o1.concept_id = cn1.concept_id AND cn1.concept_name_type = 'FULLY_SPECIFIED' AND o1.voided = 0 AND o1.concept_id in (14,15) AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o1.value_coded = cn2.concept_id AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.voided = 0
    LEFT JOIN concept_reference_term_map_view icd ON o1.value_coded = icd.concept_id
    INNER JOIN encounter e ON o1.encounter_id = e.encounter_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
     INNER JOIN visit_attribute va on v.visit_id = va.visit_id AND va.value_reference = 'Discharged'
     INNER JOIN patient ON v.patient_id = patient.patient_id AND DATE(v.date_stopped) BETWEEN CAST('2018-02-01' AS DATE) AND CAST('2018-06-25' AS DATE) AND patient.voided = 0 AND v.voided = 0
     INNER JOIN person ON person.person_id = patient.patient_id AND person.voided = 0
     RIGHT OUTER JOIN reporting_age_group AS observed_age_group ON
        DATE(v.date_stopped) BETWEEN (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.min_years YEAR), INTERVAL observed_age_group.min_days DAY))
        AND (DATE_ADD(DATE_ADD(person.birthdate, INTERVAL observed_age_group.max_years YEAR), INTERVAL observed_age_group.max_days DAY))
   WHERE observed_age_group.report_group_name = 'Inpatient Outcome') AS discharged
GROUP BY discharged.age_group
ORDER BY discharged.sort_order;