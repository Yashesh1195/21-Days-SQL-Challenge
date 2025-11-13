USE hospital;
-- HAVING filters groups created by GROUP BY, similar to how WHERE filters rows.

-- Basic Syntax:
-- SELECT column1, aggregate_function(column2)
-- FROM table_name
-- GROUP BY column1
-- HAVING aggregate_condition;

-- **WHERE vs HAVING:**
-- - **WHERE**: Filters rows before grouping
-- - **HAVING**: Filters groups after grouping
-- - **WHERE**: Cannot use aggregate functions
-- - **HAVING**: Can use aggregate functions

-- Services with more than 100 patients
SELECT 
	service,
    COUNT(*) AS patient_count
FROM patients
GROUP BY service
HAVING patient_count > 100; -- or HAVING COUNT(*) > 100;

-- Combining WHERE and HAVING
SELECT service, COUNT(*) AS elderly_count
FROM patients
WHERE age >= 65
GROUP BY service
HAVING elderly_count > 20;

-- Multiple HAVING conditions
SELECT
	service,
    AVG(satisfaction) AS avg_sat,
    COUNT(*) AS count
FROM patients
GROUP BY service
HAVING avg_sat > 80 AND count > 50;

-- ✅ **Execution order**: WHERE → GROUP BY → **HAVING** → ORDER BY
-- ✅ **Use WHERE for row filtering, HAVING for group filtering**:

-- ❌ Inefficient: HAVING age > 65-- ✅ Efficient: WHERE age > 65
SELECT service, COUNT(*) FROM patients
WHERE age > 65        -- Filter before grouping (faster)
GROUP BY service;

-- ✅ **HAVING requires GROUP BY** - you can’t use HAVING without grouping
-- ✅ **You can reference column aliases in HAVING** (database-dependent):
SELECT service, COUNT(*) AS count
FROM patients
GROUP BY service
HAVING count > 100;  -- Some databases allow this

-- ✅ Combine multiple conditions with AND/OR just like WHERE

-- Practice Questions:
-- 1. Find services that have admitted more than 500 patients in total.
SELECT 
	service,
    SUM(patients_admitted) AS total_patient_admitted
FROM services_weekly
GROUP BY service
HAVING total_patient_admitted > 500;

-- 2. Show services where average patient satisfaction is below 75.
SELECT 
	service,
    AVG(patient_satisfaction) AS avg_sat
FROM services_weekly
GROUP BY service
HAVING avg_sat < 75;

-- 3. List weeks where total staff presence across all services was less than 50.
SELECT
	week,
    SUM(present) AS total_staff_present
FROM staff_schedule
GROUP BY week
HAVING total_staff_present < 50;

-- Daily Challenge:
-- Question: Identify services that refused more than 100 patients in total and 
-- had an average patient satisfaction below 80. 
-- Show service name, total refused, and average satisfaction.
SELECT
	service,
    SUM(patients_refused) AS total_patients_refused,
    AVG(patient_satisfaction) AS avg_sat
FROM services_weekly
GROUP BY service
HAVING total_patients_refused > 100 AND avg_sat < 80;