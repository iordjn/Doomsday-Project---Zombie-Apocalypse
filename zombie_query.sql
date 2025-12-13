/* Alex query */
/* for the water table */
SELECT SUM(volume_liters) AS total_volume
FROM Water
GROUP BY source_type;

/* for the food table */
GO
CREATE PROCEDURE sp_UpdateFood
	@food_id INT,
	@food_name VARCHAR (80),
	@category VARCHAR (40),
	@calories_per_unit INT,
	@shelf_life_days INT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE Food
	SET food_name = @food_name,
		category =@category,
		calories_per_unit = @calories_per_unit,
		shelf_life_days = @shelf_life_days
	WHERE food_id = @food_id;
END;