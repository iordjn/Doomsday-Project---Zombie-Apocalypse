-- Scripts

-- Survivors (View)
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

-- Weapon (Stored Procedure)
CREATE PROCEDURE sp_AddWeapon
    @weapon_name   VARCHAR(80),
    @weapon_type   VARCHAR(40),
    @damage_rating INT,
    @condition     VARCHAR(20),
    @ammo_type     VARCHAR(40) = NULL
AS
BEGIN
    IF @damage_rating < 1 OR @damage_rating > 10
    BEGIN
        RAISERROR('Damage rating must be between 1 and 10.', 16, 1);
        RETURN;
    END

    INSERT INTO Weapons (weapon_name, weapon_type, damage_rating, [condition], ammo_type)
    VALUES (@weapon_name, @weapon_type, @damage_rating, @condition, @ammo_type);
END;
GO

-- Mission_Survivors (Trigger)
CREATE TRIGGER trg_PreventDuplicateMissionSurvivor
ON Mission_Survivors
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Mission_Survivors ms
        JOIN inserted i
            ON ms.mission_id = i.mission_id
           AND ms.survivor_id = i.survivor_id
           AND ms.mission_survivor_id <> i.mission_survivor_id
    )
    BEGIN
        RAISERROR('This survivor is already assigned to the mission.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Injury Type (Stored Procedure)
CREATE PROCEDURE sp_AddInjuryType
    @injury_name VARCHAR(60),
    @severity    VARCHAR(20)
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Injury_Types
        WHERE injury_name = @injury_name
    )
    BEGIN
        RAISERROR('Injury type already exists.', 16, 1);
        RETURN;
    END

    INSERT INTO Injury_Types (injury_name, severity)
    VALUES (@injury_name, @severity);
END;
GO

-- TESTING

-- Survivor Detals

SELECT * 
FROM vw_SurvivorDetails;
GO

-- Weapons

EXEC sp_AddWeapon
    @weapon_name = 'Crossbow',
    @weapon_type = 'Ranged',
    @damage_rating = 7,
    @condition = 'Good',
    @ammo_type = 'Bolts';
GO

SELECT *
FROM Weapons
WHERE weapon_name = 'Crossbow';
GO

-- Injury Type

EXEC sp_AddInjuryType
    @injury_name = 'Concussion',
    @severity = 'Moderate';
GO

SELECT *
FROM Injury_Types
WHERE injury_name = 'Concussion';
GO

-- Mission Survivor

BEGIN TRY
    INSERT INTO Mission_Survivors (mission_id, survivor_id, role, is_primary)
    VALUES (1, 1, 'Backup', 0);
END TRY
BEGIN CATCH
    PRINT 'Trigger worked: duplicate mission assignment prevented.';
END CATCH;
GO