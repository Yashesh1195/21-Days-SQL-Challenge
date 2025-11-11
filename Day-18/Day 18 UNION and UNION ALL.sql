USE hospital;

-- UNION combines results from multiple SELECT statements into a single result set.
-- SELECT column1, column2 FROM table1
-- UNION [ALL]
-- SELECT column1, column2 FROM table2;

-- **UNION vs UNION ALL:**
-- - **UNION**: Removes duplicate rows (slower)
-- - **UNION ALL**: Keeps all rows including duplicates (faster)

-- **Requirements:**
-- - Same number of columns in each SELECT
-- - Compatible data types in corresponding columns
-- - Column names from first SELECT are used

-- Combine patient and staff names
SELECT 
	name AS full_name, 
    'Patient' AS type, 
    service
FROM patients
UNION ALL
SELECT 
	staff_name AS full_name,
    'Staff' AS type,
    service
FROM staff
ORDER BY service, type, full_name;

-- High and low performers
SELECT patient_id, name, satisfaction, 'High Performer' AS category
FROM patients
WHERE satisfaction >= 90
UNION
SELECT patient_id, name, satisfaction, 'Low Performer' AS category
FROM patients
WHERE satisfaction < 60 
ORDER BY satisfaction DESC;

-- All unique services from multiple tables
SELECT DISTINCT service FROM patients
UNION
SELECT DISTINCT service FROM staff
UNION
SELECT DISTINCT service FROM services_weekly;

-- Monthly summary from different metrics
SELECT 
	'Admissions' AS metric,
    month,
    SUM(patients_admitted) AS value
FROM services_weekly
GROUP BY month
UNION ALL
SELECT
	'Refusals' AS metric,
    month,
    SUM(patients_refused) AS value
FROM services_weekly
GROUP BY month
ORDER BY month, metric;

-- 💡 Tips & Tricks
-- ✅ Use UNION ALL when possible - it’s faster since it doesn’t check for duplicates:
-- If you know there are no duplicates, use UNION ALL
SELECT * FROM patients WHERE age < 30
UNION ALL
SELECT * FROM patients WHERE age > 60;  -- No overlap, use UNION ALL

-- ✅ Column names from first query are used:
SELECT name AS patient_name FROM patients
UNION
SELECT staff_name FROM staff;

-- ✅ Use literals to identify source:
SELECT name, 'Patient' AS source FROM patients
UNION ALL
SELECT staff_name, 'Staff' AS source FROM staff;

-- ✅ Order by applies to final result:
-- ORDER BY goes at the end (not in individual queries)
SELECT name FROM patients
UNION
SELECT staff_name FROM staff
ORDER BY name;  -- Sorts combined result

-- ✅ Match data types to avoid errors:
-- Compatible types
SELECT patient_id FROM patients  
-- TEXT
UNION
SELECT staff_id FROM staff;  -- TEXT
-- Incompatible types may cause errors
SELECT age FROM patients  
-- INTEGER
UNION
SELECT staff_name FROM staff;  -- TEXT (may error)

-- Practice Questions:
-- 1. Combine patient names and staff names into a single list.
SELECT name AS patient_name, 'Patient' AS source FROM patients
UNION
SELECT staff_name, 'Staff' AS source FROM staff;

-- 2. Create a union of high satisfaction patients (>90) and low satisfaction patients (<70).
SELECT patient_id, name, satisfaction, 'HIGH SATISFACTION' AS metric 
FROM patients 
WHERE satisfaction > 90
UNION
SELECT patient_id, name, satisfaction, 'LOW SATISFACTION' AS metric 
FROM patients 
WHERE satisfaction < 70;

-- 3. List all unique names from both patients and staff tables.
SELECT name AS patient_name FROM patients
UNION
SELECT staff_name FROM staff;

-- Daily Challenge:
-- Question: Create a comprehensive personnel and patient list showing: identifier (patient_id or staff_id), 
-- full name, type ('Patient' or 'Staff'), and associated service. Include only those in 'surgery' or 'emergency' 
-- services. Order by type, then service, then name.
SELECT
	patient_id,
    name AS full_name,
    'Patient' AS type,
    service
FROM patients
WHERE LOWER(service) IN ('surgery', 'emergency')
UNION ALL
SELECT
	staff_id,
    staff_name AS full_name,
    'Staff' AS type,
    service
FROM staff
WHERE LOWER(service) IN ('surgery', 'emergency')
ORDER BY type, service, full_name;