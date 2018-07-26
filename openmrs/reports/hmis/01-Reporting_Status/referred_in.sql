SELECT client_visits.patient_gender AS 'Gender',
        IF(client_visits.patient_id IS NULL, 0, COUNT(client_visits.patient_id)) AS 'Referred In'
FROM (
    SELECT DISTINCT patient.patient_id AS patient_id,
        patient.date_created AS first_visit_date,
        person.gender AS patient_gender,
        v.visit_type_id AS visit_type_id
    FROM obs o
    INNER JOIN concept_name cn1 ON o.concept_id = cn1.concept_id AND cn1.concept_name_type = 'FULLY_SPECIFIED' AND o.voided = 0 AND cn1.voided = 0 AND cn1.name = 'Referred In'
    INNER JOIN encounter e ON o.encounter_id = e.encounter_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    INNER JOIN patient ON v.patient_id = patient.patient_id AND DATE(v.date_stopped) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE) AND patient.voided = 0 AND v.voided = 0
    INNER JOIN person ON person.person_id = patient.patient_id AND person.voided = 0
    ) AS client_visits
GROUP BY client_visits.patient_gender;