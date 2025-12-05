/* Alexander tables */
Create Table Food
(
  food_id   INT      NOT NULL,
  food_name VARCHAR(80)  NOT NULL,
  category       VARCHAR(40),
  calories_per_unit     INT,
  shelf_life_days      INT,
  CONSTRAINT pk_Food PRIMARY KEY (food_id)
  );
Create Table Water
(
  water_id   INT      NOT NULL,
  source_type VARCHAR(40)  NOT NULL,
  container_type      VARCHAR(40),
  volume_liters     DECIMAL(10,2),
  is_purified      BIT,
  CONSTRAINT pk_Water PRIMARY KEY (water_id)
  );
