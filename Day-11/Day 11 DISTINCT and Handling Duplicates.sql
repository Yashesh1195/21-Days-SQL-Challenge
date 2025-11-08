USE hospital;

-- DISTINCT removes duplicate rows from your result set, returning only unique values.
-- SELECT DISTINCT column1, column2
-- FROM table_name;

-- Key Concepts:
-- - DISTINCT considers ALL selected columns together
-- - Acts like “unique combinations”
-- - Can impact performance on large datasets

-- Get unique services
SELECT DISTINCT service FROM patients;

-- Unique combinations of service and age group
SELECT DISTINCT
	service,
    CASE
		WHEN age < 18 THEN 'Pediatric'
        WHEN age BETWEEN 18 AND 65 THEN 'Adult'
        ELSE 'Senior'
	END AS age_group
FROM patients
ORDER BY service ASC, age_group ASC;

-- Count distinct values
SELECT COUNT(DISTINCT service) AS unique_services FROM patients;

-- DISTINCT with multiple columns
SELECT DISTINCT service, arrival_date
FROM patients
ORDER BY service, arrival_date;

-- ✅ DISTINCT vs GROUP BY:
-- These are similar:
SELECT DISTINCT service FROM patients;
SELECT service FROM patients GROUP BY service;
-- Use DISTINCT for simple unique values, GROUP BY when you need aggregates

-- ✅ DISTINCT applies to entire row, not individual columns:
-- This returns unique combinations of (service, name)
SELECT DISTINCT service, name FROM patients;

-- ✅ **Use COUNT(DISTINCT column)** to count unique values within groups
-- ✅ **DISTINCT can be expensive** - consider if you really need it or if GROUP BY would work better
-- ✅ **DISTINCT with NULL**: NULL values are considered equal, so only one NULL appears
-- ✅ **Remove duplicates before processing** when possible for better performance

-- Practice Questions:
-- 1. List all unique services in the patients table.
SELECT DISTINCT service FROM patients;

-- 2. Find all unique staff roles in the hospital.
SELECT DISTINCT role FROM staff;

-- 3. Get distinct months from the services_weekly table.
SELECT DISTINCT month FROM services_weekly;

-- Daily Challenge:
-- Question: Find all unique combinations of service and event type from the services_weekly table 
-- where events are not null or none, along with the count of occurrences for each combination. 
-- Order by count descending.
SELECT
	DISTINCT service, event,
    COUNT(*) AS occurrence
FROM services_weekly
WHERE event IS NOT NULL AND LOWER(event) <> 'none'
GROUP BY service, event
ORDER BY occurrence DESC;