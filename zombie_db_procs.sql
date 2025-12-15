USE DoomsdayDB;
GO

/*=========================================================
  STORED PROCEDURES (validated inserts)
=========================================================*/
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

-- Alexander Food
-- Food table
GO
CREATE PROCEDURE sp_UpdateFood
	@food_id INT,
	@food_name VARCHAR (80),
	@category VARCHAR (40),
	@calories_per_unit INT,
	@shelf_life_days INT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE Food
	SET food_name = @food_name,
		category =@category,
		calories_per_unit = @calories_per_unit,
		shelf_life_days = @shelf_life_days
	WHERE food_id = @food_id;
END;