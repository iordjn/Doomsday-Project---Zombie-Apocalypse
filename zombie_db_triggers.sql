USE DoomsdayDB;
GO
/*=========================================================
  TRIGGERS (block invalid data on INSERT/UPDATE)
=========================================================*/

-- Missions – Ashton
-- Trigger: Validate missions before insert/update
IF OBJECT_ID('dbo.tr_Missions_Validate', 'TR') IS NOT NULL
    DROP TRIGGER dbo.tr_Missions_Validate;
GO

CREATE TRIGGER dbo.tr_Missions_Validate
ON dbo.Missions
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Mission name required
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE mission_name IS NULL OR LTRIM(RTRIM(mission_name)) = ''
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('Mission name is required.', 16, 1);
        RETURN;
    END

    -- Mission type required
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE mission_type IS NULL OR LTRIM(RTRIM(mission_type)) = ''
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('Mission type is required.', 16, 1);
        RETURN;
    END

    -- Valid status
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE [status] NOT IN ('Planned', 'In Progress', 'Completed', 'Failed')
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('Mission status must be Planned, In Progress, Completed, or Failed.', 16, 1);
        RETURN;
    END

    -- Date consistency
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE start_datetime IS NOT NULL
          AND end_datetime IS NOT NULL
          AND end_datetime < start_datetime
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('Mission end_datetime cannot be before start_datetime.', 16, 1);
        RETURN;
    END

    -- Origin base must exist (defensive; FK already enforces this)
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE NOT EXISTS (SELECT 1 FROM dbo.Base b WHERE b.base_id = i.origin_base_id)
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('Origin base does not exist.', 16, 1);
        RETURN;
    END
END;
GO

-- Allies – Ashton
-- Trigger: Validate allies before insert/update
IF OBJECT_ID('dbo.tr_Allies_Validate', 'TR') IS NOT NULL
    DROP TRIGGER dbo.tr_Allies_Validate;
GO

CREATE TRIGGER dbo.tr_Allies_Validate
ON dbo.Allies
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Ally name required
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE ally_name IS NULL OR LTRIM(RTRIM(ally_name)) = ''
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('Ally name is required.', 16, 1);
        RETURN;
    END

    -- Faction type required
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE faction_type IS NULL OR LTRIM(RTRIM(faction_type)) = ''
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('Faction type is required.', 16, 1);
        RETURN;
    END

    -- Trust level must be allowed
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE trust_level NOT IN ('Low', 'Medium', 'High')
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('Trust level must be Low, Medium, or High.', 16, 1);
        RETURN;
    END

    -- Primary base must exist if provided (defensive; FK already enforces this)
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.primary_base_id IS NOT NULL
          AND NOT EXISTS (SELECT 1 FROM dbo.Base b WHERE b.base_id = i.primary_base_id)
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('Primary base does not exist.', 16, 1);
        RETURN;
    END
END;
GO
