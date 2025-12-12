/* Base – Jordin */
CREATE TABLE Base (
    base_id              INT IDENTITY(1,1) PRIMARY KEY,
    base_name            VARCHAR(80)       NOT NULL,
    location_description VARCHAR(255)      NULL,
    capacity             INT               NULL,
    security_level       VARCHAR(20)       NULL,
    food_storage         INT               NOT NULL DEFAULT 0,
    water_storage        INT               NOT NULL DEFAULT 0
);
GO


/* Weapons – Arlo */
CREATE TABLE Weapons (
    weapon_id     INT IDENTITY(1,1) PRIMARY KEY,
    weapon_name   VARCHAR(80)  NOT NULL,
    weapon_type   VARCHAR(40)  NOT NULL,
    damage_rating INT          NOT NULL CHECK (damage_rating BETWEEN 1 AND 10),
    [condition]   VARCHAR(20)  NOT NULL,
    ammo_type     VARCHAR(40)  NULL
);
GO


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


/* Survivors – Arlo */
CREATE TABLE Survivors (
    survivor_id        INT IDENTITY(1,1) PRIMARY KEY,
    first_name         VARCHAR(50) NOT NULL,
    last_name          VARCHAR(50) NOT NULL,
    age                INT         NULL,
    [status]           VARCHAR(20) NOT NULL,
    base_id            INT         NULL,
    primary_weapon_id  INT         NULL,
    primary_vehicle_id INT         NULL,
    notes              VARCHAR(255) NULL,

    CONSTRAINT FK_Survivors_Base
        FOREIGN KEY (base_id) REFERENCES Base(base_id),

    CONSTRAINT FK_Survivors_PrimaryWeapon
        FOREIGN KEY (primary_weapon_id) REFERENCES Weapons(weapon_id),

    CONSTRAINT FK_Survivors_PrimaryVehicle
        FOREIGN KEY (primary_vehicle_id) REFERENCES Vehicles(vehicle_id)
);
GO


/* Missions – Ashton */
CREATE TABLE Missions (
    mission_id      INT IDENTITY(1,1) NOT NULL,
    mission_name    VARCHAR(100)      NOT NULL,
    mission_type    VARCHAR(40)       NOT NULL,
    start_datetime  DATETIME          NULL,
    end_datetime    DATETIME          NULL,
    origin_base_id  INT               NOT NULL,
    [status]        VARCHAR(20)       NOT NULL,
    notes           VARCHAR(255)      NULL,
    CONSTRAINT PK_Missions PRIMARY KEY (mission_id),
    CONSTRAINT FK_Missions_OriginBase
        FOREIGN KEY (origin_base_id)
        REFERENCES Base(base_id)
);
GO


/* MissionSurvivors (link) -- Arlo */
CREATE TABLE Mission_Survivors (
    mission_survivor_id INT IDENTITY(1,1) PRIMARY KEY,
    mission_id          INT        NOT NULL,
    survivor_id         INT        NOT NULL,
    role                VARCHAR(40) NOT NULL,
    is_primary          BIT         NOT NULL DEFAULT 0,

    CONSTRAINT FK_MissionSurvivors_Mission
        FOREIGN KEY (mission_id) REFERENCES Missions(mission_id),

    CONSTRAINT FK_MissionSurvivors_Survivor
        FOREIGN KEY (survivor_id) REFERENCES Survivors(survivor_id)
);
GO


/* InjuryTypes – Arlo */
CREATE TABLE Injury_Types (
    injury_type_id INT IDENTITY(1,1) PRIMARY KEY,
    injury_name    VARCHAR(60) NOT NULL UNIQUE,
    severity       VARCHAR(20) NOT NULL
);
GO


/* Injuries – Jordin 
   (If you want this tied to Injury_Types, you could add an FK later) */
CREATE TABLE Injuries (
    injury_id       INT IDENTITY(1,1) PRIMARY KEY,
    survivor_id     INT         NOT NULL,
    injury_type     VARCHAR(80) NULL,   -- could be FK to Injury_Types if desired
    severity        VARCHAR(20) NULL,
    injury_date     DATE        NULL,
    treated_by      VARCHAR(80) NULL,
    notes           VARCHAR(255) NULL,
    days_untreated  INT         NOT NULL DEFAULT 0,

    CONSTRAINT FK_Injuries_Survivor
        FOREIGN KEY (survivor_id) REFERENCES Survivors(survivor_id)
);
GO


/* Allies – Ashton */
CREATE TABLE Allies (
    ally_id         INT IDENTITY(1,1) NOT NULL,
    ally_name       VARCHAR(80)       NOT NULL,
    faction_type    VARCHAR(40)       NOT NULL,
    trust_level     VARCHAR(20)       NOT NULL,
    primary_base_id INT               NULL,
    notes           VARCHAR(255)      NULL,
    CONSTRAINT PK_Allies PRIMARY KEY (ally_id)
);
GO

ALTER TABLE Allies
ADD CONSTRAINT FK_Allies_PrimaryBase
    FOREIGN KEY (primary_base_id)
    REFERENCES Base(base_id);
GO


/* Food – Alex */
CREATE TABLE Food (
    food_id           INT IDENTITY(1,1) NOT NULL,
    food_name         VARCHAR(80)  NOT NULL,
    category          VARCHAR(40)  NULL,
    calories_per_unit INT          NULL,
    shelf_life_days   INT          NULL,
    CONSTRAINT PK_Food PRIMARY KEY (food_id)
);
GO


/* Water – Alex */
CREATE TABLE Water (
    water_id        INT IDENTITY(1,1) NOT NULL,
    source_type     VARCHAR(40)  NOT NULL,
    container_type  VARCHAR(40)  NULL,
    volume_liters   DECIMAL(10,2) NULL,
    is_purified     BIT          NULL,
    CONSTRAINT PK_Water PRIMARY KEY (water_id)
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
