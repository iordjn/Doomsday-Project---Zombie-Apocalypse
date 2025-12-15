/*==================================================================
  SYSTEM OPERATOR (SERVER-LEVEL ADMIN)
==================================================================*/

USE master;
GO

-- Drop login if it exists
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'sys_operator')
BEGIN
    DROP LOGIN sys_operator;
END
GO

-- Create login
CREATE LOGIN sys_operator
WITH PASSWORD = 'SysOp#2025',
CHECK_POLICY = OFF;
GO

-- Add to sysadmin role
ALTER SERVER ROLE sysadmin ADD MEMBER sys_operator;
GO


/*==================================================================
  BASE USER – VIEW ONLY (READ-ONLY REPORTING)
==================================================================*/

USE DoomsdayDB;
GO

-- Drop view if it exists
IF OBJECT_ID('dbo.vw_SurvivorStatus', 'V') IS NOT NULL
BEGIN
    DROP VIEW dbo.vw_SurvivorStatus;
END
GO

-- Create reporting view
CREATE VIEW dbo.vw_SurvivorStatus
AS
SELECT first_name, last_name, status, base_id
FROM Survivors;
GO

USE master;
GO

-- Drop login if it exists
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'arlo_smith')
BEGIN
    DROP LOGIN arlo_smith;
END
GO

-- Create login
CREATE LOGIN arlo_smith
WITH PASSWORD = 'Arlo#2025',
CHECK_POLICY = OFF;
GO

USE DoomsdayDB;
GO

-- Drop user if it exists
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'arlo_smith')
BEGIN
    DROP USER arlo_smith;
END
GO

-- Create database user
CREATE USER arlo_smith FOR LOGIN arlo_smith;
GO

-- Grant SELECT on view only
GRANT SELECT ON dbo.vw_SurvivorStatus TO arlo_smith;
GO


/*==================================================================
  STORED PROCEDURE ONLY USER
==================================================================*/

-- Drop stored procedure if it exists
IF OBJECT_ID('dbo.sp_ReportSurvivorCount', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.sp_ReportSurvivorCount;
END
GO

-- Create stored procedure
CREATE PROCEDURE dbo.sp_ReportSurvivorCount
AS
BEGIN
    SELECT COUNT(*) AS TotalSurvivors
    FROM Survivors;
END
GO

USE master;
GO

-- Drop login if it exists
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'maya_ops')
BEGIN
    DROP LOGIN maya_ops;
END
GO

-- Create login
CREATE LOGIN maya_ops
WITH PASSWORD = 'Maya#2025',
CHECK_POLICY = OFF;
GO

USE DoomsdayDB;
GO

-- Drop user if it exists
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'maya_ops')
BEGIN
    DROP USER maya_ops;
END
GO

-- Create database user
CREATE USER maya_ops FOR LOGIN maya_ops;
GO

-- Grant EXECUTE only
GRANT EXECUTE ON dbo.sp_ReportSurvivorCount TO maya_ops;
GO


/*==================================================================
  SURVIVOR MANAGER (CRUD WITH STORED PROCEDURES ONLY)
==================================================================*/

-- Drop procedures if they exist
IF OBJECT_ID('dbo.sp_AddSurvivor', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_AddSurvivor;
GO

IF OBJECT_ID('dbo.sp_UpdateSurvivorStatus', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_UpdateSurvivorStatus;
GO

IF OBJECT_ID('dbo.sp_RemoveSurvivor', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_RemoveSurvivor;
GO

-- Add survivor
CREATE PROCEDURE dbo.sp_AddSurvivor
    @first  VARCHAR(50),
    @last   VARCHAR(50),
    @status VARCHAR(20)
AS
BEGIN
    INSERT INTO Survivors (first_name, last_name, status)
    VALUES (@first, @last, @status);
END
GO

-- Update survivor
CREATE PROCEDURE dbo.sp_UpdateSurvivorStatus
    @id     INT,
    @status VARCHAR(20)
AS
BEGIN
    UPDATE Survivors
    SET status = @status
    WHERE survivor_id = @id;
END
GO

-- Remove survivor
CREATE PROCEDURE dbo.sp_RemoveSurvivor
    @id INT
AS
BEGIN
    DELETE FROM Survivors
    WHERE survivor_id = @id;
END
GO

USE master;
GO

-- Drop login if it exists
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'alex_admin')
BEGIN
    DROP LOGIN alex_admin;
END
GO

-- Create login
CREATE LOGIN alex_admin
WITH PASSWORD = 'Alex#2025',
CHECK_POLICY = OFF;
GO

USE DoomsdayDB;
GO

-- Drop user if it exists
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'alex_admin')
BEGIN
    DROP USER alex_admin;
END
GO

-- Create database user
CREATE USER alex_admin FOR LOGIN alex_admin;
GO

-- Grant controlled EXECUTE access
GRANT EXECUTE ON dbo.sp_AddSurvivor           TO alex_admin;
GRANT EXECUTE ON dbo.sp_UpdateSurvivorStatus  TO alex_admin;
GRANT EXECUTE ON dbo.sp_RemoveSurvivor        TO alex_admin;
GO
