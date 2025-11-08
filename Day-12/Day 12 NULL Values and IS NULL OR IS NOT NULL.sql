USE hospital;

-- NULL represents missing or unknown data in SQL. It’s not zero, not empty string, but the absence of a value.
-- NULL Handling:
-- Check for NULL
-- IS NULL
-- IS NOT NULL
-- Replace NULL with default value
-- COALESCE(column, default_value)
-- NULL -safe comparison (some databases) column 
-- IS DISTINCT FROM value

-- Find records with NULL events
SELECT * FROM services_weekly WHERE event IS NULL;

-- Find records with non-NULL events
SELECT * FROM services_weekly WHERE event IS NOT NULL;

-- Replace NULL with default value
SELECT
	service,
    week,
    COALESCE(event, 'No Event') AS event_status	
FROM services_weekly;

-- Count NULL values
SELECT
	COUNT(*) AS total_rows,
    COUNT(event) AS non_null_events,
    COUNT(*) - COUNT(event) AS null_events
FROM services_weekly;

-- Filter excluding empties and NULLs
SELECT * FROM services_weekly
WHERE event IS NOT NULL AND event != '';

-- ✅ Never use = or != with NULL:
-- ❌ Wrong: WHERE event = NULL
-- ❌ Wrong: WHERE event != NULL
-- ✅ Correct: WHERE event IS NULL
-- ✅ Correct: WHERE event IS NOT NULL

-- ✅ NULL in arithmetic makes the entire result NULL:
-- If any value is NULL, result is 
-- NULL5 + NULL = NULL
-- NULL * 10 = NULL

-- ✅ COALESCE accepts multiple arguments and returns first non-NULL:
-- COALESCE(column1, column2, 'default')  -- Returns first non-NULL value
-- ✅ COUNT(*) includes NULLs, COUNT(column) excludes NULLs

-- ✅ Handle NULL in ORDER BY:
-- Put NULLs last
-- ORDER BY COALESCE(event, 'ZZZZ')  -- Trick to sort NULLs to end

-- ✅ Empty string (’’) is NOT NULL - they’re different! Always check both if needed

-- Practice Questions:
-- 1. Find all weeks in services_weekly where no special event occurred.
SELECT * FROM services_weekly WHERE event IS NULL OR TRIM(event) = 'none' OR LOWER(event) = 'none';

-- 2. Count how many records have null or empty event values.
SELECT COUNT(*) AS total_null_records FROM services_weekly WHERE event IS NULL OR event = 'none';

-- 3. List all services that had at least one week with a special event.
SELECT DISTINCT service FROM services_weekly WHERE event IS NOT NULL AND TRIM(event) <> '' AND LOWER(event) <> 'none';

-- Daily Challenge:
-- Question: Analyze the event impact by comparing weeks with events vs weeks without events. 
-- Show: event status ('With Event' or 'No Event'), count of weeks, average patient satisfaction, and average staff morale. 
-- Order by average patient satisfaction descending.
SELECT
	CASE
		WHEN event IS NULL OR TRIM(event) = '' OR LOWER(event) = 'none' THEN 'No Event'
		ELSE 'With Event'
	END AS event_status,
    COUNT(DISTINCT week) AS week_count,
    ROUND(AVG(patient_satisfaction), 2) AS avg_patient_satisfaction,
	ROUND(AVG(staff_morale), 2) AS avg_staff_morale
FROM services_weekly
GROUP BY event_status
ORDER BY avg_patient_satisfaction DESC;