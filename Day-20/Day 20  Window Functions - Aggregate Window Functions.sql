USE hospital;

-- Aggregate window functions calculate running totals, moving averages, and cumulative statistics without collapsing rows.
-- SUM(column) OVER (...)      -- Running total
-- AVG(column) OVER (...)      -- Moving average
-- COUNT(*) OVER (...)         -- Running count
-- MIN(column) OVER (...)      -- Running minimum
-- MAX(column) OVER (...)      -- Running maximum

-- Window Frame Clauses:
-- ROWS BETWEEN start AND end
-- start/end can be:
-- UNBOUNDED PRECEDING: From first row
-- N PRECEDING: N rows before current
-- CURRENT ROW: Current row
-- N FOLLOWING: N rows after current
-- UNBOUNDED FOLLOWING: To last row

-- Running total of patients admitted per service
-- Write a query to calculate the cumulative number of patients admitted for each service over time.
-- For every week, display the running total of patients admitted within that service ordered by week.
SELECT 
	service,
    week,
    patients_admitted,
    SUM(patients_admitted) OVER (PARTITION BY service ORDER BY week) AS cummulative_admissions -- Rolling Summation
FROM services_weekly
ORDER BY service, week;

-- 3-week moving average of satisfaction
-- Write a query to compute the 3-week moving average of patient satisfaction for each service.
-- Use a window frame of the current week and the previous two weeks, and round the result to 2 decimal places.
SELECT 
	service,
    week,
    patient_satisfaction,
    ROUND(AVG(patient_satisfaction) OVER (
		PARTITION BY service
        ORDER BY week
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3week
FROM services_weekly
ORDER BY service, week;

-- Compare to service average
-- Write a query to compare each week’s patients admitted to the average admissions of that service.
-- Show the difference between the weekly admissions and the service’s overall average.
SELECT 
	service,
    week,
    patients_admitted,
    AVG(patients_admitted) OVER (PARTITION BY service) AS service_avg,
    patients_admitted - AVG(patients_admitted) OVER (PARTITION BY service) AS diff_from_avg
FROM services_weekly;

-- Running min/max
-- Write a query to find the running minimum and maximum of patient satisfaction for each service as weeks progress.
-- Display each week’s satisfaction along with the minimum so far and maximum so far within that service.
SELECT
	service,
    week,
    patient_satisfaction,
    MIN(patient_satisfaction) OVER (PARTITION BY service ORDER BY week) AS min_so_far,
    MAX(patient_satisfaction) OVER (PARTITION BY service ORDER BY week) AS max_so_far
FROM services_weekly;

-- 💡 Tips & Tricks

-- ✅ Frame clause defaults when using ORDER BY:
-- This (with ORDER BY):
-- SUM(col) OVER (ORDER BY date)
-- Is actually:
-- SUM(col) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)

-- ✅ Without ORDER BY, frame is entire partition:
-- Running total (ORDER BY included)
-- SUM(col) OVER (PARTITION BY service ORDER BY week)
-- Overall service total (no ORDER BY)
-- SUM(col) OVER (PARTITION BY service)

-- ✅ Moving averages use ROWS BETWEEN:
-- 3-period moving average (current + 2 before)
-- AVG(col) OVER (ORDER BY date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
-- Centered 5-period (2 before, current, 2 after)
-- AVG(col) OVER (ORDER BY date ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING)

-- ✅ Calculate differences from aggregates:
-- Deviation from averagecol
-- AVG(col) OVER (PARTITION BY group)
-- Percentage of total
-- 100.0 * col / SUM(col) OVER (PARTITION BY group)

-- ✅ Window functions can reference other window functions in same query (but not nest them)

-- Practice Questions:
-- 1. Calculate running total of patients admitted by week for each service.
SELECT 
	service,
    week,
    patients_admitted,
    SUM(patients_admitted) OVER (PARTITION BY service ORDER BY week) AS running_total_of_pat_adm
FROM services_weekly
ORDER BY service, week;

-- 2. Find the moving average of patient satisfaction over 4-week periods.
SELECT 
	service,
    week,
    patient_satisfaction,
    ROUND(AVG(patient_satisfaction) OVER(
		PARTITION BY service
        ORDER BY week
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_4_week_period
FROM services_weekly;
    
-- 3. Show cumulative patient refusals by week across all services.
SELECT
    week,
    SUM(patients_refused) AS weekly_refusals,
    SUM(SUM(patients_refused)) OVER (ORDER BY week) AS cummulative_refusals
FROM services_weekly
GROUP BY week
ORDER BY week;

-- Daily Challenge:
-- Question: Create a trend analysis showing for each service and week: week number, patients_admitted, 
-- running total of patients admitted (cumulative), 
-- 3-week moving average of patient satisfaction (current week and 2 prior weeks), 
-- and the difference between current week admissions and the service average. 
-- Filter for weeks 10-20 only.
SELECT
	service,
	week,
    patients_admitted,
    SUM(patients_admitted) OVER (PARTITION BY service ORDER BY week) AS cummulaive_admissions,
    ROUND(AVG(patient_satisfaction) OVER (
		PARTITION BY service
        ORDER BY week
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_3week_avg,
    patients_admitted - AVG(patients_admitted) OVER (PARTITION BY service) AS diff_from_avg_admissions
FROM services_weekly
WHERE week BETWEEN 10 AND 20
ORDER BY service, week;