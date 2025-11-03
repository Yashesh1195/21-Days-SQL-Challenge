USE hospital;

SELECT * FROM patients
WHERE service="ICU";

SELECT * FROM patients
WHERE age > 60 AND service="surgery";

SELECT * FROM patients
WHERE service="emergency" OR service="surgery";

SELECT * FROM patients
WHERE age=50;

SELECT * FROM patients
WHERE (age < 18 OR age > 65) AND service="emergency";

SELECT * FROM patients
WHERE (age BETWEEN 18 AND 65) AND service="emergency";

-- Practice Questions:
-- 1. Find all patients who are older than 60 years.
SELECT * FROM patients
WHERE age > 60;

-- 2. Retrieve all staff members who work in the 'Emergency' service.
SELECT * FROM staff
WHERE service="emergency";

-- 3. List all weeks where more than 100 patients requested admission in any service.
SELECT week, service from services_weekly
WHERE patients_request > 100;

-- Daily Challenge:
/* Question: Find all patients admitted to 'Surgery' service with a 
satisfaction score below 70, showing their patient_id, name, age, and satisfaction score. */
SELECT patient_id, name, age, satisfaction FROM patients
WHERE service="surgery" AND satisfaction < 70;