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
