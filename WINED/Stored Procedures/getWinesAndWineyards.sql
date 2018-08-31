CREATE PROCEDURE [dbo].[getWinesAndWineyards]
	@geography GEOGRAPHY,
	@distance int
AS

SELECT
	w.Name as WineName,
	w.Year as WineYear,
	r.Rating as WineRating,
	wy.Name as WineYardName,
	wy.Antiquity as WineyardAntiquity, Geography
-- Mariage
-- Attributes
FROM
	Wine w
	INNER JOIN Wineyard wy ON w.FK_Wine_Wineyard_Id = wy.Id
	INNER JOIN WineyardAddress wa ON wy.Id = wa.FK_WineyardAddress_Wineyard_Id
	INNER JOIN Address a ON a.Id = wa.FK_WineyardAddress_Address_Id
	INNER JOIN Review r ON r.FK_Review_Wine_Id = w.Id
WHERE Geography.STDistance(@geography) < @distance

-- TODO Get food recommendations and attributes

RETURN 0
