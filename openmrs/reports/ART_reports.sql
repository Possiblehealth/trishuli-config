SET @start_date = '2014-10-01';
SET @end_date = '2015-02-01';

select 	'Cumulative no of Patients ever enrolled in HIV Care' as 'Anteretroviral Treatment : Status of HIV Care',
		'Beginning' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime < @start_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime < @start_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime < @start_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime < @start_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime < @start_date group by person_id),1,0)),0) as 'Others'
        from
(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, HIV care enrolled date' and o.value_datetime < @start_date group by o.person_id) as t1
        
union all

select 	'New patients enrolled in HIV care' as 'Anteretroviral Treatment : Status of HIV Care',
		'During' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'Others'
        from
		(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, HIV care enrolled date' and o.value_datetime between @start_date and @end_date group by o.person_id) as t2

union all

select 	'Number of patients transferred in HIV Care' as 'Anteretroviral Treatment : Status of HIV Care',
		'During' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',	
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'Others'
        from
		(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, Date of transferred in' and o.value_datetime between @start_date and @end_date group by o.person_id) as t3
        
union all

select 	'Number of patients transferred out' as 'Anteretroviral Treatment : Status of HIV Care',
		'During' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',	
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'Others'
        from
		(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, Date of transferred out' and o.value_datetime between @start_date and @end_date group by o.person_id) as t4
        
union all

select 	'Number of patients death reported' as 'Anteretroviral Treatment : Status of HIV Care',
		'During' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',	
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'Others'
        from
		(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, Date of death' and o.value_datetime between @start_date and @end_date group by o.person_id) as t5
        
union all

select 	'Total cumulative no of patients served' as 'Anteretroviral Treatment : Status of HIV Care',
		'End' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime < @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime < @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime < @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime < @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime < @end_date group by person_id),1,0)),0) as 'Others'
        from
(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, HIV care enrolled date' and o.value_datetime < @end_date group by o.person_id) as t6

union all

select 	'Patients medically eligible for ART but have not started' as 'Anteretroviral Treatment : Status of HIV Care',
		'End' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime < @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime < @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime < @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime < @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime < @end_date group by person_id),1,0)),0) as 'Others'
        from
(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from obs_view o 
		inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, ART eligible date' and o.value_datetime < @end_date and o.person_id not in 
        (select person_id from obs_view where concept_full_name='ART, ART start date' and value_datetime is not null and obs_datetime < @end_date)
        group by o.person_id) as t7
        
union all

select 	'Patients ever started ART at the end of last month' as 'Anteretroviral Treatment : Status of HIV Care',
		'Beginning' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime < @start_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime < @start_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime < @start_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime < @start_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime < @start_date group by person_id),1,0)),0) as 'Others'
        from
(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, ART start date' and o.value_datetime < @start_date group by o.person_id) as t8
        
union all

select 	'New patients started ART' as 'Anteretroviral Treatment : Status of HIV Care',
		'During' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'Others'
        from
(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, ART start date' and o.value_datetime between @start_date and @end_date group by o.person_id) as t9

union all

select 	'Patients on ART transferred in' as 'Anteretroviral Treatment : Status of HIV Care',
		'During' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'Others'
        from
(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, ART start date' and o.value_datetime is not null and o.person_id in 
        (select person_id from obs_view where concept_full_name = 'ART, Date of transferred in' and value_datetime between @start_date and @end_date)
        group by o.person_id) as t10
        
union all

select 	'Patients ever started ART at the end of this month' as 'Anteretroviral Treatment : Status of HIV Care',
		'End' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime < @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime < @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime < @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime < @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime < @end_date group by person_id),1,0)),0) as 'Others'
        from
(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, ART start date' and o.value_datetime < @end_date group by o.person_id) as t11
        
union all

select 	'Total patients on ART transfer‐out (cumulative)' as 'Anteretroviral Treatment : Status of HIV Care',
		'End' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime < @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime < @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime < @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime < @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime < @end_date group by person_id),1,0)),0) as 'Others'
        from
(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, ART start date' and o.value_datetime is not null and o.person_id in 
        (select person_id from valid_coded_obs_view where concept_full_name = 'ART, Reason for end of follow-up' and value_concept_full_name = 'Transferred Out' and obs_datetime between @start_date and @end_date)
        group by o.person_id) as t12
        
union all

select 	'Total deaths reported (cumulative)' as 'Anteretroviral Treatment : Status of HIV Care',
		'End' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime < @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime < @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime < @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime < @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime < @end_date group by person_id),1,0)),0) as 'Others'
        from
(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, Date of death' and o.value_datetime < @end_date group by o.person_id) as t13

union all

select 	'Cumulative patients transferred out' as 'Anteretroviral Treatment : Status of HIV Care',
		'End' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime < @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime < @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime < @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime < @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime < @end_date group by person_id),1,0)),0) as 'Others'
        from
(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, Date of transferred out' and o.value_datetime < @end_date group by o.person_id) as t14
        
union all

select 	'Total patients missing (MIS)' as 'Anteretroviral Treatment : Status of HIV Care',
		'End' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime < @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime < @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime < @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime < @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime < @end_date group by person_id),1,0)),0) as 'Others'
        from
(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from valid_coded_obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, Reason for end of follow-up' and o.value_concept_full_name = 'Missing' and o.obs_datetime < @end_date group by o.person_id) as t15
        
union all

select 	'Total patients lost to follow‐up (LFU)' as 'Anteretroviral Treatment : Status of HIV Care',
		'End' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime < @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime < @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime < @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime < @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime < @end_date group by person_id),1,0)),0) as 'Others'
        from
(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from valid_coded_obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, Reason for end of follow-up' and o.value_concept_full_name = 'Lost to Follow-up' and o.obs_datetime < @end_date group by o.person_id) as t16
        
union all

select 	'Total patients stopping (ST) ART' as 'Anteretroviral Treatment : Status of HIV Care',
		'End' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime < @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime < @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime < @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime < @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime < @end_date group by person_id),1,0)),0) as 'Others'
        from
(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from valid_coded_obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, Treatment stop' and o.value_concept_full_name = 'True' and o.obs_datetime < @end_date group by o.person_id) as t17
        
union all

select 	'Total MIS/LFU/ST patients restart ART this month' as 'Anteretroviral Treatment : Status of HIV Care',
		'During' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime between @start_date and @end_date group by person_id),1,0)),0) as 'Others'
        from
(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from valid_coded_obs_view o inner join person p on o.person_id = p.person_id
		where((o.concept_full_name='ART, Treatment stop' and o.value_concept_full_name = 'True') or (o.concept_full_name='ART, Reason for end of follow-up' and o.value_concept_full_name in('Missing','Lost to Follow-up')))
        and o.person_id in (select person_id from valid_coded_obs_view where concept_full_name = 'ART, ART treatment restart' and value_concept_full_name='True' and obs_datetime between @start_date and @end_date) and
        o.obs_datetime between @start_date and @end_date group by o.person_id) as t18

union all

select 	'Total number of patients currently on ART' as 'Anteretroviral Treatment : Status of HIV Care',
		'End' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime < @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime < @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime < @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime < @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime < @end_date group by person_id),1,0)),0) as 'Others'
        from
(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, ART start date' and o.value_datetime < @end_date and o.person_id not in 
        (select person_id from valid_coded_obs_view where concept_full_name='ART, Treatment stop' and value_concept_full_name = 'True' and obs_datetime < @end_date)
        group by o.person_id) as t19
        
union all

select 	'Patients in original 1st line regimen' as 'Anteretroviral Treatment : Status of HIV Care',
		'End' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime < @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime < @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime < @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime < @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime < @end_date group by person_id),1,0)),0) as 'Others'
        from
(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, ART start date' and o.value_datetime < @end_date and o.person_id not in 
        (select person_id from valid_coded_obs_view where concept_full_name in ('ART, Treatment stop','ART, Treatment switch','ART, Treatment substitution') and value_concept_full_name = 'True' and obs_datetime < @end_date)
        group by o.person_id) as t20
        
union all

select 	'Patients in substituted 1st line regimen' as 'Anteretroviral Treatment : Status of HIV Care',
		'End' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime < @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime < @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime < @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime < @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime < @end_date group by person_id),1,0)),0) as 'Others'
        from
(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, ART start date' and o.value_datetime < @end_date and o.person_id in 
        (select person_id from valid_coded_obs_view where concept_full_name ='ART, Treatment substitution' and value_concept_full_name = 'True' and obs_datetime < @end_date)
        group by o.person_id) as t21
        
union all

select 	'Patients switched on to 2nd line regimen' as 'Anteretroviral Treatment : Status of HIV Care',
		'End' as 'of this Month',
        ifnull(sum(if(age>15 and gender='F',1,0)),0) as 'Adult - F',
        ifnull(sum(if(age>15 and gender='M',1,0)),0) as 'Adult - M',
        ifnull(sum(if(age>15 and gender not in ('M','F'),1,0)),0) as 'Adult - TG',
        ifnull(sum(if(age<1 and gender='M',1,0)),0) as 'Male child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='M',1,0)),0) as 'Male child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='M',1,0)),0) as 'Male child - 5-14',
		ifnull(sum(if(age<1 and gender='F',1,0)),0) as 'Female child - < 1',
        ifnull(sum(if((age between 1 and 5) and gender='F',1,0)),0) as 'Female child - 1-4',
        ifnull(sum(if((age between 5 and 15) and gender='F',1,0)),0) as 'Female child - 5-14',
		ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Sex Worker' and gender='F' and obs_datetime < @end_date group by person_id),1,0)),0) as 'FSW',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'People Who Inject Drugs' and obs_datetime < @end_date group by person_id),1,0)),0) as 'IDU',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'MSM and Transgenders' and obs_datetime < @end_date group by person_id),1,0)),0) as 'MSM',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name = 'Migrant' and obs_datetime < @end_date group by person_id),1,0)),0) as 'Migrant',
        ifnull(sum(if(person_id in (select person_id from person_ids where concept_full_name = 'ART, Risk Group' and value_concept_full_name not in ('Migrant', 'MSM and Transgenders', 'Sex Worker', 'People Who Inject Drugs') and obs_datetime < @end_date group by person_id),1,0)),0) as 'Others'
        from
(select o.person_id,datediff(o.obs_datetime,p.birthdate)/365 as 'age',p.gender from obs_view o inner join person p on o.person_id = p.person_id
		where o.concept_full_name='ART, ART start date' and o.value_datetime < @end_date and o.person_id in 
        (select person_id from valid_coded_obs_view where concept_full_name = 'ART, Treatment switch' and value_concept_full_name = 'True' and obs_datetime < @end_date)
        group by o.person_id) as t22;
