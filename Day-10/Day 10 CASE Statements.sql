USE hospital;

-- CASE statements add conditional logic to your queries, like if-else statements in programming.
-- Simple CASE
-- CASE column_name
--     WHEN value1 THEN result1
--     WHEN value2 THEN result2
--     ELSE default_result
-- END
-- Searched CASE (more flexible)
-- CASE    
-- 	WHEN condition1 THEN result1
-- 	WHEN condition2 THEN result2
-- 	ELSE default_result
-- END

-- Categorize patient satisfaction
SELECT
	name,
    satisfaction,
    CASE
		WHEN satisfaction >= 90 THEN 'Excellent'
        WHEN satisfaction >= 75 THEN 'Good'
        WHEN satisfaction >= 60 THEN 'Fair'
        ELSE 'Needs Improvement'
	END AS satisfaction_category
FROM patients;

-- Create age groups
SELECT
	name,
    age,
    CASE
		WHEN age < 18 THEN 'Pediatric'
        WHEN age BETWEEN 18 AND 65 THEN 'Adult'
        ELSE 'Senior'
	END AS age_group
FROM patients;

-- Conditional aggregation
SELECT 
	service,
    COUNT(*) AS total,
    SUM(CASE WHEN satisfaction >= 80 THEN 1 ELSE 0 END) AS high_satisfaction_count,
    SUM(CASE WHEN satisfaction < 60 THEN 1 ELSE 0 END) AS low_satisfaction_count
FROM patients
GROUP BY service;

-- ✅ **Always include ELSE** to handle unexpected values (otherwise returns NULL)
-- ✅ **CASE is an expression, not a statement** - use it anywhere you’d use a column
-- ✅ **Use CASE in ORDER BY** for custom sorting:
-- ORDER BY 
-- 		CASE
-- 		    WHEN service = 'Emergency' THEN 1    
-- 		    WHEN service = 'ICU' THEN 2    
-- 		    ELSE 3
--     END

-- ✅ Conditional aggregation pattern:
-- SUM(CASE WHEN condition THEN 1 ELSE 0 END)  -- Count matching rows
-- AVG(CASE WHEN condition THEN value ELSE NULL END)  -- Conditional average

-- ✅ **Nest CASE statements** for complex logic (but consider readability)
-- ✅ **CASE evaluates top-to-bottom** - first match wins, so order matters!

-- Practice Questions:
-- 1. Categorise patients as 'High', 'Medium', or 'Low' satisfaction based on their scores.
SELECT
	name,
    satisfaction,
    CASE
		WHEN satisfaction >= 80 THEN 'High'
        WHEN satisfaction >= 60 THEN 'Medium'
        ELSE 'Low'
	END AS satisfaction_category
FROM patients;

-- 2. Label staff roles as 'Medical' or 'Support' based on role type.
SELECT
	staff_name,
    CASE
		WHEN role = 'doctor' OR 'nurse' THEN 'Meidcal'
        ELSE 'Support'
	END AS staff_role
FROM staff;

-- 3. Create age groups for patients (0-18, 19-40, 41-65, 65+).
SELECT 
	name,
    CASE
		WHEN age >= 65 THEN "Senior Citizen"
        WHEN age BETWEEN 41 AND 65 THEN "Senior"
        WHEN age BETWEEN 19 AND 41 THEN "Adult"
        ELSE 'Child'
	END AS age_group
FROM patients;

-- Daily Challenge:
-- Question: Create a service performance report showing service name, total patients admitted, and a performance category 
-- based on the following: 'Excellent' if avg satisfaction >= 85, 'Good' if >= 75, 'Fair' if >= 65, otherwise 'Needs Improvement'. 
-- Order by average satisfaction descending.
SELECT
	service,
    SUM(patients_admitted) AS total_patients_admitted,
    ROUND(AVG(patient_satisfaction), 2) AS avg_satisfaction,
    CASE
		WHEN AVG(patient_satisfaction) >= 85 THEN 'Excellent'
		WHEN AVG(patient_satisfaction) >= 75 THEN 'Good'
		WHEN AVG(patient_satisfaction) >= 65 THEN 'Fair'
        ELSE 'Needs Improvement'
	END AS 'performance_category'
FROM services_weekly
GROUP BY service
ORDER BY avg_satisfaction DESC;