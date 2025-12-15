--  arlo_smith
USE DoomsdayDB;
GO

-- SELECT from the view
SELECT * FROM vw_SurvivorStatus;
GO

-- succeed: SELECT from the view
SELECT * FROM vw_SurvivorStatus;
GO

--  fail: SELECT directly from the table
SELECT * FROM Survivors;
GO
