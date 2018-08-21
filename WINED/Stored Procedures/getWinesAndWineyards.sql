CREATE PROCEDURE [dbo].[getWinesAndWineyards]
	@geography GEOGRAPHY
AS

SELECT Name, Geography
FROM
	Wineyard w
	JOIN WineyardAddress wa ON w.Id = wa.FK_WineyardAddress_Wineyard_Id
	JOIN Address a ON a.Id = wa.FK_WineyardAddress_Address_Id

RETURN 0
