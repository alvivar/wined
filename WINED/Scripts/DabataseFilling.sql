
USE WINED
GO


-- ----------
-- Wineyards!

DROP PROCEDURE IF EXISTS dbo.populateWineyards
GO

CREATE PROCEDURE dbo.populateWineyards
    @Index INT,
    @Quantity INT,
    @MinAntiquity INT,
    @MaxAntiquity INT
AS
WHILE @Index <= @Quantity
    BEGIN
    INSERT dbo.Wineyard
        (Name, Antiquity)
    VALUES
        (
            'Wineyard' + LTRIM(STR(@Index)),
            ROUND(((@MaxAntiquity - @MinAntiquity - 1) * RAND() + @MinAntiquity), 0)
        )
    SET @Index = @Index + 1
END
GO


-- ----------
-- Addresses!

DROP PROCEDURE IF EXISTS dbo.insertAddress
GO

CREATE PROCEDURE dbo.insertAddress
    @Line1 VARCHAR(50),
    @Line2 VARCHAR(50),
    @Line3 VARCHAR(50),
    @City VARCHAR(50),
    @Province VARCHAR(50),
    @Country VARCHAR(50),
    @Details VARCHAR(1000),
    @Geography GEOGRAPHY,
    @NewId INT = NULL OUTPUT
AS
BEGIN
    INSERT INTO [dbo].[Address]
        (Line1, Line2, Line3, City, Province, Country, Details, Geography)
    VALUES
        (@Line1, @Line2, @Line3, @City, @Province, @Country, @Details, @Geography)
    SET @NewId = SCOPE_IDENTITY()
END
GO


--SET

DROP PROCEDURE IF EXISTS dbo.getRandomGeographyAround
GO

CREATE PROCEDURE dbo.getRandomGeographyAround
    @Geo GEOGRAPHY,
    @Distance INT,
    @NewGeo GEOGRAPHY = NULL OUTPUT
AS
BEGIN
    DECLARE @r float, @t float, @w float, @x float, @y float, @u float, @v float;

    SET @u = RAND();
    SET @v = RAND();

    -- 8046m = ~ 5 miles
    SET @r = @Distance / (111300*1.0);
    SET @w = @r * sqrt(@u);
    SET @t = 2 * PI() * @v;
    SET @x = @w * cos(@t);
    SET @y = @w * sin(@t);
    SET @x = @x / cos(@Geo.Lat);

    SET @NewGeo = GEOGRAPHY::STPointFromText('POINT(' + CAST(@Geo.Long + @x AS VARCHAR(MAX)) + ' ' + CAST(@Geo.Lat + @y AS VARCHAR(MAX)) + ')', 4326)

--Convert the distance back to miles to validate
-- SELECT @Geo.STDistance(@NewGeo) / 1609.34

END
GO


-- --------- ----------
-- Wineyards locations!

DROP PROCEDURE IF EXISTS dbo.populateWineyardsLocations
GO

CREATE PROCEDURE dbo.populateWineyardsLocations
    @OriginGeo GEOGRAPHY,
    @Distance INT
AS

DECLARE @Index INT
DECLARE @Quantity INT
DECLARE @NewId INT

SELECT TOP (1)
    @Index = [id]
FROM Wineyard

SELECT
    @Quantity = count(*)
FROM Wineyard

WHILE @Quantity > 0
BEGIN

    DECLARE @NewGeo GEOGRAPHY
    EXECUTE dbo.getRandomGeographyAround @OriginGeo, @Distance, @NewGeo = @NewGeo OUTPUT

    DECLARE @LocationName VARCHAR(50) = 'Wineyard' + LTRIM(STR(@Index))
    DECLARE @Line1 varchar(50) = @LocationName + '_Line1'
    DECLARE @Line2 varchar(50) = @LocationName + '_Line2'
    DECLARE @Line3 varchar(50) = @LocationName + '_Line3'
    DECLARE @City varchar(50) = @LocationName + '_City'
    DECLARE @Province varchar(50) = @LocationName + '_Province'
    DECLARE @Country varchar(50) = @LocationName + '_Country'
    DECLARE @Details varchar(1000) = @LocationName + '_Details'
    DECLARE @Geography geography = @NewGeo

    EXECUTE dbo.insertAddress
        @Line1,
        @Line2,
        @Line3,
        @City,
        @Province,
        @Country,
        @Details,
        @Geography,
        @NewId = @NewId OUTPUT

    INSERT dbo.WineyardAddress
        ([FK_WineyardAddress_Wineyard_Id], [FK_WineyardAddress_Address_Id])
    VALUES
        (
            @Index,
            @NewId
        )

    SET @Index = @Index + 1
    SET @Quantity = @Quantity - 1

END
GO


-- -----------
-- Wine types!

DROP PROCEDURE IF EXISTS dbo.populateWineTypes
GO

CREATE PROCEDURE dbo.populateWineTypes
    @Index INT,
    @Quantity INT
AS

WHILE @Index <= @Quantity
BEGIN
    INSERT dbo.WineType
        (Name)
    VALUES
        (
            'WineType' + LTRIM(STR(@Index))
        )
    SET @Index = @Index + 1
END
GO


-- ------
-- Wines!

DROP PROCEDURE IF EXISTS dbo.populateWines
GO

CREATE PROCEDURE dbo.populateWines
    @index INT,
    @quantity INT,
    @minYear INT,
    @maxYear INT
AS

-- Wineyard limits
DECLARE @wineyardId INT
DECLARE @wineyardCount INT

SELECT TOP (1)
    @wineyardId = [id]
FROM Wineyard
SELECT
    @wineyardCount = count(*)
FROM Wineyard

-- Winetype limits
DECLARE @winetypeId INT
DECLARE @winetypeCount INT

SELECT TOP (1)
    @winetypeId = [id]
FROM Winetype
SELECT
    @winetypeCount = count(*)
FROM Winetype

-- Wines
WHILE @index <= @quantity
BEGIN

    DECLARE @randomWineyard INT = @wineyardId + ROUND(((@wineyardCount - 0 - 1) * RAND() + 0), 0)
    DECLARE @randomWinetype INT = @winetypeId + ROUND(((@winetypeCount - 0 - 1) * RAND() + 0), 0)
    DECLARE @randomYear INT = ((@maxYear - @minYear - 1) * RAND() + @minYear)

    INSERT dbo.Wine
        (FK_Wine_Wineyard_Id, FK_Wine_WineType_Id, Name, Description, Year)
    VALUES
        (
            @randomWineyard,
            @randomWinetype,
            'Wine' + LTRIM(STR(@index)) + '_Name',
            'Wine' + LTRIM(STR(@index)) + '_Description',
            @randomYear
	    )

    SET @index = @index + 1

END
GO


-- -------- ----------
-- DATABASE POPULATION
-- -------- ----------

EXECUTE dbo.populateWineyards 1, 100, 1, 60
GO

DECLARE @OriginPoint GEOGRAPHY = GEOGRAPHY::Point('47.65100', '-122.34900', '4326')
EXECUTE dbo.populateWineyardsLocations @OriginPoint, 20000
GO

EXECUTE dbo.populateWineTypes 1, 40
GO

EXECUTE dbo.populateWines 1, 2000, 1970, 2016
GO
