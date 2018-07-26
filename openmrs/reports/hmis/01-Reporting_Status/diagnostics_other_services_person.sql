SELECT cn.name, COUNT(o.patient_id) AS "Total Number of Tests"
FROM orders o
INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.concept_name_type = 'FULLY_SPECIFIED' AND o.voided = 0 AND cn.voided = 0
WHERE o.order_type_id = 3 AND o.accession_number IS NOT NULL AND DATE(o.date_created) BETWEEN CAST('#startDate#' AS DATE) AND CAST('#endDate#' AS DATE) AND o.voided = 0
GROUP BY cn.name;