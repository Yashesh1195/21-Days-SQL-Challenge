USE hospital;

SELECT * FROM patients
ORDER BY age DESC;

SELECT * FROM patients
ORDER BY age DESC, name ASC;

SELECT name, age FROM patients
ORDER BY 2 DESC;

SELECT * FROM patients ORDER BY service, age;

SELECT * FROM patients ORDER BY age, service;

SELECT name, age, satisfaction FROM patients ORDER BY satisfaction DESC;

SELECT name, age, satisfaction FROM patients ORDER BY satisfaction DESC LIMIT 10;

-- Practice Questions:
-- 1. List all patients sorted by age in descending order.
select * from patients order by age desc;

-- 2. Show all services_weekly data sorted by week number ascending and patients_request descending.
SELECT * FROM services_weekly ORDER BY week ASC, patients_request DESC;

-- 3. Display staff members sorted alphabetically by their names.
SELECT * FROM staff ORDER BY staff_name ASC;

-- Daily Challenge:
/*Question: Retrieve the top 5 weeks with the highest patient refusals across all services, showing week, 
service, patients_refused, and patients_request. Sort by patients_refused in descending order.*/
SELECT week, service, patients_refused, patients_request FROM services_weekly ORDER BY patients_refused DESC LIMIT 5;