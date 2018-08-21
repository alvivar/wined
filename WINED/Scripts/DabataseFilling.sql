
USE WINED
GO


-- ----------
-- Wineyards!

DROP PROCEDURE IF EXISTS dbo.populateWineyards
GO

CREATE PROCEDURE dbo.populateWineyards
    @index INT,
    @quantity INT,
    @minAntiquity INT,
    @maxAntiquity INT
AS
WHILE @index <= @quantity
    BEGIN
    INSERT dbo.Wineyard
        (Name, Antiquity)
    VALUES
        (
            'Wineyard' + LTRIM(STR(@index)),
            ROUND(((@maxAntiquity - @minAntiquity - 1) * RAND() + @minAntiquity), 0)
        )
    SET @index = @index + 1
END
GO


-- ----------
-- Addresses!

DROP PROCEDURE IF EXISTS dbo.insertAddress
GO

CREATE PROCEDURE dbo.insertAddress
    @line1 VARCHAR(50),
    @line2 VARCHAR(50),
    @line3 VARCHAR(50),
    @city VARCHAR(50),
    @province VARCHAR(50),
    @country VARCHAR(50),
    @details VARCHAR(1000),
    @geography GEOGRAPHY,
    @newId INT = NULL OUTPUT
AS
BEGIN
    INSERT INTO [dbo].[Address]
        (Line1, Line2, Line3, City, Province, Country, Details, Geography)
    VALUES
        (@line1, @line2, @line3, @city, @province, @country, @details, @geography)
    SET @newId = SCOPE_IDENTITY()
END
GO


-- ------ ---------
-- Random geography

DROP PROCEDURE IF EXISTS dbo.getRandomGeographyAround
GO

CREATE PROCEDURE dbo.getRandomGeographyAround
    @geo GEOGRAPHY,
    @distance INT,
    @newGeo GEOGRAPHY = NULL OUTPUT
AS
BEGIN
    DECLARE @r float, @t float, @w float, @x float, @y float, @u float, @v float;

    SET @u = RAND();
    SET @v = RAND();

    -- 8046m = ~ 5 miles
    SET @r = @distance / (111300*1.0);
    SET @w = @r * sqrt(@u);
    SET @t = 2 * PI() * @v;
    SET @x = @w * cos(@t);
    SET @y = @w * sin(@t);
    SET @x = @x / cos(@geo.Lat);

    SET @newGeo = GEOGRAPHY::STPointFromText('POINT(' + CAST(@geo.Long + @x AS VARCHAR(MAX)) + ' ' + CAST(@geo.Lat + @y AS VARCHAR(MAX)) + ')', 4326)

--Convert the distance back to miles to validate
-- SELECT @geo.STDistance(@newGeo) / 1609.34

END
GO


-- --------- ----------
-- Wineyards locations!

DROP PROCEDURE IF EXISTS dbo.populateWineyardsLocations
GO

CREATE PROCEDURE dbo.populateWineyardsLocations
    @originGeo GEOGRAPHY,
    @distance INT
AS

DECLARE @index INT
DECLARE @quantity INT
DECLARE @newId INT

SELECT TOP (1)
    @index = [id]
FROM Wineyard

SELECT
    @quantity = count(*)
FROM Wineyard

WHILE @quantity > 0
BEGIN

    DECLARE @newGeo GEOGRAPHY
    EXECUTE dbo.getRandomGeographyAround @originGeo, @distance, @newGeo = @newGeo OUTPUT

    DECLARE @LocationName VARCHAR(50) = 'Wineyard' + LTRIM(STR(@index))
    DECLARE @line1 varchar(50) = @LocationName + '_Line1'
    DECLARE @line2 varchar(50) = @LocationName + '_Line2'
    DECLARE @line3 varchar(50) = @LocationName + '_Line3'
    DECLARE @city varchar(50) = @LocationName + '_City'
    DECLARE @province varchar(50) = @LocationName + '_Province'
    DECLARE @country varchar(50) = @LocationName + '_Country'
    DECLARE @details varchar(1000) = @LocationName + '_Details'
    DECLARE @geography geography = @newGeo

    EXECUTE dbo.insertAddress
        @line1,
        @line2,
        @line3,
        @city,
        @province,
        @country,
        @details,
        @geography,
        @newId = @newId OUTPUT

    INSERT dbo.WineyardAddress
        ([FK_WineyardAddress_Wineyard_Id], [FK_WineyardAddress_Address_Id])
    VALUES
        (
            @index,
            @newId
        )

    SET @index = @index + 1
    SET @quantity = @quantity - 1

END
GO


-- -----------
-- Wine types!

DROP PROCEDURE IF EXISTS dbo.populateWineTypes
GO

CREATE PROCEDURE dbo.populateWineTypes
    @index INT,
    @quantity INT
AS

WHILE @index <= @quantity
BEGIN
    INSERT dbo.WineType
        (Name)
    VALUES
        (
            'WineType' + LTRIM(STR(@index))
        )
    SET @index = @index + 1
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
    @maxEntries INT,
    @originGeo GEOGRAPHY,
    @distance INT
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

        -- Insert the review
        DECLARE @description VARCHAR(1000) =  'UserId' + LTRIM(STR(@userIdIndex)) + '_Description'
        DECLARE @rating INT = ROUND(((5 - 0 - 1) * RAND() + 0), 0)
        DECLARE @purchasePrice NUMERIC = ROUND(((400 - 8 - 1) * RAND() + 8), 0)
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

        DECLARE @newReviewId INT = SCOPE_IDENTITY()

        -- Insert the review address in a random location around the origin
        DECLARE @newGeo GEOGRAPHY
        EXECUTE dbo.getRandomGeographyAround @originGeo, @distance, @newGeo = @newGeo OUTPUT

        DECLARE @locationName VARCHAR(50) = 'Review' + LTRIM(STR(@newReviewId))
        DECLARE @line1 varchar(50) = @locationName + '_Line1'
        DECLARE @line2 varchar(50) = @locationName + '_Line2'
        DECLARE @line3 varchar(50) = @locationName + '_Line3'
        DECLARE @city varchar(50) = @locationName + '_City'
        DECLARE @province varchar(50) = @locationName + '_Province'
        DECLARE @country varchar(50) = @locationName + '_Country'
        DECLARE @details varchar(1000) = @locationName + '_Details'
        DECLARE @geography geography = @newGeo

        DECLARE @newAddressId INT
        EXECUTE dbo.insertAddress
            @line1,
            @line2,
            @line3,
            @city,
            @province,
            @country,
            @details,
            @geography,
            @newId = @newAddressId OUTPUT

        INSERT dbo.ReviewAddress
            ([FK_ReviewAddress_Review_Id], [FK_ReviewAddress_Address_Id])
        VALUES
            (
                @newReviewId,
                @newAddressId
            )

        -- Move on
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

EXECUTE [dbo].[populateWineyards] 1, 100, 1, 60
GO

DECLARE @originPoint GEOGRAPHY = GEOGRAPHY::Point('9.945736', '-84.055214', '4326')
EXECUTE [dbo].[populateWineyardsLocations] @originPoint, 100000
GO

EXECUTE [dbo].[populateWineTypes] 1, 20
GO

EXECUTE [dbo].[populateWines] 1, 2000, 1970, 2016
GO

EXECUTE [dbo].[populateUsers] 1, 5
GO

DECLARE @originPoint GEOGRAPHY = GEOGRAPHY::Point('9.945736', '-84.055214', '4326')
EXECUTE [dbo].[populateReviewsPerWine] 0, 5, @originPoint, 100000
GO
