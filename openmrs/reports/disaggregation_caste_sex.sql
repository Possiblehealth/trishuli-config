-- Disaggregation by Sex & Caste/Ethnicity

-- Parameters
SET @start_date = '2015-02-25';
SET @end_date = '2015-03-18';

-- Query

-- CBIMCI
SELECT  cbimci.caste_ethnicity AS 'Caste/Ethnicity',
		cbimci_female AS 'Enroll in CBIMCI programme-Female',
		cbimci_male AS 'Enroll in CBIMCI programme-Male',
        underweight_female AS 'Underweight Children(<2years)-Female',
        underweight_male AS 'Underweight Children(<2years)-Male',
        delivery_count AS 'Institutional Delivery',
        abortion_count AS 'Abortion Cases',
        op_cases_female AS 'Out patient cases-Female',
        op_cases_male AS 'Out patient cases-Male',
        ip_cases_female AS 'In patient cases-Female',
        ip_cases_male AS 'In patient cases-Male'
FROM
(SELECT
	caste_list.answer_concept_name AS caste_ethnicity,
	SUM(IF(person.gender = 'F', 1, 0)) AS cbimci_female,
    SUM(IF(person.gender = 'M', 1, 0)) AS cbimci_male
 
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND DATE(visit.date_started) BETWEEN @start_date AND @end_date
INNER JOIN person_attribute ON person_attribute.person_id = person.person_id
INNER JOIN person_attribute_type ON person_attribute.person_attribute_type_id = person_attribute_type.person_attribute_type_id
	AND person_attribute_type.name = 'Caste'
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN obs_view ON encounter.encounter_id = obs_view.encounter_id
	AND obs_view.concept_full_name IN ('Childhood Illness( Children aged below 2 months)', 'Childhood Illness( Children aged 2 months to 5 years)')
    AND DATE(obs_datetime) BETWEEN @start_date AND @end_date
RIGHT OUTER JOIN (SELECT answer_concept_name, answer_concept_id FROM concept_answer_view WHERE question_concept_name = 'Caste' ) AS caste_list ON caste_list.answer_concept_id = person_attribute.value
GROUP BY caste_list.answer_concept_name) AS cbimci
INNER JOIN

-- Underweight Children (<2 year)
(SELECT
	caste_list.answer_concept_name AS caste_ethnicity,
	SUM(IF(person.gender = 'F', 1, 0)) AS underweight_female,
    SUM(IF(person.gender = 'M', 1, 0)) AS underweight_male
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND DATE(visit.date_started) BETWEEN @start_date AND @end_date
    AND TIMESTAMPDIFF(MONTH, DATE(person.birthdate), visit.date_started) <= 24
INNER JOIN person_attribute ON person_attribute.person_id = person.person_id
INNER JOIN person_attribute_type ON person_attribute.person_attribute_type_id = person_attribute_type.person_attribute_type_id
	AND person_attribute_type.name = 'Caste'    
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view ON encounter.encounter_id = coded_obs_view.encounter_id
	AND coded_obs_view.concept_full_name IN ('Weight condition')
    AND coded_obs_view.value_concept_full_name IN ('Low weight', 'Very low weight')
    AND DATE(coded_obs_view.obs_datetime) BETWEEN  @start_date AND @end_date  
RIGHT OUTER JOIN (SELECT answer_concept_name, answer_concept_id FROM concept_answer_view WHERE question_concept_name = 'Caste' ) AS caste_list ON caste_list.answer_concept_id = person_attribute.value
GROUP BY caste_list.answer_concept_name) AS underweight ON underweight.caste_ethnicity = cbimci.caste_ethnicity
INNER JOIN
-- Institiutional Delivery
(SELECT
	caste_list.answer_concept_name AS caste_ethnicity,
	SUM(IF(person.person_id IS NOT NULL, 1, 0)) AS delivery_count
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND DATE(visit.date_started) BETWEEN @start_date AND @end_date
INNER JOIN person_attribute ON person_attribute.person_id = person.person_id
INNER JOIN person_attribute_type ON person_attribute.person_attribute_type_id = person_attribute_type.person_attribute_type_id
	AND person_attribute_type.name = 'Caste'
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN obs_view ON encounter.encounter_id = obs_view.encounter_id
	AND obs_view.concept_full_name = 'Delivery Note, Delivery date and time'
    AND DATE(obs_view.value_datetime) BETWEEN @start_date AND @end_date
RIGHT OUTER JOIN (SELECT answer_concept_name, answer_concept_id FROM concept_answer_view WHERE question_concept_name = 'Caste' ) AS caste_list ON caste_list.answer_concept_id = person_attribute.value
GROUP BY caste_list.answer_concept_name) AS delivery ON delivery.caste_ethnicity = underweight.caste_ethnicity
INNER JOIN
-- Abortion cases
(SELECT
	caste_list.answer_concept_name AS caste_ethnicity,
	SUM(IF(person.person_id IS NOT NULL, 1, 0)) AS abortion_count
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND DATE(visit.date_started) BETWEEN @start_date AND @end_date
INNER JOIN person_attribute ON person_attribute.person_id = person.person_id
INNER JOIN person_attribute_type ON person_attribute.person_attribute_type_id = person_attribute_type.person_attribute_type_id
	AND person_attribute_type.name = 'Caste'
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view ON encounter.encounter_id = coded_obs_view.encounter_id
	AND coded_obs_view.concept_full_name = 'Abortion procedure'
    AND coded_obs_view.value_concept_full_name IS NOT NULL
    AND DATE(coded_obs_view.obs_datetime) BETWEEN @start_date AND @end_date
RIGHT OUTER JOIN (SELECT answer_concept_name, answer_concept_id FROM concept_answer_view WHERE question_concept_name = 'Caste' ) AS caste_list ON caste_list.answer_concept_id = person_attribute.value
GROUP BY caste_list.answer_concept_name) AS abortion ON abortion.caste_ethnicity = delivery.caste_ethnicity
INNER JOIN
-- Out patient cases
(SELECT
	 caste_list.answer_concept_name AS caste_ethnicity,
	 SUM(IF(person.gender = 'F', 1, 0)) AS op_cases_female,
     SUM(IF(person.gender = 'M', 1, 0)) AS op_cases_male
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND DATE(visit.date_started) BETWEEN @start_date AND @end_date
INNER JOIN person_attribute ON person_attribute.person_id = person.person_id
INNER JOIN person_attribute_type ON person_attribute.person_attribute_type_id = person_attribute_type.person_attribute_type_id
	AND person_attribute_type.name = 'Caste'
AND NOT EXISTS(SELECT * 
					FROM encounter_view 
					WHERE encounter_view.visit_id = visit.visit_id AND encounter_view.encounter_type_name = 'ADMISSION' )
RIGHT OUTER JOIN (SELECT answer_concept_name, answer_concept_id FROM concept_answer_view WHERE question_concept_name = 'Caste' ) AS caste_list ON caste_list.answer_concept_id = person_attribute.value
GROUP BY caste_list.answer_concept_name) AS op_cases ON abortion.caste_ethnicity = op_cases.caste_ethnicity
INNER JOIN

-- In patient cases
(SELECT
	caste_list.answer_concept_name AS caste_ethnicity,
	SUM(IF(person.gender = 'F', 1, 0)) AS ip_cases_female,
    SUM(IF(person.gender = 'M', 1, 0)) AS ip_cases_male

FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND DATE(visit.date_started) BETWEEN @start_date AND @end_date
INNER JOIN person_attribute ON person_attribute.person_id = person.person_id
INNER JOIN person_attribute_type ON person_attribute.person_attribute_type_id = person_attribute_type.person_attribute_type_id
	AND person_attribute_type.name = 'Caste'
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN encounter_type ON encounter.encounter_type = encounter_type.encounter_type_id
	AND encounter_type.name = 'ADMISSION'
RIGHT OUTER JOIN (SELECT answer_concept_name, answer_concept_id FROM concept_answer_view WHERE question_concept_name = 'Caste' ) AS caste_list ON caste_list.answer_concept_id = person_attribute.value
GROUP BY caste_list.answer_concept_name) AS ip_cases ON op_cases.caste_ethnicity = ip_cases.caste_ethnicity;



SELECT
		hiv_cases.caste_ethnicity AS 'Caste/Ethnicity',
        hiv_female AS 'New HIV+ Cases-Female',
        hiv_male AS 'New HIV+ Cases-Male',
        leprosy_female AS 'New Leprosy Cases-Female',
        leprosy_male AS 'New Leprosy Cases-Male',
        tb_female AS 'New TB Cases-Female',
        tb_male AS 'New TB Cases-Male',
        gender_violence_female AS 'Gender based violence - Female',
        gender_violence_male AS 'Gender based violence - Male'
FROM
-- New HIV+ cases
(SELECT
	 caste_list.answer_concept_name AS caste_ethnicity,
	 SUM(IF(person.gender = 'F', 1, 0)) AS hiv_female,
     SUM(IF(person.gender = 'M', 1, 0)) AS hiv_male
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND DATE(visit.date_started) BETWEEN @start_date AND @end_date
INNER JOIN person_attribute ON person_attribute.person_id = person.person_id
INNER JOIN person_attribute_type ON person_attribute.person_attribute_type_id = person_attribute_type.person_attribute_type_id
	AND person_attribute_type.name = 'Caste'
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS diagnosis_obs ON diagnosis_obs.person_id = person.person_id
	AND diagnosis_obs.concept_full_name = 'Coded Diagnosis'
	AND diagnosis_obs.value_concept_full_name IN ('HIV Infection')
    AND DATE(diagnosis_obs.obs_datetime) BETWEEN @start_date AND @end_date
INNER JOIN coded_obs_view AS certainty_obs ON diagnosis_obs.obs_group_id = certainty_obs.obs_group_id
	AND certainty_obs.concept_full_name = 'Diagnosis Certainty'
    AND certainty_obs.value_concept_full_name = 'Confirmed'
RIGHT OUTER JOIN (SELECT answer_concept_name, answer_concept_id FROM concept_answer_view WHERE question_concept_name = 'Caste' ) AS caste_list ON caste_list.answer_concept_id = person_attribute.value
GROUP BY caste_list.answer_concept_name) AS hiv_cases
INNER JOIN

-- New leprosy cases
(SELECT
	caste_list.answer_concept_name AS caste_ethnicity,
	SUM(IF(person.gender = 'F', 1, 0)) AS leprosy_female,
    SUM(IF(person.gender = 'M', 1, 0)) AS leprosy_male
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND DATE(visit.date_started) BETWEEN @start_date AND @end_date
INNER JOIN person_attribute ON person_attribute.person_id = person.person_id
INNER JOIN person_attribute_type ON person_attribute.person_attribute_type_id = person_attribute_type.person_attribute_type_id
	AND person_attribute_type.name = 'Caste'    
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS diagnosis_obs ON diagnosis_obs.person_id = person.person_id
	AND diagnosis_obs.concept_full_name = 'Coded Diagnosis'
	AND diagnosis_obs.value_concept_full_name IN ('Leprosy')
    AND DATE(diagnosis_obs.obs_datetime) BETWEEN @start_date AND @end_date
INNER JOIN coded_obs_view AS certainty_obs ON diagnosis_obs.obs_group_id = certainty_obs.obs_group_id
	AND certainty_obs.concept_full_name = 'Diagnosis Certainty'
    AND certainty_obs.value_concept_full_name = 'Confirmed'
RIGHT OUTER JOIN (SELECT answer_concept_name, answer_concept_id FROM concept_answer_view WHERE question_concept_name = 'Caste' ) AS caste_list ON caste_list.answer_concept_id = person_attribute.value
GROUP BY caste_list.answer_concept_name) AS leprosy_cases ON leprosy_cases.caste_ethnicity = hiv_cases.caste_ethnicity
INNER JOIN    
-- New TB cases
(SELECT
	caste_list.answer_concept_name AS caste_ethnicity,
	SUM(IF(person.gender = 'F', 1, 0)) AS tb_female,
    SUM(IF(person.gender = 'M', 1, 0)) AS tb_male
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND DATE(visit.date_started) BETWEEN @start_date AND @end_date
INNER JOIN person_attribute ON person_attribute.person_id = person.person_id
INNER JOIN person_attribute_type ON person_attribute.person_attribute_type_id = person_attribute_type.person_attribute_type_id
	AND person_attribute_type.name = 'Caste'    
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view AS diagnosis_obs ON diagnosis_obs.person_id = person.person_id
	AND diagnosis_obs.concept_full_name = 'Coded Diagnosis'
	AND diagnosis_obs.value_concept_full_name IN ('Tuberculosis', 'Multi Drug Resistant Tuberculosis', 'Extremely Drug Resistant Tuberculosis')
    AND DATE(diagnosis_obs.obs_datetime) BETWEEN @start_date AND @end_date
INNER JOIN coded_obs_view AS certainty_obs ON diagnosis_obs.obs_group_id = certainty_obs.obs_group_id
	AND certainty_obs.concept_full_name = 'Diagnosis Certainty'
    AND certainty_obs.value_concept_full_name = 'Confirmed'
RIGHT OUTER JOIN (SELECT answer_concept_name, answer_concept_id FROM concept_answer_view WHERE question_concept_name = 'Caste' ) AS caste_list ON caste_list.answer_concept_id = person_attribute.value
GROUP BY caste_list.answer_concept_name) AS tb_cases ON tb_cases.caste_ethnicity = hiv_cases.caste_ethnicity
INNER JOIN

-- Gender based violence
(SELECT
	caste_list.answer_concept_name AS caste_ethnicity,
	SUM(IF(person.gender = 'F', 1, 0)) AS gender_violence_female,
    SUM(IF(person.gender = 'M', 1, 0)) AS gender_violence_male
FROM visit
INNER JOIN person ON visit.patient_id = person.person_id
	AND DATE(visit.date_started) BETWEEN @start_date AND @end_date
INNER JOIN person_attribute ON person_attribute.person_id = person.person_id
INNER JOIN person_attribute_type ON person_attribute.person_attribute_type_id = person_attribute_type.person_attribute_type_id
	AND person_attribute_type.name = 'Caste'
INNER JOIN encounter ON visit.visit_id = encounter.visit_id
INNER JOIN coded_obs_view ON encounter.encounter_id = coded_obs_view.encounter_id
	AND coded_obs_view.concept_full_name IN ('Out Patient Details, Free Health Service Code', 'ER General Notes, Free Health Service Code')
    AND coded_obs_view.value_concept_full_name = 'Gender based violence'  
RIGHT OUTER JOIN (SELECT answer_concept_name, answer_concept_id FROM concept_answer_view WHERE question_concept_name = 'Caste' ) AS caste_list ON caste_list.answer_concept_id = person_attribute.value
GROUP BY caste_list.answer_concept_name) AS gender_violence ON gender_violence.caste_ethnicity = tb_cases.caste_ethnicity;

