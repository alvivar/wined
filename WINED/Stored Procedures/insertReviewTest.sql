USE [WINED]
GO

DECLARE	@return_value int
DECLARE @originPoint GEOGRAPHY = GEOGRAPHY::Point('9.945736', '-84.055214', '4326')
EXEC @return_value = [dbo].[insertReview] 3121, @originPoint, 53235, 'Enjoyable', 4, 28
SELECT * FROM Review
SELECT * FROM ReviewAddress
SELECT * FROM Address
GO
