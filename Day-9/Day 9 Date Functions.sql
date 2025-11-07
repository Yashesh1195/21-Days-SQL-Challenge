USE hospital;

-- Date functions help you work with dates and times in SQL.
-- **Common Date Functions:**
-- SQLite examples (syntax varies by database)
-- DATE('now')                   -- Current date
-- JULIANDAY(date)               -- Convert to Julian day number 		-- SQLite
-- DATE(date, '+1 day')          -- Add 1 day
-- strftime('%Y', date)          -- Extract year
-- strftime('%m', date)          -- Extract month
-- strftime('%d', date)          -- Extract day
-- MySQL Syntax:-
-- DATEDIFF(end_date, start_date) 		-- returns the number of days between two dates.

-- Calculate length of stay in days
SELECT 
	patient_id,
    name,
    arrival_date,
    departure_date,
    DATEDIFF(departure_date, arrival_date) AS stay_days
FROM patients;

-- Extract parts from date
SELECT 
	patient_id,
    YEAR(arrival_date) AS arrival_year,
    MONTH(arrival_date) AS arrival_month,
    DAY(arrival_date) AS arrival_day,
    WEEK(arrival_date) AS arrival_week
FROM patients;

-- Filter by date range
SELECT * FROM patients
WHERE arrival_date BETWEEN '2025-01-01' AND '2025-12-31';

-- Find patients admitted in specific month
SELECT * FROM patients
WHERE MONTH(arrival_date) = '09';

-- ✅ **Date format matters**: Use ISO format ‘YYYY-MM-DD’ for consistency

-- ✅ **Calculate date differences** using database-specific functions:
-- MySQL: DATEDIFF(date2, date1)

-- ✅ **Use date functions in WHERE** carefully - they can slow queries on large tables

-- ✅ **Always cast date calculations** to appropriate types (INTEGER, REAL) for consistency

-- Practice Questions:
-- 1. Extract the year from all patient arrival dates.
SELECT YEAR(arrival_date) AS arrival_year FROM patients;

-- 2. Calculate the length of stay for each patient (departure_date - arrival_date).
SELECT
	patient_id,
    name,
    arrival_date,
    departure_date,
    DATEDIFF(departure_date, arrival_date) AS days_stayyed
FROM patients;

-- 3. Find all patients who arrived in a specific month.
SELECT * FROM patients WHERE MONTH(arrival_date) = '10';

-- Daily Challenge:
-- Question: Calculate the average length of stay (in days) for each service, showing only services 
-- where the average stay is more than 7 days. Also show the count of patients and order by average stay descending.
SELECT
	service,
    COUNT(*) AS total_patients,
    AVG(DATEDIFF(departure_date, arrival_date)) AS avg_len_of_stay
FROM patients
GROUP BY service
HAVING avg_len_of_stay > 7
ORDER BY avg_len_of_stay DESC;