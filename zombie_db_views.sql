/*

Ashton Fox
DoomsdayDB – Views for Missions & Allies

*/

USE DoomsdayDB;
GO

/*=========================================================
  MISSIONS VIEWS
=========================================================*/

-- Mission overview with base name
IF OBJECT_ID('dbo.v_MissionOverview', 'V') IS NOT NULL
    DROP VIEW dbo.v_MissionOverview;
GO

CREATE VIEW dbo.v_MissionOverview
AS
SELECT
    m.mission_id,
    m.mission_name,
    m.mission_type,
    m.status,
    m.start_datetime,
    m.end_datetime,
    b.base_name AS origin_base
FROM Missions m
JOIN Base b
    ON m.origin_base_id = b.base_id;
GO

-- Active missions (Planned or In Progress)
IF OBJECT_ID('dbo.v_ActiveMissions', 'V') IS NOT NULL
    DROP VIEW dbo.v_ActiveMissions;
GO

CREATE VIEW dbo.v_ActiveMissions
AS
SELECT
    mission_id,
    mission_name,
    mission_type,
    status,
    start_datetime
FROM Missions
WHERE status IN ('Planned', 'In Progress');
GO


-- Completed missions with duration (hours)
IF OBJECT_ID('dbo.v_CompletedMissionDurations', 'V') IS NOT NULL
    DROP VIEW dbo.v_CompletedMissionDurations;
GO

CREATE VIEW dbo.v_CompletedMissionDurations
AS
SELECT
    mission_id,
    mission_name,
    mission_type,
    DATEDIFF(HOUR, start_datetime, end_datetime) AS duration_hours
FROM Missions
WHERE status = 'Completed'
  AND start_datetime IS NOT NULL
  AND end_datetime IS NOT NULL;
GO


/*=========================================================
  ALLIES VIEWS
=========================================================*/

-- Ally overview with associated base
IF OBJECT_ID('dbo.v_AllyOverview', 'V') IS NOT NULL
    DROP VIEW dbo.v_AllyOverview;
GO

CREATE VIEW dbo.v_AllyOverview
AS
SELECT
    a.ally_id,
    a.ally_name,
    a.faction_type,
    a.trust_level,
    b.base_name AS primary_base
FROM Allies a
LEFT JOIN Base b
    ON a.primary_base_id = b.base_id;
GO


-- High-trust allies only
IF OBJECT_ID('dbo.v_HighTrustAllies', 'V') IS NOT NULL
    DROP VIEW dbo.v_HighTrustAllies;
GO

CREATE VIEW dbo.v_HighTrustAllies
AS
SELECT
    ally_id,
    ally_name,
    faction_type,
    notes
FROM Allies
WHERE trust_level = 'High';
GO


-- Count of allies per base
IF OBJECT_ID('dbo.v_AlliesPerBase', 'V') IS NOT NULL
    DROP VIEW dbo.v_AlliesPerBase;
GO

CREATE VIEW dbo.v_AlliesPerBase
AS
SELECT
    b.base_name,
    COUNT(a.ally_id) AS ally_count
FROM Base b
LEFT JOIN Allies a
    ON b.base_id = a.primary_base_id
GROUP BY b.base_name;
GO

-- Survivors
CREATE VIEW vw_SurvivorDetails
AS
SELECT
    s.survivor_id,
    s.first_name,
    s.last_name,
    s.age,
    s.status,
    b.base_name,
    w.weapon_name AS primary_weapon,
    v.vehicle_name AS primary_vehicle,
    s.notes
FROM Survivors s
LEFT JOIN Base b ON s.base_id = b.base_id
LEFT JOIN Weapons w ON s.primary_weapon_id = w.weapon_id
LEFT JOIN Vehicles v ON s.primary_vehicle_id = v.vehicle_id;
GO
