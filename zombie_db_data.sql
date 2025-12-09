USE ZombieDATEBASE;
GO

/*INSERT statements  */

/* Base – Jordin */
INSERT INTO Base (base_name, location_description, capacity, security_level, food_storage, water_storage)
VALUES
('Fort Hope', 'Reinforced school building on east ridge', 50, 'High', 200, 300),
('Redwood Outpost', 'Hidden cabin camp deep in the forest', 20, 'Medium', 120, 150),
('Downtown Bunker', 'Underground shelter beneath city hall', 35, 'High', 300, 500);
GO

/* Weapons – Arlo */
INSERT INTO Weapons (weapon_name, weapon_type, damage_rating, condition, ammo_type)
VALUES
('M4 Carbine', 'Rifle', 8, 'Good', '5.56mm'),
('Baseball Bat', 'Melee', 5, 'Worn', NULL),
('9mm Pistol', 'Handgun', 6, 'Good', '9mm'),
('Fire Axe', 'Melee', 7, 'Good', NULL);
GO

/* Vehicles – Muse */
INSERT INTO Vehicles (vehicle_name, vehicle_type, capacity, fuel_type, range_km, [condition], base_id)
VALUES
('Ranger Truck', 'Truck', 5, 'Diesel', 320, 'Worn', 1),
('Scout Bike', 'Bike', 1, 'Gas', 140, 'Good', 2),
('Armored Van', 'Armored', 8, 'Diesel', 250, 'Pristine', 3);
GO

/* Survivors – Arlo */
INSERT INTO Survivors 
(first_name, last_name, age, status, base_id, primary_weapon_id, primary_vehicle_id, notes)
VALUES
('Arlo', 'Smith', 29, 'Active', 1, 1, 1, 'Squad leader'),
('Jordin', 'Smith', 22, 'Active', 3, 3, 3, 'Medic and researcher'),
('Alex', 'Smith', 31, 'Active', 2, 2, 2, 'Supply scavenger'),
('Ashton', 'Smith', 27, 'Injured', 1, 4, NULL, 'Recently wounded on patrol');
GO

/* Allies – Ashton */
INSERT INTO Allies (ally_name, faction_type, trust_level, primary_base_id, notes)
VALUES
('Sierra Rangers', 'Militia', 'Medium', 1, 'Cooperate for shared patrols'),
('Harbor Collective', 'Civilians', 'High', 3, 'Trade supplies weekly'),
('Iron Wolves', 'Rogues', 'Low', 2, 'Unpredictable, sometimes hostile');
GO

/* Missions – Ashton */
INSERT INTO Missions 
(mission_name, mission_type, start_datetime, end_datetime, origin_base_id, [status], notes)
VALUES
('Recon North Ridge', 'Recon', '2025-12-05 09:00', '2025-12-05 14:00', 1, 'Completed', 'Light zombie activity'),
('Supply Run to Market District', 'Scavenge', '2025-12-07 11:00', NULL, 3, 'Ongoing', 'Heavy hostiles'),
('Rescue Civilians at River Bend', 'Rescue', '2025-12-06 15:00', NULL, 2, 'Planned', 'Awaiting intel');
GO

/* MissionSurvivors (link) -- Arlo */
INSERT INTO Mission_Survivors (mission_id, survivor_id, role, is_primary)
VALUES
(1, 1, 'Team Lead', 1),
(1, 2, 'Medic', 0),
(2, 3, 'Scout', 1),
(2, 1, 'Security', 0),
(3, 4, 'Rescue Lead', 1);
GO

/* InjuryTypes (link) – Arlo */
INSERT INTO Injury_Types (injury_name, severity)
VALUES
('Broken Arm', 'Moderate'),
('Zombie Bite', 'Critical'),
('Sprained Ankle', 'Minor'),
('Deep Laceration', 'Moderate');
GO

/* Injuries – Jordin */
INSERT INTO Injuries 
(survivor_id, injury_type, severity, injury_date, treated_by, notes, days_untreated)
VALUES
(4, 'Deep Laceration', 'Moderate', '2025-12-06', 'Jordin Chavez', 'Hit by debris during rescue attempt', 1),
(1, 'Sprained Ankle', 'Minor', '2025-12-03', 'Alex Rivera', 'Twisted during scout run', 0);
GO

/* Food – Alex */
INSERT INTO Food (food_name, category, calories_per_unit, shelf_life_days)
VALUES
('Canned Beans', 'Canned', 350, 900),
('Protein Bar', 'Snack', 220, 365),
('Dried Rice', 'Dry Goods', 600, 720);
GO

/* Water – Alex */
INSERT INTO Water (source_type, container_type, volume_liters, is_purified)
VALUES
('River', 'Jug', 10.5, 0),
('Filtered Well', 'Barrel', 50, 1),
('Rainwater', 'Bottle', 2.0, 1);
GO

/* Supplies – Muse */
INSERT INTO Supplies (supply_name, category, quantity, unit, base_id)
VALUES
('Bandages', 'Medical', 40, 'pcs', 1),
('Tool Kit', 'Tools', 3, 'box', 2),
('Thermal Jackets', 'Clothing', 10, 'pcs', 3),
('Rope', 'Misc', 5, 'kg', 1);
GO
