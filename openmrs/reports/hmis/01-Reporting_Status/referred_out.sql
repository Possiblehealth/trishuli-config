SELECT client_visits.patient_gender AS 'Gender',
        IF(client_visits.patient_id IS NULL, 0, SUM(IF(client_visits.visit_type_id = 9, 1, 0))) AS 'Referred Out Clients, General',
       IF(client_visits.patient_id IS NULL, 0, SUM(IF(client_visits.visit_type_id = 4, 1, 0))) AS 'Referred Out Clients, OPD',
       IF(client_visits.patient_id IS NULL, 0, SUM(IF(client_visits.visit_type_id = 3, 1, 0))) AS 'Referred Out Clients, IPD',
       IF(client_visits.patient_id IS NULL, 0, SUM(IF(client_visits.visit_type_id = 6, 1, 0))) AS 'Referred Out Clients, ER'
FROM (
    SELECT DISTINCT patient.patient_id AS patient_id,
        patient.date_created AS first_visit_date,
        person.gender AS patient_gender,
        v.visit_type_id AS visit_type_id
    FROM obs o
    INNER JOIN concept_name cn1 ON o.concept_id = cn1.concept_id AND cn1.concept_name_type = 'FULLY_SPECIFIED' AND o.voided = 0 AND cn1.voided = 0
    INNER JOIN concept_name cn2 ON o.value_coded = cn2.concept_id AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.name IN ('Referred for Investigations' , 'Referred for Further Care', 'Referred for Surgery') AND cn2.voided = 0
    INNER JOIN encounter e ON o.encounter_id = e.encounter_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    INNER JOIN patient ON v.patient_id = patient.patient_id AND DATE(v.date_stopped) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE) AND patient.voided = 0 AND v.voided = 0
    INNER JOIN person ON person.person_id = patient.patient_id AND person.voided = 0
    ) AS client_visits
GROUP BY client_visits.patient_gender;