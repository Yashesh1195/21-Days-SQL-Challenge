USE hospital;

SELECT COUNT(name) AS Name_Count FROM patients;

SELECT COUNT(staff_name) AS Staff_name FROM staff;

SELECT SUM(patients_admitted) as total_admissions FROM services_weekly;

SELECT MIN(patients_admitted) as minimum_admissions FROM services_weekly;

SELECT MAX(patients_admitted) as maximum_admissions FROM services_weekly;

-- Single Aggregate
SELECT COUNT(*) AS total_patients FROM patients;

-- Multiple Aggregate
SELECT COUNT(*) AS total_patients,
AVG(age) AS avg_age, 
MIN(age) AS min_age, 
MAX(age) AS max_age, 
SUM(satisfaction) as total_satisfaction FROM patients;

-- With WHERE
SELECT AVG(satisfaction) 
FROM patients
WHERE service="emergency";

-- ✅ Round averages for cleaner output:
SELECT ROUND(AVG(age), 2) AS avg_age FROM patients;

-- ✅ **Aggregates ignore NULL** (except COUNT(*))
-- ✅ **Use DISTINCT with COUNT** to count unique values:
SELECT COUNT(DISTINCT service) AS unique_services FROM patients;
-- ✅ Alias your aggregates for readable column names:

-- Practice Questions:
-- 1. Count the total number of patients in the hospital.
SELECT COUNT(*) AS total_patients FROM patients;

-- 2. Calculate the average satisfaction score of all patients.
-- SELECT AVG(satisfaction) as avg_satisfaction FROM patients;
SELECT ROUND(AVG(satisfaction), 2) as avg_satisfaction FROM patients;

-- 3. Find the minimum and maximum age of patients.
SELECT MIN(age) AS min_age, MAX(age) AS max_age FROM patients;

-- Daily Challenge:
-- Question: Calculate the total number of patients admitted, total patients refused, and the average 
-- patient satisfaction across all services and weeks. Round the average satisfaction to 2 decimal places.
SELECT SUM(patients_admitted) AS total_patients_admitted,
SUM(patients_refused) AS total_patients_refused,
ROUND(AVG(patient_satisfaction), 2) as avg_patient_satisfaction FROM services_weekly;