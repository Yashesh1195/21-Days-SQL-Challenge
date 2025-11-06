USE hospital;
-- String functions manipulate text data in your queries.
-- **Common String Functions:**
-- UPPER(column)           -- Convert to uppercase
-- LOWER(column)           -- Convert to lowercase
-- LENGTH(column)          -- Get string length
-- CONCAT(str1, str2)      -- Combine strings
-- TRIM(column)            -- Remove leading/trailing spaces
-- SUBSTRING(str, pos, len) -- Extract substring
-- REPLACE(str, old, new)  -- Replace text

-- Convert to uppercase
SELECT UPPER(name) AS upper_name FROM patients;

-- Convert to lowercase
SELECT LOWER(name) AS lower_name FROM patients;

-- Concatenate columns
SELECT CONCAT(name, '-', service) AS patients_info FROM patients;

-- Get name length
SELECT name, LENGTH(name) AS name_length FROM patients WHERE LENGTH(name) > 15;

-- Extract substring (first 3 characters)
SELECT SUBSTRING(name, 1, 3) AS name_abbr FROM patients;

-- Replace text
SELECT REPLACE(service, 'emergency', 'ER') AS service_abbr FROM patients;

-- Trim Text
SELECT TRIM(name) AS name_trim FROM patients;

-- ✅ Use || or CONCAT for string concatenation (database-dependent):

-- ✅ **TRIM variants**: `LTRIM()` (left), `RTRIM()` (right), `TRIM()` (both sides)
-- ✅ **Case-insensitive comparison**:
-- WHERE LOWER(name) = LOWER('john smith')  -- Matches any case

-- ✅ **String functions are great in SELECT** but avoid them in WHERE for better performance 
-- (they prevent index usage)

-- ✅ **Combine with CASE** for complex logic:
SELECT
    name,
    CASE
        WHEN LENGTH(name) > 20 THEN SUBSTRING(name, 1, 20) || '...'        ELSE name
    END AS display_name
FROM patients;

-- Practice Questions:
-- 1. Convert all patient names to uppercase.
SELECT UPPER(name) AS name_upper FROM patients;

-- 2. Find the length of each staff member's name.
SELECT staff_name, LENGTH(staff_name) AS staff_name_len FROM staff;

-- 3. Concatenate staff_id and staff_name with a hyphen separator.
SELECT CONCAT(staff_id, '-', staff_name) AS id_concat_name FROM staff;

-- Daily Challenge:
-- Question: Create a patient summary that shows patient_id, full name in uppercase, service in lowercase, 
-- age category (if age >= 65 then 'Senior', if age >= 18 then 'Adult', else 'Minor'), and name length. 
-- Only show patients whose name length is greater than 10 characters.
SELECT 
	patient_id,
    UPPER(name),
    LOWER(service),
    CASE 
		WHEN age >= 65 THEN 'Senior' 
		WHEN age >= 18 THEN 'Adult' 
		ELSE 'Minor' 
    END AS age_group,
    LENGTH(name) as name_length
FROM patients
WHERE LENGTH(name) > 10;
    