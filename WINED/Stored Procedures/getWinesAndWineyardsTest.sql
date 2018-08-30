USE [WINED]
GO

DECLARE	@return_value int
DECLARE @originPoint GEOGRAPHY = GEOGRAPHY::Point('9.945736', '-84.055214', '4326')
EXEC @return_value = [dbo].[getWinesAndWineyards] @originPoint, 10000
GO

DECLARE	@return_value int
DECLARE @originPoint GEOGRAPHY = GEOGRAPHY::Point('9.945736', '-84.055214', '4326')
EXEC @return_value = [dbo].[getWinesAndWineyards] @originPoint, 50000
GO

DECLARE	@return_value int
DECLARE @originPoint GEOGRAPHY = GEOGRAPHY::Point('9.945736', '-84.055214', '4326')
EXEC @return_value = [dbo].[getWinesAndWineyards] @originPoint, 100000
GO
