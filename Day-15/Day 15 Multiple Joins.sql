USE hospital;

-- Multiple joins combine data from three or more tables in a single query.
-- Basic Syntax:
-- SELECT columns
-- FROM table1
-- JOIN table2 ON table1.key = table2.key
-- JOIN table3 ON table2.key = table3.key
-- LEFT JOIN table4 ON table3.key = table4.key;

-- Join Order:
-- - Joins are evaluated left to right
-- - Results are cumulative (each join adds to the result set)
-- - Mix INNER and LEFT joins as needed

-- Comprehensive service report with staff and schedules
-- Question:
-- Create a report for week 10 showing details of each service including:
-- the service name, week number, number of patients admitted, total number of staff associated with that service, and
-- number of staff who were present in that week.
-- Include all services (even if no staff or attendance records exist).
-- Group the data by service, week, and patients admitted.
SELECT 
	sw.service,
    sw.week,
    sw.patients_admitted,
    COUNT(DISTINCT s.staff_id) AS total_staff,
    SUM(COALESCE(ss.present, 0)) AS staff_present
    -- SUM(CASE WHEN ss.present = 1 THEN 1 ELSE 0 END) AS staff_present
FROM services_weekly sw
LEFT JOIN staff s ON sw.service = s.service
LEFT JOIN staff_schedule ss ON s.staff_id = ss.staff_id AND sw.week = ss.week
WHERE sw.week = 10
GROUP BY sw.service, sw.week, sw.patients_admitted;

-- Patient admission with staff availability
-- Question:
-- Generate a report showing each patient’s information along with details of staff assigned to their service.
-- For each patient, display: patient ID, patient name, service, arrival date, 
-- count of distinct staff assigned to that service, and average staff presence (based on attendance records).
-- Group the results by patient details.
SELECT 
	p.patient_id,
    p.name AS patient_name,
    p.service,
    p.arrival_date,
    COUNT(DISTINCT s.staff_id) AS assigned_staff,
    AVG(ss.present) AS avg_staff_presence
FROM patients p
INNER JOIN staff s ON p.service = s.service
LEFT JOIN staff_schedule ss ON s.staff_id = ss.staff_id
GROUP BY p.patient_id, p.name, p.service, p.arrival_date;

-- 💡 Tips & Tricks
-- ✅ **Start with the main table** (the one you want all rows from)
-- ✅ **Use LEFT JOIN when you want all rows** from the left table, INNER JOIN when you only want matches
-- ✅ **Join order matters** with mixed join types:

-- These can produce different results:
-- FROM table1
-- LEFT JOIN table2 ON ...
-- INNER JOIN table3 ON ...
-- FROM table1
-- INNER JOIN table3 ON ...
-- LEFT JOIN table2 ON ...

-- ✅ **Use DISTINCT or GROUP BY** if joins create duplicates
-- ✅ **Test joins incrementally** - add one join at a time to verify results

-- Practice Questions:
-- 1. Join patients, staff, and staff_schedule to show patient service and staff availability.
SELECT 
	p.patient_id,
    p.name,
    p.age,
    p.service,
    s.staff_id,
    s.staff_name,
    ss.week,
    ss.present
FROM patients p
JOIN staff s ON p.service = s.service
LEFT JOIN staff_schedule ss ON s.staff_id = ss.staff_id
ORDER BY p.patient_id, ss.week;

-- 2. Combine services_weekly with staff and staff_schedule for comprehensive service analysis.
SELECT 
	sw.week,
    sw.service,
    sw.patients_admitted,
    sw.patients_refused,
    ROUND(AVG(patient_satisfaction), 2) AS avg_sat,
    COUNT(DISTINCT s.staff_id) AS total_staff,
    SUM(COALESCE(ss.present, 0)) AS staff_persent
FROM services_weekly sw 
LEFT JOIN staff s ON sw.service = s.service
LEFT JOIN staff_schedule ss ON sw.week = ss.week
GROUP BY sw.week, sw.service, sw.patients_admitted, sw.patients_refused
ORDER BY sw.week, sw.service; 

-- 3. Create a multi-table report showing patient admissions with staff information.
SELECT 
	p.patient_id,
    p.name AS patient_name,
    p.service,
    p.arrival_date,
    COUNT(DISTINCT s.staff_id) AS assigned_staff,
    AVG(ss.present) AS avg_staff_presence
FROM patients p
INNER JOIN staff s ON p.service = s.service
LEFT JOIN staff_schedule ss ON s.staff_id = ss.staff_id
GROUP BY p.patient_id, p.name, p.service, p.arrival_date
ORDER BY p.arrival_date ASC;

-- Daily Challenge:
-- Question: Create a comprehensive service analysis report for week 20 showing: service name, 
-- total patients admitted that week, total patients refused, average patient satisfaction, 
-- count of staff assigned to service, and count of staff present that week. 
-- Order by patients admitted descending.
SELECT 
	sw.week,
	sw.service,
    sw.patients_admitted,
    sw.patients_refused,
    ROUND(AVG(sw.patient_satisfaction), 2) AS avg_pat_sat,
    COUNT(DISTINCT s.staff_id) AS total_staff,
    SUM(COALESCE(ss.present, 0)) AS staff_present
FROM services_weekly sw
LEFT JOIN staff s ON sw.service = s.service
LEFT JOIN staff_schedule ss ON s.staff_id = ss.staff_id AND sw.week = ss.week
WHERE sw.week = 20
GROUP BY sw.service, sw.week, sw.patients_admitted, sw.patients_refused
ORDER BY sw.patients_admitted DESC;