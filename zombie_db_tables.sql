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




/* Allies – Ashton */




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




/* Water – Alex */




/* Injuries – Jordin */

CREATE TABLE Injuries (
    injury_id     INT          PRIMARY KEY,
    
    survivor_id   INT,
    
    injury_type   VARCHAR(80),
    
    severity      VARCHAR(20),

    injury_date   DATE,
    
    treated_by    VARCHAR(80),
    
    notes         VARCHAR(255)
);


/* Base – Jordin */

CREATE TABLE Base (
    base_id               INT          PRIMARY KEY,
    
    base_name             VARCHAR(80),
    
    location_description  VARCHAR(255),
    
    capacity              INT,
    
    security_level        VARCHAR(20)
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

