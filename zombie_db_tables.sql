/* Survivors – Arlo */

CREATE TABLE Survivors (
    survivor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    age INT,
    status VARCHAR(20) NOT NULL,
    base_id INT,
    primary_weapon_id INT,
    primary_vehicle_id INT,
    notes VARCHAR(255),

    FOREIGN KEY (primary_weapon_id) REFERENCES Weapons(weapon_id),
    FOREIGN KEY (primary_vehicle_id) REFERENCES Vehicles(vehicle_id)
);

/* MissionSurvivors (link) -- Arlo */

CREATE TABLE Mission_Survivors (
    mission_survivor_id INT PRIMARY KEY AUTO_INCREMENT,
    mission_id INT NOT NULL,
    survivor_id INT NOT NULL,
    role VARCHAR(40) NOT NULL,
    is_primary BIT NOT NULL DEFAULT 0,

    FOREIGN KEY (mission_id) REFERENCES Missions(mission_id),
    FOREIGN KEY (survivor_id) REFERENCES Survivors(survivor_id)
);

/* InjuryTypes (link) – Arlo */

CREATE TABLE Injury_Types (
    injury_type_id INT PRIMARY KEY AUTO_INCREMENT,
    injury_name VARCHAR(60) NOT NULL UNIQUE,
    severity VARCHAR(20) NOT NULL
);

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

ALTER TABLE Allies
ADD CONSTRAINT FK_Allies_PrimaryBase
    FOREIGN KEY (primary_base_id)
    REFERENCES Base(base_id);


/* Weapons – Arlo */

CREATE TABLE Weapons (
    weapon_id INT PRIMARY KEY AUTO_INCREMENT,
    weapon_name VARCHAR(80) NOT NULL,
    weapon_type VARCHAR(40) NOT NULL,
    damage_rating INT CHECK (damage_rating BETWEEN 1 AND 10),
    condition VARCHAR(20) NOT NULL,
    ammo_type VARCHAR(40)
);

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

CREATE TABLE Injuries (
    injury_id       INT IDENTITY(1,1) PRIMARY KEY,
    survivor_id     INT NOT NULL,
    injury_type     VARCHAR(80),       
    severity        VARCHAR(20),
    injury_date     DATE,
    treated_by      VARCHAR(80),
    notes           VARCHAR(255),
    days_untreated  INT DEFAULT 0,      

    CONSTRAINT FK_Injuries_Survivor FOREIGN KEY (survivor_id)
        REFERENCES Survivors(survivor_id)
);


/* Base – Jordin */

CREATE TABLE Base (
    base_id              INT PRIMARY KEY,
    base_name            VARCHAR(80),
    location_description VARCHAR(255),
    capacity             INT,
    security_level       VARCHAR(20),
    food_storage         INT DEFAULT 0,  
    water_storage        INT DEFAULT 0   
);


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

