USE idc_tech_nova;

-- 1. Identify where and when the crime happened
SELECT
	*
	-- room,
    -- found_time AS first_found_time,
    -- description AS evidence_found
FROM evidence
WHERE room = 'CEO Office';
-- GROUP BY room;

-- 2. Analyze who accessed critical areas at the time
SELECT 
    kl.log_id,
    kl.employee_id,
    e.name,
    kl.room,
    kl.entry_time,
    kl.exit_time
FROM keycard_logs kl
JOIN employees e ON kl.employee_id = e.employee_id
WHERE kl.entry_time BETWEEN '2025-10-15 20:40:00' AND '2025-10-15 21:10:00'
AND kl.room = 'CEO Office';

-- 3. Cross-check alibis with actual logs
SELECT
	e.employee_id,
    e.name,
    a.alibi_id,
    a.claimed_location,
    a.claim_time
FROM employees e
JOIN alibis a ON e.employee_id = a.employee_id
WHERE a.claim_time BETWEEN '2025-10-15 20:50:00' AND '2025-10-15 21:10:00'
AND claimed_location <> 'CEO Office';

-- --------------------OR--------------------
-- find employees whose claimed_location at ~20:50 doesn't match keycard location during same time
WITH 
claims AS (
  SELECT employee_id, claimed_location, claim_time
  FROM alibis
  WHERE claim_time BETWEEN '2025-10-15 20:40:00' AND '2025-10-15 21:10:00'
),
actual AS (
	SELECT employee_id, room, entry_time, exit_time
    FROM keycard_logs
    WHERE entry_time BETWEEN '2025-10-15 20:40:00' AND '2025-10-15 21:10:00'
)
SELECT 
	c.employee_id, 
    e.name,
	c.claimed_location,
	a.room AS actual_room,
	a.entry_time, 
	a.exit_time
FROM claims c
LEFT JOIN actual a
  ON c.employee_id = a.employee_id
  AND (c.claim_time BETWEEN a.entry_time AND a.exit_time)
JOIN employees e ON c.employee_id = e.employee_id	
WHERE c.claimed_location <> a.room
ORDER BY c.employee_id;


-- 4. Investigate suspicious calls made around the time
SELECT
	c.*,
    e1.employee_id,
    e1.name AS caller_name,
    e2.employee_id,
    e2.name AS receiver_name
FROM calls c
JOIN employees e1 ON c.caller_id = e1.employee_id
JOIN employees e2 ON c.receiver_id = e2.employee_id
WHERE c.call_time BETWEEN '2025-10-15 20:50:00' AND '2025-10-15 21:10:00'
ORDER BY c.call_time;

-- 5. Match evidence with movements and claims
SELECT ev.*, a.* FROM evidence ev
JOIN alibis a ON ev.room = a.claimed_location
WHERE ev.found_time BETWEEN '2025-10-15 20:50:00' AND '2025-10-15 21:20:00';

-- tie evidence in CEO Office to who was in that room earlier
SELECT 
	ev.evidence_id, 
    ev.room, 
    ev.description, 
    ev.found_time,
	k.employee_id, 
    em.name, 
    k.entry_time, 
    k.exit_time
FROM evidence ev
LEFT JOIN keycard_logs k ON ev.room = k.room 
  AND k.entry_time BETWEEN ev.found_time - INTERVAL 30 MINUTE AND ev.found_time
JOIN employees em ON k.employee_id = em.employee_id
WHERE ev.room = 'CEO Office'
ORDER BY ev.found_time;

-- 6. Combine all findings to identify the killer
WITH
employee_details AS (
	SELECT * 
    FROM employees
),
key_card_logs AS (
	SELECT *
	FROM keycard_logs
    WHERE entry_time BETWEEN '2025-10-15 20:40:00' AND '2025-10-15 21:20:00'
),
alibis_found AS (
	SELECT *
	FROM alibis
    WHERE claim_time BETWEEN '2025-10-15 20:40:00' AND '2025-10-15 21:20:00'
    AND claimed_location <> 'CEO Office'
),
sus_call AS (
	SELECT * 
    FROM calls c
    WHERE call_time BETWEEN '2025-10-15 20:50:00' AND '2025-10-15 21:20:00'
),
match_evidence AS (
	SELECT *
    FROM evidence
	WHERE found_time BETWEEN '2025-10-15 20:40:00' AND '2025-10-15 21:20:00'
)
SELECT 
	ed.employee_id,
    ed.name,
    kcl.log_id,
    kcl.room,
    kcl.entry_time,
    kcl.exit_time,
    af.alibi_id,
    af.claimed_location,
    af.claim_time,
    sc.*,
    me.*
FROM employee_details ed
JOIN key_card_logs kcl ON ed.employee_id = kcl.employee_id
JOIN alibis_found af ON ed.employee_id = af.employee_id
JOIN sus_call sc ON ed.employee_id = sc.caller_id OR ed.employee_id = sc.receiver_id
JOIN match_evidence me ON af.claimed_location = me.room;

-- ----------------OR------------------ --
-- 6. Combine all findings to identify the killer
WITH
employee_details AS (
	SELECT * 
    FROM employees
),
key_card_logs AS (
	SELECT employee_id
	FROM keycard_logs
    WHERE entry_time BETWEEN '2025-10-15 20:40:00' AND '2025-10-15 21:20:00'
),
alibis_found AS (
	SELECT employee_id, claimed_location
	FROM alibis
    WHERE claim_time BETWEEN '2025-10-15 20:40:00' AND '2025-10-15 21:20:00'
),
sus_call AS (
	SELECT DISTINCT caller_id AS employee_id
    FROM calls
    WHERE call_time BETWEEN '2025-10-15 20:50:00' AND '2025-10-15 21:20:00'
    UNION
	SELECT DISTINCT receiver_id AS employee_id
    FROM calls
    WHERE call_time BETWEEN '2025-10-15 20:50:00' AND '2025-10-15 21:20:00'

)
SELECT 
	CONCAT('Killer is ', ed.name) AS killer
FROM employee_details ed
JOIN key_card_logs kcl ON ed.employee_id = kcl.employee_id
JOIN alibis_found af ON ed.employee_id = af.employee_id
JOIN sus_call sc ON ed.employee_id = sc.employee_id;

-- ----------------OR------------------ --
-- 6. Combine all findings to identify the killer
WITH
employee_details AS (
	SELECT * 
    FROM employees
),
key_card_logs AS (
	SELECT employee_id
	FROM keycard_logs
    WHERE entry_time BETWEEN '2025-10-15 20:40:00' AND '2025-10-15 21:20:00'
),
alibis_found AS (
	SELECT employee_id, claimed_location
	FROM alibis
    WHERE claim_time BETWEEN '2025-10-15 20:40:00' AND '2025-10-15 21:20:00'
),
sus_call AS (
	SELECT DISTINCT caller_id AS employee_id
    FROM calls
    WHERE call_time BETWEEN '2025-10-15 20:50:00' AND '2025-10-15 21:20:00'
    UNION
	SELECT DISTINCT receiver_id AS employee_id
    FROM calls
    WHERE call_time BETWEEN '2025-10-15 20:50:00' AND '2025-10-15 21:20:00'

)
-- match_evidence AS (
-- 	SELECT *
--     FROM evidence
-- 	WHERE found_time BETWEEN '2025-10-15 20:40:00' AND '2025-10-15 21:20:00'
-- )
SELECT 
	CONCAT('Killer is ', ed.name) AS killer
    -- sc.*
    -- me.*
FROM employee_details ed
JOIN key_card_logs kcl ON ed.employee_id = kcl.employee_id
JOIN alibis_found af ON ed.employee_id = af.employee_id
JOIN sus_call sc ON ed.employee_id = sc.employee_id;
-- JOIN match_evidence me ON af.claimed_location = me.room;