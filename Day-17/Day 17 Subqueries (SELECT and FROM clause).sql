USE hospital;

-- Subqueries can also appear in SELECT (as calculated columns) and FROM (as derived tables).
-- Subquery in SELECT
-- SELECT
--     column1,
--     (SELECT aggregate FROM table2 WHERE condition) AS calculated_column
-- FROM table1;
-- -- Subquery in FROM (derived table)
-- SELECT *
-- FROM (
--     SELECT column1, column2
--     FROM table    
--     WHERE condition
-- ) AS subquery_alias;

-- Subquery in SELECT: Show each service's deviation from average
-- Write a query to display each service and the number of patients registered under it.
-- Additionally, show how much each service’s patient count deviates from the average patient count across all services.
-- Use a subquery inside the SELECT clause to calculate the average service count.
SELECT 
	p1.service,
    COUNT(*) AS patient_count,
    COUNT(*) - (
		SELECT ROUND(AVG(service_count), 2)
		FROM (
			SELECT COUNT(*) AS service_count 
			FROM patients p2
			GROUP BY p2.service
            ) AS service_counts
		) AS diff_from_avg
FROM patients p1
GROUP BY p1.service;

-- Derived table: Service statistics
-- Write a query to compare the total number of patients admitted per service with the average admissions 
-- across all services.
-- Use a derived table (subquery in FROM) to calculate total admissions and average admissions,
-- and display whether each service’s performance is “Above Average” or “Below Average”.
SELECT 
	service,
    total_admitted,
    CASE
		WHEN total_admitted > avg_admitted THEN 'Above Average'
        ELSE 'Below Average'
	END AS performance
FROM (
	SELECT 
		service,
        SUM(patients_admitted) AS total_admitted,
        (
			SELECT AVG(total)
			FROM (
				SELECT SUM(patients_admitted) AS total
                FROM services_weekly
                GROUP BY service
			) AS totals
        ) AS avg_admitted
	FROM services_weekly
    GROUP BY service
) AS service_stats;

-- Complex derived table with multiple calculations
-- Write a query to generate a weekly performance summary showing:
-- 1. Average patient satisfaction per week, 2. Total patients admitted per week
-- Also, include the overall hospital average satisfaction across all weeks by using a CROSS JOIN 
-- between two derived tables.
SELECT 
	week_stats.*,
    overall.avg_satisfaction AS hospital_avg_satisfaction
FROM (
	SELECT
		week,
        AVG(patient_satisfaction) AS weekly_avg_satisfaction,
        SUM(patient_satisfaction) AS weekly_admissions
	FROM services_weekly
    GROUP BY week
) AS week_stats
CROSS JOIN (
	SELECT AVG(patient_satisfaction) AS avg_satisfaction
    FROM services_weekly
) AS overall;

-- Tips & Tricks
-- ✅ **Always alias derived tables**:
-- -- ❌ Missing alias: FROM (SELECT ...)
-- -- ✅ Correct: FROM (SELECT ...) AS alias

-- ✅ **Subquery in SELECT must return single value**:
-- -- This works (single value):
-- SELECT name, (SELECT COUNT(*) FROM staff) AS total_staff
-- -- This fails (multiple values):
-- SELECT name, (SELECT staff_name FROM staff)  -- ERROR

-- ✅ **Use derived tables to organize complex logic**:
-- Instead of one massive query, break into logical steps
SELECT *
FROM (
    -- Step 1: Calculate metrics    
    SELECT service, COUNT(*) as count FROM patients GROUP BY service
) AS step1
JOIN (
    -- Step 2: Calculate different metrics    
    SELECT service, AVG(satisfaction) as avg_sat FROM patients GROUP BY service
) AS step2 ON step1.service = step2.service;

-- ✅ CTEs (Day 21) are often cleaner than derived tables for complex queries

-- ✅ Correlated subqueries in SELECT execute once per row (can be slow):
SELECT
    p.name,
    (SELECT AVG(satisfaction)
     FROM patients p2
     WHERE p2.service = p.service) AS service_avg  -- Runs for each patient
FROM patients p;

-- Practice Questions:
-- 1. Show each patient with their service's average satisfaction as an additional column.
SELECT 
	p.patient_id,
    p.name,
    p.service,
    (
		SELECT AVG(s.patient_satisfaction) AS avg_satisfaction
        FROM services_weekly s
        WHERE p.service = s.service
    ) AS avg_service_satisfaction
FROM patients p;

-- 2. Create a derived table of service statistics and query from it.
SELECT
	service,
    total_admitted,
    avg_satisfaction,
    CASE 
		WHEN total_admitted > overall_avg THEN 'Above Average'
        ELSE 'Below Averge'
	END AS performance
FROM (
	SELECT 
		service,
        SUM(patients_admitted) AS total_admitted,
        AVG(patient_satisfaction) AS avg_satisfaction,
        (
			SELECT AVG(total)
			FROM (
				SELECT SUM(patients_admitted) AS total
				FROM services_weekly
				GROUP BY service
                ) AS totals
        ) AS overall_avg
	FROM services_weekly
    GROUP BY service
) AS service_stats;

-- 3. Display staff with their service's total patient count as a calculated field.
SELECT 
	s.*,
    (
		SELECT COUNT(*)
        FROM patients p
        WHERE p.service = s.service
    ) AS total_patients_for_service
FROM staff s;

-- Daily Challenge:
-- Question: Create a report showing each service with: service name, total patients admitted, 
-- the difference between their total admissions and the average admissions across all services, 
-- and a rank indicator ('Above Average', 'Average', 'Below Average'). Order by total patients admitted descending.
SELECT
	service,
    total_admitted,
    total_admitted - avg_admitted AS diff_from_avg,
    CASE
		WHEN total_admitted > avg_admitted THEN 'Above Average'
		WHEN total_admitted = avg_admitted THEN 'Average'
        ELSE 'Below Average'
	END AS rank_indicator
FROM (
	SELECT
		service,
        SUM(patients_admitted) AS total_admitted,
        (
			SELECT AVG(total)
            FROM (
				SELECT SUM(patients_admitted) AS total
                FROM services_weekly
                GROUP BY service
            )AS totals
        ) AS avg_admitted
        FROM services_weekly
        GROUP by service
) AS service_stats
ORDER BY total_admitted DESC;