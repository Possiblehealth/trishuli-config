SELECT
    deathObs.gender,
    SUM(IF(deathObs.question = 'PNC, Date of Neonatal Death' AND deathObs.answer != "False", 1, 0)) AS 'Neonatal Death',
    SUM(IF((deathObs.question = 'Death Note, Maternal Death' OR deathObs.question = 'PNC, Date of maternal death') AND deathObs.answer != "False", 1, 0)) AS 'Maternal Death',
    SUM(IF(deathObs.question = 'Death Note, Death occured post operative' AND deathObs.answer != "False", 1, 0)) AS 'Post Operative',
    SUM(IF(deathObs.question = 'Death Note, Brought dead' AND deathObs.Answer != "False", 1, 0)) AS 'Brought Dead',
    SUM(IF(deathObs.question = 'Death Note, Postmortem done' AND deathObs.Answer != "False", 1, 0)) AS 'Postmortem Done'
    
FROM (SELECT DISTINCT pi.identifier AS ip, cn1.name AS question, cn2.name AS answer, p.gender AS gender
FROM obs o
    INNER JOIN concept_name cn1 ON o.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name IN ('Death Note, Primary Cause of Death','PNC, Date of Neonatal Death','PNC, Date of maternal death','Death Note, Maternal Death', 'Death Note, Death occured post operative', 'Death Note, Brought dead', 'Death Note, Postmortem done')
        AND o.voided = 0
        AND cn1.voided = 0
    INNER JOIN concept_name cn2 on o.value_coded = cn2.concept_id AND cn2.locale = 'en' AND cn2.locale_preferred = true
    INNER JOIN encounter e ON o.encounter_id = e.encounter_id
    INNER JOIN visit v ON v.visit_id = e.visit_id
    INNER JOIN person p ON o.person_id = p.person_id AND p.voided = 0
    INNER JOIN patient_identifier pi ON pi.patient_id = p.person_id AND pi.voided = '0' AND pi.identifier != 'DTH100000'
WHERE DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) deathObs
GROUP BY deathObs.gender