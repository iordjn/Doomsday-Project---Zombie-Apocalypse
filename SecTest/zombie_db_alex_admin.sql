-- alex_admin
USE DoomsdayDB;
GO

--  add a survivor
EXEC sp_AddSurvivor 'tike', 'jon', 'Healthy';
GO


--  fail: SELECT from table directly 
SELECT * FROM Survivors;
GO

