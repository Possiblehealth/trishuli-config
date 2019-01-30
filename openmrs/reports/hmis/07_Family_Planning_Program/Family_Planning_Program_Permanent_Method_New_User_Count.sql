SELECT 
	gender.gender              AS gender,
    sum(case when first_concept.gender = 'F' and gender.gender = 'F' then 1 
     when first_concept.gender = 'M' and gender.gender = 'M' then 1  else 0 end ) as permanent_fp_method_count
    from 

(SELECT 
        ca.answer_concept AS answer,
            IFNULL(answer_concept_short_name.name, answer_concept_fully_specified_name.name) AS answer_name
    FROM
        concept c
    INNER JOIN concept_datatype cd ON c.datatype_id = cd.concept_datatype_id
    INNER JOIN concept_name question_concept_name ON c.concept_id = question_concept_name.concept_id
        AND question_concept_name.concept_name_type = 'FULLY_SPECIFIED'
        AND question_concept_name.voided IS FALSE
    INNER JOIN concept_answer ca ON c.concept_id = ca.concept_id
    INNER JOIN concept_name answer_concept_fully_specified_name ON ca.answer_concept = answer_concept_fully_specified_name.concept_id
        AND answer_concept_fully_specified_name.concept_name_type = 'FULLY_SPECIFIED'
        AND answer_concept_fully_specified_name.name in ('Vasectomy','Mini-lap')
        AND answer_concept_fully_specified_name.voided
        IS FALSE
    LEFT JOIN concept_name answer_concept_short_name ON ca.answer_concept = answer_concept_short_name.concept_id
        AND answer_concept_short_name.concept_name_type = 'SHORT'
        AND answer_concept_short_name.voided
        IS FALSE
    WHERE
        question_concept_name.name IN ('FRH-Long acting and permanent method')
            AND cd.name = 'Coded' 
    ORDER BY answer_name DESC) first_answers
    
  INNER JOIN (SELECT 'M' AS gender
              UNION SELECT 'F' AS gender) gender
              
 LEFT OUTER JOIN
(SELECT 
  DISTINCT
        o1.person_id,
        p1.gender,
            cn2.concept_id AS answer,
            cn1.concept_id AS question
FROM
    obs o1
        INNER JOIN
    concept_name cn1 ON o1.concept_id = cn1.concept_id
        AND cn1.concept_name_type = 'FULLY_SPECIFIED'
        AND cn1.name in ('FRH-Long acting and permanent method')
        AND o1.voided = 0
        AND cn1.voided = 0
        INNER JOIN
    concept_name cn2 ON o1.value_coded = cn2.concept_id
        AND cn2.concept_name_type = 'FULLY_SPECIFIED' 
        And cn2.name in ('Vasectomy','Mini-lap')
        AND cn2.voided = 0
        INNER JOIN
    encounter e ON o1.encounter_id = e.encounter_id
        INNER JOIN
    visit v1 ON v1.visit_id = e.visit_id
        INNER JOIN
    person p1 ON o1.person_id = p1.person_id

WHERE
    -- DATE(e.encounter_datetime) BETWEEN DATE('2017-08-01') AND DATE('2017-10-30'))
	DATE(e.encounter_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#'))

    first_concept ON first_concept.answer = first_answers.answer
    GROUP BY  gender;
    