------------------------------------------------------------
-- Allies
------------------------------------------------------------
CREATE TABLE Allies (
    ally_id         INT IDENTITY(1,1) NOT NULL,
    ally_name       VARCHAR(80)       NOT NULL,
    faction_type    VARCHAR(40)       NOT NULL, -- Trader/Militia/Civilian/Unknown
    trust_level     VARCHAR(20)       NOT NULL, -- Low/Medium/High
    primary_base_id INT               NULL,     -- FK to Base (optional home base)
    notes           VARCHAR(255)      NULL,
    CONSTRAINT PK_Allies PRIMARY KEY (ally_id)
);
GO

ALTER TABLE Allies
ADD CONSTRAINT FK_Allies_PrimaryBase
    FOREIGN KEY (primary_base_id)
    REFERENCES Base(base_id);
GO

------------------------------------------------------------
-- Missions
------------------------------------------------------------
CREATE TABLE Missions (
    mission_id      INT IDENTITY(1,1) NOT NULL,
    mission_name    VARCHAR(100)      NOT NULL,
    mission_type    VARCHAR(40)       NOT NULL, -- Scavenge/Escort/Defense/Recon/Other
    start_datetime  DATETIME          NULL,
    end_datetime    DATETIME          NULL,
    origin_base_id  INT               NOT NULL, -- FK to Base
    [status]        VARCHAR(20)       NOT NULL, -- Planned/In Progress/Completed/Failed
    notes           VARCHAR(255)      NULL,
    CONSTRAINT PK_Missions PRIMARY KEY (mission_id),
    CONSTRAINT FK_Missions_OriginBase
        FOREIGN KEY (origin_base_id)
        REFERENCES Base(base_id)
);
GO
