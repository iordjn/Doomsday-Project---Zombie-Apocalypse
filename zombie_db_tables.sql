/* Survivors – Arlo */




/* MissionSurvivors (link) -- Arlo */




/* SurvivorsInjuries (link) – Arlo */





/* Missions – Ashton */




/* Allies – Ashton */




/* Weapons – Arlo */




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




/* Supplies – Muse */


