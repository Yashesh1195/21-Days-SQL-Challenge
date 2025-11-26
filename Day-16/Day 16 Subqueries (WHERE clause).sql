USE hospital;

-- Subqueries are queries nested inside other queries. In WHERE clauses, they filter based on results from another query.
-- SELECT columns
-- FROM table1
-- WHERE column IN (
--     SELECT column
--     FROM table2
--     WHERE condition
-- );

-- Subquery Types in WHERE:
-- - Single value: Returns one value (use =, <, >, etc.)
-- - Multiple values: Returns multiple values (use IN, NOT IN)
-- - Existence check: Use EXISTS/NOT EXISTS

-- Patients in services with high average satisfaction
SELECT * FROM patients
WHERE service IN (
	SELECT service FROM services_weekly
    GROUP BY service HAVING AVG(patient_satisfaction) > 80);
    
-- Patients older than the average age
SELECT name, age FROM patients
WHERE age > (
	SELECT AVG(age) FROM patients);
    
-- Services that had any week with refusals
SELECT DISTINCT service FROM services_weekly sw1
WHERE EXISTS (
	SELECT sw2.week FROM services_weekly sw2 
    WHERE sw2.service = sw1.service AND sw2.patients_refused > 0);
    
-- Patients NOT in services with staff shortages
SELECT * FROM patients 
WHERE service NOT IN (
	SELECT service FROM staff
    GROUP BY service HAVING COUNT(*) < 5);
    
-- 💡 Tips & Tricks

-- ✅ **IN vs EXISTS**:
-- - Use IN for small result sets
-- - Use EXISTS for better performance with large datasets 

-- ✅ **Correlated subqueries** reference outer query:
-- Find patients with above-average satisfaction in their service
SELECT * FROM patients p1
WHERE satisfaction > (
	SELECT AVG(satisfaction) FROM patients p2 
    WHERE p2.service = p1.service);
    
-- ✅ Handle NULLs with NOT IN:
-- -- NOT IN with NULL returns no rows! Use NOT EXISTS or IS NOT NULL
-- WHERE service NOT IN (SELECT service FROM table WHERE service IS NOT NULL)

-- ✅ Single-value subqueries must return exactly one row:
-- WHERE age > (SELECT AVG(age) FROM patients)  -- Must return single value

-- ✅ **Test subqueries independently** first to verify they return expected results
-- ✅ **Subqueries in WHERE are evaluated for each row** - can be slow on large datasets

-- Practice Questions:
-- 1. Find patients who are in services with above-average staff count.
SELECT * FROM patients
WHERE service IN (
	SELECT service FROM staff s
    GROUP BY service
    HAVING COUNT(s.staff_id) > (
		SELECT AVG(staff_count) FROM (
			SELECT COUNT(staff_id) AS staff_count FROM staff
            GROUP BY service
            ) AS avg_table
		)
	);

-- 2. List staff who work in services that had any week with patient satisfaction below 70.
SELECT 
	s.staff_id,
    s.staff_name,
    s.service
FROM staff s
WHERE s.service IN (
	SELECT service FROM services_weekly
    WHERE patient_satisfaction < 70);

-- 3. Show patients from services where total admitted patients exceed 1000.
SELECT 
	p.patient_id,
    p.name,
    p.service
FROM patients p
WHERE p.service IN (
	SELECT service FROM services_weekly
    GROUP BY service
    HAVING SUM(patients_admitted) > 1000);

-- Daily Challenge:
-- Question: Find all patients who were admitted to services that had at least one week where patients were refused 
-- AND the average patient satisfaction for that service was below the overall hospital average satisfaction. 
-- Show patient_id, name, service, and their personal satisfaction score.
SELECT
	p.patient_id,
    p.name,
    p.service,
    p.satisfaction
FROM patients p
WHERE p.service IN (
	SELECT service FROM services_weekly
	WHERE patients_refused > 0)
AND p.service IN (
	SELECT service FROM services_weekly
	GROUP BY service
	HAVING AVG(patient_satisfaction) < (
		SELECT AVG(patient_satisfaction) FROM services_weekly
	)
);