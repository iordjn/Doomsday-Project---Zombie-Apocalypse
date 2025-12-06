/* Survivors – Arlo */




/* MissionSurvivors (link) -- Arlo */




/* SurvivorsInjuries (link) – Arlo */




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



/* Weapons – Arlo */




/* Food – Alex */
Create Table Food
(
  food_id   INT      NOT NULL,
  food_name VARCHAR(80)  NOT NULL,
  category       VARCHAR(40),
  calories_per_unit     INT,
  shelf_life_days      INT,
  CONSTRAINT pk_Food PRIMARY KEY (food_id)
  );



/* Water – Alex */
Create Table Water
(
  water_id   INT      NOT NULL,
  source_type VARCHAR(40)  NOT NULL,
  container_type      VARCHAR(40),
  volume_liters     DECIMAL(10,2),
  is_purified      BIT,
  CONSTRAINT pk_Water PRIMARY KEY (water_id)
  );



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

