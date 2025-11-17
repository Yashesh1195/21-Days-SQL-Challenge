USE hospital;

-- INNER JOIN combines rows from two tables based on a related column, returning only matching rows.
-- SELECT columns
-- FROM table1
-- INNER JOIN table2 ON table1.column = table2.column;

-- How INNER JOIN Works:
-- 1. Takes each row from table1
-- 2. Looks for matching rows in table2
-- 3. Returns only rows that have matches in BOTH tables
-- 4. Non-matching rows are excluded

-- Join patients with staff (same service)
-- Write an SQL query to display the patient details along with the staff members who belong to the same service.
-- The query should return the following columns: patient_id, patient_name, service, staff_name, role.
-- The results should be sorted first by service and then by patient name in ascending order.
SELECT
	p.patient_id,
    p.name AS patient_name,
    p.service,
    s.staff_name,
    s.role
FROM patients p
INNER JOIN staff s ON p.service = s.service
ORDER BY p.service ASC, patient_name ASC;

-- Count staff per patient service
-- Write an SQL query to find the number of staff members assigned to each patient’s service.
-- Display the following columns: patient_id, name (patient name), service, staff_count (total number of staff working under that service)
-- Group the results by each patient and their service.
SELECT 
	p.patient_id,
    p.name AS patient_name,
    p.service,
    COUNT(s.staff_id) AS staff_count
FROM patients AS p
INNER JOIN staff s ON p.service = s.service
GROUP BY p.patient_id, patient_name, p.service;

-- Multiple join conditions
SELECT * FROM services_weekly sw
INNER JOIN staff_schedule ss ON  sw.service = ss.service AND sw.week = ss.week;

-- ✅ Use table aliases for cleaner code:
-- FROM patients p      -- 'p' is alias
-- INNER JOIN staff s   -- 's' is alias

-- ✅ Always qualify columns in joins to avoid ambiguity:
-- ❌ Ambiguous: SELECT service FROM patients p JOIN staff s...
-- ✅ Clear: SELECT p.service FROM patients p JOIN staff s...

-- ✅ JOIN is optional - these are the same:
-- INNER JOIN staff ON...
-- JOIN staff ON...        -- INNER is default

-- ✅ Chain multiple joins:
-- FROM table1 t1
-- JOIN table2 t2 ON t1.id = t2.id
-- JOIN table3 t3 ON t2.id = t3.id

-- ✅ Use WHERE after ON for additional filtering:
-- FROM patients p
-- JOIN staff s ON p.service = s.service
-- WHERE p.age > 65

-- Practice Questions:
-- 1. Join patients and staff based on their common service field (show patient and staff who work in same service).
SELECT
	p.patient_id, 
    p.name,
    p.service,
    s.staff_name,
    s.role
FROM patients p
INNER JOIN staff s ON p.service = s.service
ORDER BY p.service, p.name;

-- 2. Join services_weekly with staff to show weekly service data with staff information.
SELECT
	sw.week,
    sw.service,
    s.staff_name,
    s.role
FROM services_weekly sw
INNER JOIN staff s ON sw.service = s.service
ORDER BY sw.week ASC, sw.service ASC;

-- 3. Create a report showing patient information along with staff assigned to their service.
SELECT 
	-- p.*,
	p.patient_id,
    p.name AS patient_name,
    p.arrival_date,
    p.departure_date,
    p.service,
    p.satisfaction,
    s.staff_id,
    s.staff_name
FROM patients p
INNER JOIN staff s ON p.service = s.service;

-- Daily Challenge:
-- Question: Create a comprehensive report showing patient_id, patient name, age, service, and the total number of staff members 
-- available in their service. Only include patients from services that have more than 5 staff members. 
-- Order by number of staff descending, then by patient name.
SELECT
	p.patient_id,
    p.name,
    p.age,
    p.service,
    COUNT(s.staff_id) AS total_staff_members
FROM patients p
INNER JOIN staff s ON p.service = s.service
GROUP BY p.patient_id, p.name, p.age, p.service
HAVING COUNT(s.staff_id) > 5
ORDER BY COUNT(s.staff_id) DESC, p.name ASC;