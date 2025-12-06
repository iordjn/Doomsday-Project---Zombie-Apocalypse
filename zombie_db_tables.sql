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




/* Water – Alex */




/* Injuries – Jordin */




/* Base – Jordin */




/* Vehicles – Muse */




/* Supplies – Muse */


