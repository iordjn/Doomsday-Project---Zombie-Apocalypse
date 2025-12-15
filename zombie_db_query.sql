/* Alex query */
/* for the water table */
SELECT SUM(volume_liters) AS total_volume
FROM Water
GROUP BY source_type;

/* for the food table */
SELECT food_name, shelf_life_days
FROM FOOD
WHERE shelf_life_days > 700;

/*Ashton querys*/
------------------------------------------------------------
-- MISSIONS TEST QUERIES
------------------------------------------------------------

-- List all missions with their originating base name
SELECT
    m.mission_id,
    m.mission_name,
    m.mission_type,
    m.status,
    b.base_name
FROM Missions m
JOIN Base b
    ON m.origin_base_id = b.base_id;

-- Show only active missions (Planned or In Progress)
SELECT
    mission_name,
    mission_type,
    status,
    start_datetime
FROM Missions
WHERE status IN ('Planned', 'In Progress');

-- Show completed missions and how long they took (in hours)
SELECT
    mission_name,
    mission_type,
    DATEDIFF(HOUR, start_datetime, end_datetime) AS duration_hours
FROM Missions
WHERE status = 'Completed'
  AND start_datetime IS NOT NULL
  AND end_datetime IS NOT NULL;

-- Count missions by status
SELECT
    status,
    COUNT(*) AS mission_count
FROM Missions
GROUP BY status;

-- Show missions that originated from each base
SELECT
    b.base_name,
    COUNT(m.mission_id) AS total_missions
FROM Base b
LEFT JOIN Missions m
    ON b.base_id = m.origin_base_id
GROUP BY b.base_name;


------------------------------------------------------------
-- ALLIES TEST QUERIES
------------------------------------------------------------

-- List all allies and their associated base (if any)
SELECT
    a.ally_id,
    a.ally_name,
    a.faction_type,
    a.trust_level,
    b.base_name
FROM Allies a
LEFT JOIN Base b
    ON a.primary_base_id = b.base_id;

-- Show allies grouped by trust level
SELECT
    trust_level,
    COUNT(*) AS ally_count
FROM Allies
GROUP BY trust_level;

-- List high-trust allies and their notes
SELECT
    ally_name,
    faction_type,
    notes
FROM Allies
WHERE trust_level = 'High';

-- Count allies per base
SELECT
    b.base_name,
    COUNT(a.ally_id) AS ally_count
FROM Base b
LEFT JOIN Allies a
    ON b.base_id = a.primary_base_id
GROUP BY b.base_name;

-- Identify bases with no allied groups
SELECT
    b.base_name
FROM Base b
LEFT JOIN Allies a
    ON b.base_id = a.primary_base_id
WHERE a.ally_id IS NULL;
