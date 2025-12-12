/*=========================================================
    CREATE DATABASE
=========================================================*/
IF DB_ID('DoomsdayDB') IS NOT NULL
BEGIN
    ALTER DATABASE DoomsdayDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DoomsdayDB;
END;
GO

CREATE DATABASE DoomsdayDB;
GO

USE DoomsdayDB;
GO

/*=========================================================
    DROP TABLES IN CORRECT ORDER (child → parent)
=========================================================*/

IF OBJECT_ID('dbo.Supplies', 'U') IS NOT NULL DROP TABLE dbo.Supplies;
IF OBJECT_ID('dbo.Injuries', 'U') IS NOT NULL DROP TABLE dbo.Injuries;
IF OBJECT_ID('dbo.Mission_Survivors', 'U') IS NOT NULL DROP TABLE dbo.Mission_Survivors;
IF OBJECT_ID('dbo.Survivors', 'U') IS NOT NULL DROP TABLE dbo.Survivors;
IF OBJECT_ID('dbo.Vehicles', 'U') IS NOT NULL DROP TABLE dbo.Vehicles;
IF OBJECT_ID('dbo.Weapons', 'U') IS NOT NULL DROP TABLE dbo.Weapons;
IF OBJECT_ID('dbo.Water', 'U') IS NOT NULL DROP TABLE dbo.Water;
IF OBJECT_ID('dbo.Food', 'U') IS NOT NULL DROP TABLE dbo.Food;
IF OBJECT_ID('dbo.Injury_Types', 'U') IS NOT NULL DROP TABLE dbo.Injury_Types;
IF OBJECT_ID('dbo.Allies', 'U') IS NOT NULL DROP TABLE dbo.Allies;
IF OBJECT_ID('dbo.Missions', 'U') IS NOT NULL DROP TABLE dbo.Missions;
IF OBJECT_ID('dbo.Base', 'U') IS NOT NULL DROP TABLE dbo.Base;
GO


/*=========================================================
    BASE TABLE
=========================================================*/
CREATE TABLE Base (
    base_id              INT IDENTITY(1,1) PRIMARY KEY,
    base_name            VARCHAR(80)       NOT NULL,
    location_description VARCHAR(255)      NULL,
    capacity             INT               NULL,
    security_level       VARCHAR(20)       NULL,
    food_storage         INT DEFAULT 0,
    water_storage        INT DEFAULT 0
);
GO


/*=========================================================
    WEAPONS TABLE
=========================================================*/
CREATE TABLE Weapons (
    weapon_id     INT IDENTITY(1,1) PRIMARY KEY,
    weapon_name   VARCHAR(80)  NOT NULL,
    weapon_type   VARCHAR(40)  NOT NULL,
    damage_rating INT          NOT NULL CHECK (damage_rating BETWEEN 1 AND 10),
    [condition]   VARCHAR(20)  NOT NULL,
    ammo_type     VARCHAR(40)  NULL
);
GO


/*=========================================================
    VEHICLES TABLE
=========================================================*/
CREATE TABLE Vehicles (
    vehicle_id    INT IDENTITY(1,1) PRIMARY KEY,
    vehicle_name  VARCHAR(80) NOT NULL,
    vehicle_type  VARCHAR(40) NOT NULL,
    capacity      INT NOT NULL,
    fuel_type     VARCHAR(20) NOT NULL,
    range_km      INT NULL,
    [condition]   VARCHAR(20) NOT NULL,
    base_id       INT NOT NULL,
    CONSTRAINT FK_Vehicles_Base FOREIGN KEY (base_id)
        REFERENCES Base(base_id)
);
GO


/*=========================================================
    SURVIVORS TABLE
=========================================================*/
CREATE TABLE Survivors (
    survivor_id        INT IDENTITY(1,1) PRIMARY KEY,
    first_name         VARCHAR(50) NOT NULL,
    last_name          VARCHAR(50) NOT NULL,
    age                INT NULL,
    [status]           VARCHAR(20) NOT NULL,
    base_id            INT NULL,
    primary_weapon_id  INT NULL,
    primary_vehicle_id INT NULL,
    notes              VARCHAR(255) NULL,

    CONSTRAINT FK_Survivors_Base
        FOREIGN KEY (base_id) REFERENCES Base(base_id),

    CONSTRAINT FK_Survivors_Weapon
        FOREIGN KEY (primary_weapon_id) REFERENCES Weapons(weapon_id),

    CONSTRAINT FK_Survivors_Vehicle
        FOREIGN KEY (primary_vehicle_id) REFERENCES Vehicles(vehicle_id)
);
GO


/*=========================================================
    MISSIONS TABLE
=========================================================*/
CREATE TABLE Missions (
    mission_id      INT IDENTITY(1,1) PRIMARY KEY,
    mission_name    VARCHAR(100) NOT NULL,
    mission_type    VARCHAR(40)  NOT NULL,
    start_datetime  DATETIME NULL,
    end_datetime    DATETIME NULL,
    origin_base_id  INT NOT NULL,
    [status]        VARCHAR(20) NOT NULL,
    notes           VARCHAR(255) NULL,

    CONSTRAINT FK_Missions_OriginBase
        FOREIGN KEY (origin_base_id) REFERENCES Base(base_id)
);
GO


/*=========================================================
    MISSION-SURVIVOR LINK TABLE
=========================================================*/
CREATE TABLE Mission_Survivors (
    mission_survivor_id INT IDENTITY(1,1) PRIMARY KEY,
    mission_id          INT NOT NULL,
    survivor_id         INT NOT NULL,
    role                VARCHAR(40) NOT NULL,
    is_primary          BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_MissionSurvivors_Mission
        FOREIGN KEY (mission_id) REFERENCES Missions(mission_id),

    CONSTRAINT FK_MissionSurvivors_Survivor
        FOREIGN KEY (survivor_id) REFERENCES Survivors(survivor_id)
);
GO


/*=========================================================
    INJURY TYPE TABLE
=========================================================*/
CREATE TABLE Injury_Types (
    injury_type_id INT IDENTITY(1,1) PRIMARY KEY,
    injury_name    VARCHAR(60) NOT NULL UNIQUE,
    severity       VARCHAR(20) NOT NULL
);
GO


/*=========================================================
    INJURIES TABLE
=========================================================*/
CREATE TABLE Injuries (
    injury_id       INT IDENTITY(1,1) PRIMARY KEY,
    survivor_id     INT NOT NULL,
    injury_type     VARCHAR(80),
    severity        VARCHAR(20),
    injury_date     DATE,
    treated_by      VARCHAR(80),
    notes           VARCHAR(255),
    days_untreated  INT DEFAULT 0,

    CONSTRAINT FK_Injuries_Survivor
        FOREIGN KEY (survivor_id) REFERENCES Survivors(survivor_id)
);
GO


/*=========================================================
    ALLIES TABLE
=========================================================*/
CREATE TABLE Allies (
    ally_id         INT IDENTITY(1,1) PRIMARY KEY,
    ally_name       VARCHAR(80) NOT NULL,
    faction_type    VARCHAR(40) NOT NULL,
    trust_level     VARCHAR(20) NOT NULL,
    primary_base_id INT NULL,
    notes           VARCHAR(255) NULL
);
GO

ALTER TABLE Allies
ADD CONSTRAINT FK_Allies_PrimaryBase
    FOREIGN KEY (primary_base_id) REFERENCES Base(base_id);
GO


/*=========================================================
    FOOD TABLE
=========================================================*/
CREATE TABLE Food (
    food_id           INT IDENTITY(1,1) PRIMARY KEY,
    food_name         VARCHAR(80) NOT NULL,
    category          VARCHAR(40),
    calories_per_unit INT,
    shelf_life_days   INT
);
GO


/*=========================================================
    WATER TABLE
=========================================================*/
CREATE TABLE Water (
    water_id        INT IDENTITY(1,1) PRIMARY KEY,
    source_type     VARCHAR(40) NOT NULL,
    container_type  VARCHAR(40),
    volume_liters   DECIMAL(10,2),
    is_purified     BIT
);
GO


/*=========================================================
    SUPPLIES TABLE
=========================================================*/
CREATE TABLE Supplies (
    supply_id   INT IDENTITY(1,1) PRIMARY KEY,
    supply_name VARCHAR(80) NOT NULL,
    category    VARCHAR(40) NOT NULL,
    quantity    INT NOT NULL,
    unit        VARCHAR(20) NOT NULL,
    base_id     INT NOT NULL,

    CONSTRAINT FK_Supplies_Base
        FOREIGN KEY (base_id) REFERENCES Base(base_id)
);
GO
