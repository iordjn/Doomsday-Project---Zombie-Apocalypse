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




/* Base – Jordin */




/* Vehicles – Muse */




/* Supplies – Muse */


