-- 1. Stored Procedure: Mark vehicle as mission-ready
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

-- Test Vehicles Procedure
EXEC usp_RepairVehicle @vehicle_id = 2;


-- 2. Trigger: Log when vehicle breaks
CREATE TRIGGER trg_VehicleBreakAlert
ON Vehicles
AFTER UPDATE
AS
BEGIN
    IF UPDATE([condition]) 
    BEGIN
        IF EXISTS (SELECT * FROM inserted WHERE [condition] = 'Broken')
        BEGIN
            PRINT 'ALERT: A vehicle has broken down! Mission capability reduced.';
        END
    END
END;
GO

-- . Test Vehicles Trigger (break a vehicle)
UPDATE Vehicles SET [condition] = 'Broken' WHERE vehicle_id = 2;

-- 3.View: Show only medical supplies
CREATE VIEW vw_MedicalSupplies AS
SELECT supply_name, quantity, unit, base_id
FROM Supplies
WHERE category = 'Medical';
GO

-- 4.. Stored Procedure: Add supplies after scavenging
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

-- After finding 20 bandages at a hospital:
EXEC usp_AddSupplies @supply_id = 1, @amount_to_add = 20;

