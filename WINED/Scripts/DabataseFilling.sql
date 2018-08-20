
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

DROP PROCEDURE IF EXISTS [dbo].[populateWines]
GO

CREATE PROCEDURE dbo.populateWines
    @index INT,
    @quantity INT,
    @minYear INT,
    @maxYear INT
AS

-- FK Limits detection
DECLARE @wineyardId INT
DECLARE @wineyardCount INT
DECLARE @winetypeId INT
DECLARE @winetypeCount INT

SELECT TOP (1)
    @wineyardId = [id]
FROM Wineyard
SELECT
    @wineyardCount = count(*)
FROM Wineyard

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


-- ------
-- Users!

DROP PROCEDURE IF EXISTS dbo.insertUser
GO

CREATE PROCEDURE dbo.insertUser
    @userName VARCHAR(50),
    @name VARCHAR(50),
    @lastName VARCHAR(50),
    @email VARCHAR(50),
    @newId INT = NULL OUTPUT
AS
BEGIN
    DECLARE @created DATETIME = CURRENT_TIMESTAMP

    INSERT INTO [dbo].[User]
        (UserName, Name, LastName, Email, Created)
    VALUES
        (@userName, @name, @lastName, @email, @created)

    SET @newId = SCOPE_IDENTITY()
END
GO


-- -------- ------
-- Populate Users!

DROP PROCEDURE IF EXISTS dbo.populateUsers
GO

CREATE PROCEDURE dbo.populateUsers
    @index INT,
    @quantity INT
AS

WHILE @index <= @quantity
BEGIN
    DECLARE @username VARCHAR(50) = 'user' + LTRIM(STR(@index)) + '_UserName'
    DECLARE @name VARCHAR(50) = 'user' + LTRIM(STR(@index)) + '_Name'
    DECLARE @lastName VARCHAR(50) = 'user' + LTRIM(STR(@index)) + '_LastName'
    DECLARE @email VARCHAR(50) = 'user' + LTRIM(STR(@index)) + '@email.com'

    DECLARE @userId INT
    EXECUTE [dbo].[insertUser]
        @username,
        @name,
        @lastName,
        @email,
        @newId = @userId OUTPUT

    -- TODO Insert address/location

    SET @index = @index + 1
END
GO


-- --------
-- Reviews!

DROP PROCEDURE IF EXISTS dbo.populateReviewsPerWine
GO

CREATE PROCEDURE dbo.populateReviewsPerWine
    @minEntries INT,
    @maxEntries INT
AS

DECLARE @wineId INT
DECLARE @wineCount INT
DECLARE @userId INT

SELECT TOP (1)
    @wineId = [id]
FROM [dbo].[Wine]

SELECT
    @wineCount = count(*)
FROM [dbo].[Wine]

SELECT TOP (1)
    @userId = [id]
FROM [dbo].[User]

WHILE @wineCount > 0
BEGIN

    DECLARE @userIdIndex INT = @userId
    DECLARE @entries INT = ROUND(((@maxEntries - @minEntries - 1) * RAND() + @minEntries), 0)

    WHILE @entries > 0
    BEGIN
        DECLARE @description VARCHAR(1000) =  'UserId' + LTRIM(STR(@userIdIndex)) + '_Description'
        DECLARE @rating INT = ROUND(((5 - 0 - 1) * RAND() + 0), 0)
        DECLARE @purchasePrice NUMERIC = ROUND(((5 - 0 - 1) * RAND() + 0), 0)
        DECLARE @computer VARCHAR(50) =  'UserId' + LTRIM(STR(@userIdIndex)) + '_Computer'
        DECLARE @username VARCHAR(50) =  'UserId' + LTRIM(STR(@userIdIndex)) + '_Username'
        DECLARE @postTime DATETIME = CURRENT_TIMESTAMP
        DECLARE @checksum VARCHAR(50) = Checksum(
            LTRIM(STR(@userIdIndex)) +
            LTRIM(STR(@wineId)) +
            @description +
            LTRIM(STR(@rating)) +
            LTRIM(STR(@purchasePrice)) +
            @computer +
            @username)

        INSERT [dbo].[Review]
            (FK_Review_User_Id, FK_Review_Wine_Id, Description, Rating, PurchasePrice, Computer, Username, PostTime, Checksum)
        VALUES
            (
                @userIdIndex,
                @wineId,
                @description,
                @rating,
                @purchasePrice,
                @computer,
                @username,
                @postTime,
                @checksum
            )

        -- TODO Insert Address/Location

        SET @userIdIndex = @userIdIndex + 1
        SET @entries = @entries - 1
    END

    SET @wineId = @wineId + 1
    SET @wineCount = @wineCount - 1
END
GO


-- -------- ----------
-- DATABASE POPULATION
-- -------- ----------

EXECUTE [dbo].[populateWineyards] 1, 1, 1, 60
GO

DECLARE @originPoint GEOGRAPHY = GEOGRAPHY::Point('47.65100', '-122.34900', '4326')
EXECUTE [dbo].[populateWineyardsLocations] @originPoint, 20000
GO

EXECUTE [dbo].[populateWineTypes] 1, 1
GO

EXECUTE [dbo].[populateWines] 1, 1, 1970, 2016
GO

EXECUTE [dbo].[populateUsers] 1, 5
GO

EXECUTE [dbo].[populateReviewsPerWine] 0, 5
GO
