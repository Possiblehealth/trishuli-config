select count(*) AS 'Total Patients Admitted', SUM(DATEDIFF(visit.date_stopped, visit.date_started)) AS 'Total Hospital Stay'
FROM person
JOIN visit on visit.patient_id = person.person_id and cast(visit.date_stopped as date) between '#startDate#' and '#endDate#'
JOIN visit_attribute as va on va.visit_id = visit.visit_id and va.value_reference = 'IPD'
LEFT JOIN visit_attribute_type vat on vat.visit_attribute_type_id = va.attribute_type_id AND vat.name = 'Visit Status';