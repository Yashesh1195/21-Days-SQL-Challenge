USE hospital;

-- GROUP BY divides rows into groups based on column values, then applies aggregate functions to each group.
-- Basic Syntax:
-- SELECT column1, aggregate_function(column2)
-- FROM table_name
-- GROUP BY column1;

-- Key Rules:
-- - Every non-aggregated column in SELECT must be in GROUP BY
-- - Each group produces one result row
-- - Use aggregates (COUNT, SUM, AVG, etc.) on other columns

-- Count patients per service
SELECT 
	service,
	COUNT(*) AS patient_count
FROM patients
GROUP BY service
ORDER BY service ASC;

-- Multiple aggregates per group
-- Question:- Write a query to display, for each service, the total number of patients, the average age of patients, and the average 
-- satisfaction score.The results should be grouped by service and ordered in descending order of the total number of patients.
SELECT 
	service,
	COUNT(*) AS total_patients,
    AVG(age) AS avg_age,
    ROUND(AVG(satisfaction), 2) AS avg_satisfaction
FROM patients
GROUP BY service
ORDER BY total_patients DESC;

-- Group by multiple columns
-- Question:- Write a query to display, for each service, the number of patients grouped by age category.
-- Classify patients as 'Senior' if their age is 65 or above, and as 'Adult' otherwise.
-- Show the service name, the age group, and the count of patients in each group.
SELECT 
	service,
    CASE WHEN age >= 65 THEN 'Senior' ELSE 'Adult' END AS age_group,
    COUNT(*) AS count
FROM patients
GROUP BY service, age_group
ORDER BY service ASC;

SELECT service, COUNT(*) AS count
FROM patients
GROUP BY service
ORDER BY count DESC;  -- Order by the aggregated count

-- Practice Questions:
-- 1. Count the number of patients by each service.
SELECT 
	service,
    COUNT(*) AS patient_count
FROM services_weekly
GROUP BY service
ORDER BY service ASC;
    
-- 2. Calculate the average age of patients grouped by service.
SELECT 
	service,
    AVG(age) AS avg_age
FROM patients
GROUP BY service
ORDER BY service ASC;

-- 3. Find the total number of staff members per role.
SELECT 
	role,
    COUNT(*) AS staff_count
FROM staff
GROUP BY role
ORDER BY role ASC;

-- Daily Challenge:
-- Question: For each hospital service, calculate the total number of patients admitted, total patients refused, 
-- and the admission rate (percentage of requests that were admitted). Order by admission rate descending.
SELECT 
	service,
    SUM(patients_admitted) AS total_patients_admitted,
    SUM(patients_refused) AS total_patients_refused,
    ROUND(SUM(patients_admitted) * 100.0 / SUM(patients_request), 2) AS admission_rate
FROM services_weekly
GROUP BY service
ORDER BY admission_rate DESC;