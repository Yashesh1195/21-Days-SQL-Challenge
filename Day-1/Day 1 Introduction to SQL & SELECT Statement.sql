USE hospital;

SELECT name AS patient_name, age AS patient_age FROM patients LIMIT 10;

-- Practice Questions:
-- 1. Retrieve all columns from the patients table.
SELECT * FROM patients;

-- 2. Select only the patient_id, name, and age columns from the patients table.
SELECT patient_id, name, age FROM patients;

-- 3. Display the first 10 records from the services_weekly table.
SELECT * FROM services_weekly LIMIT 10;

-- Daily Challenge:
-- Question: List all unique hospital services available in the hospital.
SELECT DISTINCT service FROM services_weekly;