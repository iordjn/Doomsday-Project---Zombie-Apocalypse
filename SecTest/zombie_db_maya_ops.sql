--  maya_ops
USE DoomsdayDB;
GO

--  execute the procedure
EXEC sp_ReportSurvivorCount;
GO

-- fail: SELECT from table
SELECT * FROM Survivors;
GO

--  fail: SELECT from view
SELECT * FROM vw_SurvivorStatus;
GO
