/* Survivors – Arlo */




/* MissionSurvivors (link) -- Arlo */




/* SurvivorsInjuries (link) – Arlo */





/* Missions – Ashton */




/* Allies – Ashton */




/* Weapons – Arlo */




/* Food – Alex */




/* Water – Alex */




/* Injuries – Jordin */




/* Base – Jordin */




/* Vehicles – Muse */
CREATE TABLE Vehicles (
    vehicle_id    INT IDENTITY(1,1) NOT NULL,
    vehicle_name  VARCHAR(80)       NOT NULL,
    vehicle_type  VARCHAR(40)       NOT NULL, -- Car, Truck, Bike, Armored, Other
    capacity      INT               NOT NULL,
    fuel_type     VARCHAR(20)       NOT NULL, -- Gas, Diesel, Electric, Other
    range_km      INT               NULL,     -- Estimated max range (km)
    [condition]   VARCHAR(20)       NOT NULL, -- Pristine, Worn, Broken
    base_id       INT               NOT NULL, -- FK to Base
    CONSTRAINT PK_Vehicles PRIMARY KEY (vehicle_id),
    CONSTRAINT FK_Vehicles_Base
        FOREIGN KEY (base_id)
        REFERENCES Base(base_id)
);
GO

/* Supplies – Muse */
CREATE TABLE Supplies (
    supply_id   INT IDENTITY(1,1) NOT NULL,
    supply_name VARCHAR(80)       NOT NULL,
    category    VARCHAR(40)       NOT NULL, -- Medical, Tools, Clothing, Misc
    quantity    INT               NOT NULL,
    unit        VARCHAR(20)       NOT NULL, -- pcs, box, kg, L
    base_id     INT               NOT NULL, -- FK to Base
    CONSTRAINT PK_Supplies PRIMARY KEY (supply_id),
    CONSTRAINT FK_Supplies_Base
        FOREIGN KEY (base_id)
        REFERENCES Base(base_id)
);
GO


