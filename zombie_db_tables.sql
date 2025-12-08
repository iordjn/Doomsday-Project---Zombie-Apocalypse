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




/* Supplies – Muse */


