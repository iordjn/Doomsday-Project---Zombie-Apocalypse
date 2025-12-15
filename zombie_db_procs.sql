-- Injury Type
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

-- Weapon
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

-- Missions – Ashton
-- Insert mission with validation
IF OBJECT_ID('dbo.usp_InsertMission_Validated', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_InsertMission_Validated;
GO

CREATE PROCEDURE dbo.usp_InsertMission_Validated
    @mission_name   VARCHAR(100),
    @mission_type   VARCHAR(40),
    @start_datetime DATETIME = NULL,
    @end_datetime   DATETIME = NULL,
    @origin_base_id INT,
    @status         VARCHAR(20),
    @notes          VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    -- Required text fields
    IF @mission_name IS NULL OR LTRIM(RTRIM(@mission_name)) = ''
    BEGIN
        RAISERROR('Mission name is required.', 16, 1);
        RETURN;
    END
    IF @mission_type IS NULL OR LTRIM(RTRIM(@mission_type)) = ''
    BEGIN
        RAISERROR('Mission type is required.', 16, 1);
        RETURN;
    END
    -- Validate base exists
    IF NOT EXISTS (SELECT 1 FROM dbo.Base WHERE base_id = @origin_base_id)
    BEGIN
        RAISERROR('Origin base does not exist.', 16, 1);
        RETURN;
    END
    -- Validate status allowed values (no lookup tables)
    IF @status NOT IN ('Planned', 'In Progress', 'Completed', 'Failed')
    BEGIN
        RAISERROR('Mission status must be Planned, In Progress, Completed, or Failed.', 16, 1);
        RETURN;
    END
    -- Validate dates
    IF @start_datetime IS NOT NULL AND @end_datetime IS NOT NULL
       AND @end_datetime < @start_datetime
    BEGIN
        RAISERROR('End date/time cannot be before start date/time.', 16, 1);
        RETURN;
    END
    INSERT INTO dbo.Missions
        (mission_name, mission_type, start_datetime, end_datetime, origin_base_id, [status], notes)
    VALUES
        (@mission_name, @mission_type, @start_datetime, @end_datetime, @origin_base_id, @status, @notes);
END;
GO
  
-- Allies – Ashton
-- Insert ally with validation
IF OBJECT_ID('dbo.usp_InsertAlly_Validated', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_InsertAlly_Validated;
GO

CREATE PROCEDURE dbo.usp_InsertAlly_Validated
    @ally_name       VARCHAR(80),
    @faction_type    VARCHAR(40),
    @trust_level     VARCHAR(20),
    @primary_base_id INT = NULL,
    @notes           VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @ally_name IS NULL OR LTRIM(RTRIM(@ally_name)) = ''
    BEGIN
        RAISERROR('Ally name is required.', 16, 1);
        RETURN;
    END
    IF @faction_type IS NULL OR LTRIM(RTRIM(@faction_type)) = ''
    BEGIN
        RAISERROR('Faction type is required.', 16, 1);
        RETURN;
    END
    IF @trust_level NOT IN ('Low', 'Medium', 'High')
    BEGIN
        RAISERROR('Trust level must be Low, Medium, or High.', 16, 1);
        RETURN;
    END
    IF @primary_base_id IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM dbo.Base WHERE base_id = @primary_base_id)
    BEGIN
        RAISERROR('Primary base does not exist.', 16, 1);
        RETURN;
    END
    INSERT INTO dbo.Allies (ally_name, faction_type, trust_level, primary_base_id, notes)
    VALUES (@ally_name, @faction_type, @trust_level, @primary_base_id, @notes);
END;
GO


-- ============================================
-- STORED PROCEDURE 1: Repair Vehicle
-- ============================================
CREATE PROCEDURE usp_RepairVehicle
    @vehicle_id INT
AS
BEGIN
    UPDATE Vehicles
    SET [condition] = 'Pristine'
    WHERE vehicle_id = @vehicle_id 
      AND [condition] IN ('Worn', 'Broken'); 
    
    IF @@ROWCOUNT > 0
        SELECT 'Vehicle repaired to Pristine condition' AS result;
    ELSE
        SELECT 'Vehicle does not need repair (already Good or Pristine)' AS result;
END;
GO

-- TEST: Repair a vehicle
EXEC usp_RepairVehicle @vehicle_id = 2;
GO

-- ============================================
-- STORED PROCEDURE 2: Add Supplies
-- ============================================
CREATE PROCEDURE usp_AddSupplies
    @supply_id INT,
    @amount_to_add INT
AS
BEGIN
    UPDATE Supplies
    SET quantity = quantity + @amount_to_add
    WHERE supply_id = @supply_id;
    
    SELECT 'Supplies added successfully' AS message;
END;
GO

-- TEST: Add 15 bandages after hospital scavenging
EXEC usp_AddSupplies @supply_id = 1, @amount_to_add = 15;
GO


