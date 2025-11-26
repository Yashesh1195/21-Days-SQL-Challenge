USE hospital;

-- Window functions perform calculations across rows related to the current row, without collapsing results like GROUP BY.
-- window_function() OVER (
--     [PARTITION BY column]
--     [ORDER BY column]
-- )

-- Ranking Functions:
-- - ROW_NUMBER(): Sequential numbering (1, 2, 3, 4…)
-- - RANK(): Same values get same rank, gaps after ties (1, 2, 2, 4…)
-- - DENSE_RANK(): Same values get same rank, no gaps (1, 2, 2, 3…)

-- Number patients within each service
-- Write a query to assign a sequential number to each patient within their service, 
-- ordered by their satisfaction score (highest first). Display the patient ID, name, service, satisfaction, 
-- and their number within the service.
SELECT
	patient_id,
    name,
    service,
    satisfaction,
    ROW_NUMBER() OVER (PARTITION BY service ORDER BY satisfaction DESC) AS sat_row_num
FROM patients;

-- Rank patients by satisfaction (with ties)
-- Write a query to rank all patients based on their satisfaction score (highest first). 
-- Include both RANK() and DENSE_RANK() functions to show the difference between them 
-- when patients have the same satisfaction score.
SELECT 
	patient_id,
    name,
    satisfaction,
    RANK() OVER (ORDER BY satisfaction DESC) AS rnk,
    DENSE_RANK() OVER (ORDER BY satisfaction DESC) AS dense_rnk
FROM patients;

-- Top 3 weeks by satisfaction per service
-- For each service, find the top 3 weeks with the highest patient satisfaction. 
-- Use window functions to rank weeks within each service and display only those weeks ranked 1 to 3.
SELECT * 
FROM (
	SELECT
		service,
        week,
        patient_satisfaction,
        RANK() OVER (PARTITION BY service ORDER BY patient_satisfaction DESC) AS sat_rnk
	FROM services_weekly
) AS top_3_rank
WHERE sat_rnk <= 3
ORDER BY sat_rnk, service;

-- Rank services by total admissions
-- Write a query to calculate the total number of patients admitted for each service and 
-- then rank the services based on total admissions (highest first).
SELECT
	service,
    SUM(patients_admitted) AS total_patients_admitted,
    RANK() OVER (ORDER BY SUM(patients_admitted) DESC) AS patient_admissions_rank
FROM services_weekly
GROUP BY service;

-- 💡 Tips & Tricks

-- ✅ PARTITION BY is optional - without it, window applies to entire result set:
-- -- Rank across all patients
-- RANK() OVER (ORDER BY satisfaction DESC)
-- -- Rank within each service
-- RANK() OVER (PARTITION BY service ORDER BY satisfaction DESC)

-- ✅ Choose the right ranking function:
-- - ROW_NUMBER() when you need unique numbers
-- - RANK() when ties should skip numbers (1, 2, 2, 4)
-- - DENSE_RANK() when ties shouldn’t skip (1, 2, 2, 3)

-- ✅ Filter ranked results with subquery:
-- Can't use WHERE with window functions directly
-- Use subquery:
SELECT * FROM (
	SELECT *, ROW_NUMBER() OVER (ORDER BY age DESC) AS rn
	FROM patients
) rn_age
WHERE rn <= 10;

-- ✅ ORDER BY in OVER is different from query ORDER BY:
SELECT
    name,
    age,
    ROW_NUMBER() OVER (ORDER BY age DESC) AS rn  -- For numbering
FROM patients
ORDER BY name;  -- For final result display

-- ✅ Window functions don’t reduce rows like GROUP BY - each input row gets an output row

-- Practice Questions:
-- 1. Rank patients by satisfaction score within each service.
SELECT 
	*,
    RANK() OVER (PARTITION BY service ORDER BY satisfaction DESC) AS satisfaction_rank,
    DENSE_RANK() OVER (PARTITION BY service ORDER BY satisfaction DESC) AS dense_satisfaction_rank
FROM patients;

-- 2. Assign row numbers to staff ordered by their name.
SELECT 
	*,
    ROW_NUMBER() OVER (ORDER BY staff_name ASC) AS staff_rows
FROM staff;

-- 3. Rank services by total patients admitted.
SELECT
	service,
    SUM(patients_admitted) AS total_patient_admitted,
    RANK() OVER (ORDER BY SUM(patients_admitted) DESC) AS patient_admission_rank
FROM services_weekly
GROUP BY service;

-- Daily Challenge:
-- Question: For each service, rank the weeks by patient satisfaction score (highest first). 
-- Show service, week, patient_satisfaction, patients_admitted, and the rank. 
-- Include only the top 3 weeks per service.
SELECT *
FROM (
	SELECT 
		service,
		week,
		patient_satisfaction,
		patients_admitted,
		RANK() OVER (PARTITION BY service ORDER BY patient_satisfaction DESC) AS sat_rank
	FROM services_weekly
) AS satisfaction_ranking
WHERE sat_rank <= 3;