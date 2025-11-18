USE hospital;

-- LEFT JOIN returns all rows from the left table, with matching rows from the right table (or NULL if no match). RIGHT JOIN does the opposite.
-- Basic Syntax:

-- LEFT JOIN (most common)
-- SELECT columns FROM table1
-- LEFT JOIN table2 ON table1.column = table2.column;
-- RIGHT JOIN (less common)
-- SELECT columns FROM table1
-- RIGHT JOIN table2 ON table1.column = table2.column;

-- **Key Differences:**
-- - **INNER JOIN**: Only matching rows from both tables
-- - **LEFT JOIN**: All rows from left table + matches from right (NULL if no match)
-- - **RIGHT JOIN**: All rows from right table + matches from left (NULL if no match)

-- **Examples:**
-- All staff with their schedule (including staff with no schedule)
-- Create a report showing all staff members along with their scheduling details.
-- Include every staff member, even those who do not have any schedule records.
-- Display the following columns: staff_id, staff_name, role, service, 
-- weeks_scheduled (total number of weeks they have been scheduled), 
-- weeks_present (total number of weeks they were present)
SELECT 
	s.staff_id,
    s.staff_name,
    s.role,
    s.service,
    COUNT(ss.week) AS weeks_scheduled,
    SUM(COALESCE(ss.present, 0)) AS weeks_present
FROM staff s
LEFT JOIN staff_schedule ss ON s.staff_id = ss.staff_id
GROUP BY s.staff_id, s.staff_name, s.role, s.service;

-- Find staff with NO schedule records
-- Write an SQL query to find all staff members who have no schedule records in the staff_schedule table.
-- Display all columns from the staff table for such staff members.
SELECT 
	s.staff_id,
    s.staff_name,
    s.role,
    s.service
FROM staff s
LEFT JOIN staff_schedule ss ON s.staff_id = ss.staff_id
WHERE ss.staff_id IS NULL;

-- All services and their stats (even services with no patients)
-- Create a report showing all services along with their weekly patient count.
-- Include every service, even those that have no patients for a given week.
-- Display the following columns: service, week, patient_count
SELECT 
	sw.week,
    sw.service,
    COUNT(p.patient_id) AS patient_count
FROM services_weekly sw
LEFT JOIN patients p ON sw.service = p.service
GROUP BY sw.week, sw.service;

-- ✅ LEFT JOIN is more common than RIGHT JOIN - you can rewrite RIGHT as LEFT by swapping tables:
-- -- These are equivalent:
-- FROM table1 RIGHT JOIN table2 ON ...
-- FROM table2 LEFT JOIN table1 ON ...

-- ✅ Use COALESCE with LEFT JOIN to handle NULLs:
SELECT
	s.staff_name,
    COALESCE(SUM(ss.present), 0) AS weeks_present
FROM staff s
LEFT JOIN staff_schedule ss ON s.staff_id = ss.staff_id
GROUP BY s.staff_name;

-- ✅ Find non-matching rows using WHERE column IS NULL:
-- Staff with no schedule entries
-- FROM staff s
-- LEFT JOIN staff_schedule ss ON s.staff_id = ss.staff_id
-- WHERE ss.staff_id IS NULL

-- ✅ WHERE vs ON in LEFT JOIN:
-- ON: Filters before joining (keeps all left rows)
-- LEFT JOIN table2 ON condition AND table2.column = 'value'
-- WHERE: Filters after joining (can exclude left rows)
-- LEFT JOIN table2 ON condition
-- WHERE table2.column = 'value'

-- ✅ LEFT JOIN preserves row count from left table (or increases it with duplicates)

-- Practice Questions:
-- 1. Show all staff members and their schedule information (including those with no schedule entries).
SELECT
	s.staff_id,
    s.staff_name,
    s.role,
    s.service,
    COUNT(ss.week) AS weeks_scheduled,
    SUM(COALESCE(ss.present, 0)) AS weeks_persent
FROM staff s
LEFT JOIN staff_schedule ss ON s.staff_id = ss.staff_id
GROUP BY s.staff_id, s.staff_name, s.role, s.service;
    
-- 2. List all services from services_weekly and their corresponding staff (show services even if no staff assigned).
SELECT 
	sw.week,
    sw.service,
    s.staff_id,
    s.staff_name,
    s.role
FROM services_weekly sw
LEFT JOIN staff s ON sw.service = s.service;

-- 3. Display all patients and their service's weekly statistics (if available).
SELECT 
	p.patient_id,
    p.name,
    p.service,
    sw.week,
    sw.patients_admitted,
    sw.patient_satisfaction,
    sw.staff_morale
FROM patients p
LEFT JOIN services_weekly sw ON p.service = sw.service
ORDER BY p.patient_id, sw.week;

-- Daily Challenge:
-- Question: Create a staff utilisation report showing all staff members (staff_id, staff_name, role, service) 
-- and the count of weeks they were present (from staff_schedule). 
-- Include staff members even if they have no schedule records. 
-- Order by weeks present descending.
SELECT 
	s.staff_id,
    s.staff_name,
    s.role,
    s.service,
    SUM(COALESCE(ss.present, 0)) AS weeks_present
FROM staff s
LEFT JOIN staff_schedule ss ON s.staff_id = ss.staff_id
GROUP BY s.staff_id, s.staff_name, s.role, s.service
ORDER BY SUM(COALESCE(ss.present, 0));