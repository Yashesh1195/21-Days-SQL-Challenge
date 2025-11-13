USE hospital;

-- CTEs(Common Table Expressions) (WITH clauses) create temporary named result sets that exist only during query execution. 
-- They make complex queries more readable and maintainable.
-- WITH cte_name AS (
--     SELECT columns    
--     FROM table    
--     WHERE condition
-- )
-- SELECT *
-- FROM cte_name;

-- Multiple CTEs:
-- WITH
-- cte1 AS (
--     SELECT ...
-- ),
-- cte2 AS (
--     SELECT ...
-- )
-- SELECT *FROM cte1
-- JOIN cte2 ON ...;

-- Simple CTE for service statistics
-- Write a query to display each service along with the total number of patients and the average satisfaction score.
-- Then, show only those services where the average satisfaction is greater than 75, 
-- ordered by the number of patients in descending order.
-- Use a CTE (Common Table Expression) to organize your query.
WITH service_stats AS (
	SELECT 
		service,
		COUNT(*) AS total_patients,
		AVG(satisfaction) AS avg_satisfaction
	FROM patients
	GROUP BY service
)
SELECT * FROM service_stats
WHERE avg_satisfaction > 75
ORDER BY total_patients DESC;

-- Multiple CTEs for complex analysis
-- Write a query using multiple CTEs to generate a detailed service performance report.
-- Your output should include for each service:
-- - Total number of patients
-- - Average patient age
-- - Average satisfaction score
-- - Total number of staff members
-- - Total admitted and refused patients (from weekly records)
-- - The admission rate = (total_admitted / (total_admitted + total_refused)) × 100
-- Finally, display the results ordered by average satisfaction in descending order.
WITH
patient_metrics AS (
	SELECT 
		service,
        COUNT(*) AS total_patients,
        AVG(age) AS avg_age,
        AVG(satisfaction) AS avg_satisfaction
	FROM patients
    GROUP BY service
),
staff_metrics AS (
	SELECT 
		service,
        COUNT(*) AS total_staff
	FROM staff
    GROUP BY service
),
weekly_metrics AS (
	SELECT 
		service,
        SUM(patients_admitted) AS total_admitted,
        SUM(patients_refused) AS total_refused
	FROM services_weekly
    GROUP BY service
)
SELECT 
	pm.service,
    pm.total_patients,
    pm.avg_age,
    pm.avg_satisfaction,
    sm.total_staff,
    wm.total_admitted,
    wm.total_refused,
    ROUND(100.0 * wm.total_admitted / (wm.total_admitted + wm.total_refused), 2) AS admission_rate
FROM patient_metrics pm
LEFT JOIN staff_metrics sm ON pm.service = sm.service
LEFT JOIN weekly_metrics wm ON pm.service = wm.service
ORDER BY pm.avg_satisfaction DESC;

-- CTE referencing another CTE
-- Write a query to list all patients who belong to high-performing services.
-- A high-performing service is defined as one having total admissions greater 
-- than the average admissions across all services.
-- Use one CTE to calculate total admissions per service, 
-- and another CTE (that references the first) to filter only high-performing ones.
WITH
all_admissions AS (
	SELECT
		service,
        SUM(patients_admitted) AS total
	FROM services_weekly
    GROUP BY service
),
high_performing_services AS (
	SELECT service
    FROM all_admissions
    WHERE total > (SELECT AVG(total) FROM all_admissions)
)
SELECT *
FROM patients
WHERE service IN (SELECT service FROM high_performing_services);

-- ✅ CTEs vs Subqueries:
-- - CTEs: More readable, can be referenced multiple times
-- - Subqueries: More concise for simple cases
-- CTE (readable, reusable)
WITH avg_age AS (SELECT AVG(age) FROM patients)
SELECT * FROM patients, avg_age WHERE age > avg_age;
-- Subquery (more concise)
SELECT * FROM patients WHERE age > (SELECT AVG(age) FROM patients);

-- ✅ CTEs are evaluated once and can be referenced multiple times:
WITH service_avg AS (
    SELECT service, AVG(satisfaction) AS avg_sat
    FROM patients
    GROUP BY service
)
SELECT *
FROM patients p
JOIN service_avg sa ON p.service = sa.service
WHERE p.satisfaction > sa.avg_sat;  -- Reference CTE twice

-- ✅ Use descriptive CTE names that explain what they contain:
-- Test first CTEWITH cte1 AS (SELECT ...)
-- SELECT * FROM cte1;
-- Then add second CTEWITH cte1 AS (...), cte2 AS (...)
-- SELECT * FROM cte2;

-- ✅ Not materialized by default - some databases recalculate CTEs each time they’re referenced. 
-- Use temp tables for expensive calculations used multiple times.

-- Practice Questions:
-- 1. Create a CTE to calculate service statistics, then query from it.
WITH service_statistics AS (
	SELECT
		service,
        COUNT(*) AS total_patients,
        AVG(satisfaction) AS avg_sat,
        AVG(age) AS avg_age
	FROM patients
    GROUP BY service
)
SELECT * FROM service_statistics
WHERE avg_sat > 75
ORDER BY total_patients DESC;

-- 2. Use multiple CTEs to break down a complex query into logical steps.
WITH
patient_metrics AS (
	SELECT 
		service,
        COUNT(*) AS total_patients,
        AVG(age) AS avg_age,
        AVG(satisfaction) AS avg_satisfaction
	FROM patients
    GROUP BY service
),
staff_metrics AS (
	SELECT 
		service,
        COUNT(*) AS total_staff
	FROM staff
    GROUP BY service
),
weekly_metrics AS (
	SELECT 
		service,
        SUM(patients_admitted) AS total_admitted,
        SUM(patients_refused) AS total_refused
	FROM services_weekly
    GROUP BY service
)
SELECT 
	pm.service,
    pm.total_patients,
    pm.avg_age,
    pm.avg_satisfaction,
    sm.total_staff,
    wm.total_admitted,
    wm.total_refused,
    ROUND(100.0 * wm.total_admitted / (wm.total_admitted + wm.total_refused), 2) AS admission_rate
FROM patient_metrics pm
LEFT JOIN staff_metrics sm ON pm.service = sm.service
LEFT JOIN weekly_metrics wm ON pm.service = wm.service
ORDER BY pm.avg_satisfaction DESC;

-- 3. Build a CTE for staff utilization and join it with patient data.
WITH
staff_utilization AS (
	SELECT
		service,
        COUNT(*) AS total_staff,
        ROUND(AVG(present), 1) AS avg_weeks_present
	FROM staff_schedule
    GROUP BY service
),
patient_summary AS (
	SELECT
		service,
        COUNT(*) AS total_patients,
        ROUND(AVG(satisfaction), 2) AS avg_sat
	FROM patients
    GROUP BY service
)
SELECT 	
	ps.service,
    ps.total_patients,
    ps.avg_sat,
    su.total_staff,
    su.avg_weeks_present,
    ROUND(ps.avg_sat * (su.avg_weeks_present / 52.0), 2) AS utilization_score
FROM patient_summary ps
LEFT JOIN staff_utilization su ON ps.service = su.service
ORDER BY utilization_score DESC;

-- Daily Challenge:
-- Question: Create a comprehensive hospital performance dashboard using CTEs. 
-- Calculate: 1) Service-level metrics (total admissions, refusals, avg satisfaction), 
-- 2) Staff metrics per service (total staff, avg weeks present), 
-- 3) Patient demographics per service (avg age, count). 
-- Then combine all three CTEs to create a final report showing service name, all calculated metrics, 
-- and an overall performance score (weighted average of admission rate and satisfaction). 
-- Order by performance score descending.
WITH
service_metrics AS (
	SELECT
		service,
        SUM(patients_admitted) AS total_admissions,
        SUM(patients_refused) AS total_refusals,
        ROUND(AVG(patient_satisfaction), 2) AS avg_satisfaction
	FROM services_weekly
    GROUP BY service
),
staff_metrics AS (
	SELECT 
		service,
        COUNT(*) AS total_staff,
        ROUND(AVG(present), 2) AS avg_weeks_present
	FROM staff_schedule
    GROUP BY service
),
patient_demographics AS (
	SELECT
		service,
        COUNT(*) AS total_patients,
        ROUND(AVG(age), 2) AS avg_age
	FROM patients
    GROUP BY service
)
SELECT
	sm.service,
    sm.total_admissions,
    sm.total_refusals,
    sm.avg_satisfaction,
    st.total_staff,
    st.avg_weeks_present,
    pd.total_patients,
    pd.avg_age,
    ROUND(100.0 * sm.total_admissions / (sm.total_admissions + sm.total_refusals), 2) AS admission_rate,
    ROUND(0.6 * (100.0 * sm.total_admissions / (sm.total_admissions + sm.total_refusals))
		+ 0.4 * sm.avg_satisfaction, 2) AS performance_score
FROM service_metrics sm
LEFT JOIN staff_metrics st ON sm.service = st.service
LEFT JOIN patient_demographics pd ON sm.service = pd.service
ORDER BY performance_score DESC;