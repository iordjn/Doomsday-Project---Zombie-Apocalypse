/*-----------------------------------------------------------------
   SYSTEM OPERATOR (SERVER-LEVEL ADMIN)
  */

USE master;
GO

CREATE LOGIN sys_operator
WITH PASSWORD = 'SysOp#2025',
CHECK_POLICY = OFF;
GO

ALTER SERVER ROLE sysadmin ADD MEMBER sys_operator;
GO



/* -----------------------------------------------------------------
   BASE USER – VIEW ONLY (READ-ONLY REPORTING)
 */

USE DoomsdayDB;
GO
/* Create reporting view */
CREATE VIEW vw_SurvivorStatus
AS
SELECT first_name, last_name, status, base_id
FROM Survivors;
GO

/* Create login */
CREATE LOGIN arlo_smith
WITH PASSWORD = 'Arlo#2025',
CHECK_POLICY = OFF;
GO

/* Create database user */
CREATE USER arlo_smith FOR LOGIN arlo_smith;
GO

/* Grant SELECT on VIEW ONLY */
GRANT SELECT ON vw_SurvivorStatus TO arlo_smith;
GO



/* -----------------------------------------------------------------
   STORED PROCEDURE ONLY USER
   */

/* Create stored procedure */
CREATE PROCEDURE sp_ReportSurvivorCount
AS
SELECT COUNT(*) AS TotalSurvivors
FROM Survivors;
GO

/* Create login */
CREATE LOGIN maya_ops
WITH PASSWORD = 'Maya#2025',
CHECK_POLICY = OFF;
GO

/* Create database user */
CREATE USER maya_ops FOR LOGIN maya_ops;
GO

/* Grant EXECUTE ONLY */
GRANT EXECUTE ON sp_ReportSurvivorCount TO maya_ops;
GO




/*------------------------------------------------------------------
   SURVIVOR MANAGER (CRUD wtihPROCEDURES ONLY)
 */

/* Add survivor */
CREATE PROCEDURE sp_AddSurvivor
    @first VARCHAR(50),
    @last VARCHAR(50),
    @status VARCHAR(20)
AS
INSERT INTO Survivors (first_name, last_name, status)
VALUES (@first, @last, @status);
GO

/* Update survivor */
CREATE PROCEDURE sp_UpdateSurvivorStatus
    @id INT,
    @status VARCHAR(20)
AS
UPDATE Survivors
SET status = @status
WHERE survivor_id = @id;
GO

/* Remove survivor */
CREATE PROCEDURE sp_RemoveSurvivor
    @id INT
AS
DELETE FROM Survivors
WHERE survivor_id = @id;
GO

/* Create login */
CREATE LOGIN alex_admin
WITH PASSWORD = 'Alex#2025',
CHECK_POLICY = OFF;
GO

/* Create database user */
CREATE USER alex_admin FOR LOGIN alex_admin;
GO

/* Grant controlled EXECUTE access */
GRANT EXECUTE ON sp_AddSurvivor TO alex_admin;
GRANT EXECUTE ON sp_UpdateSurvivorStatus TO alex_admin;
GRANT EXECUTE ON sp_RemoveSurvivor TO alex_admin;
GO
