CREATE PROCEDURE [dbo].[insertReview]
	@userId int,
	@userLocation GEOGRAPHY,
	@wineId int,
-- @wineName varchar(50),
	@description varchar(1000),
	@rating tinyint,
	@purchasePrice numeric
-- Valorización de atributos del vino
-- Comidas de la experiencia del vino
AS

-- SET XACT_ABORT ON -- Automatic rollback

BEGIN TRANSACTION
BEGIN TRY

	-- New review
	DECLARE @computer varchar(50) = 'Computer name detected'
	DECLARE @username varchar(50) = 'Username detected'
	DECLARE @postTime DATETIME = CURRENT_TIMESTAMP
	DECLARE @checksum VARCHAR(50) = Checksum(
            LTRIM(STR(@userId)) +
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
			@userId,
			@wineId,
			@description,
			@rating,
			@purchasePrice,
			@computer,
			@username,
			@postTime, 
			@checksum
		)

	DECLARE @newReviewId INT  = SCOPE_IDENTITY()

	-- New review address
	DECLARE @locationName VARCHAR(50) = 'Review' + LTRIM(STR(@newReviewId))
	DECLARE @line1 varchar(50) = @locationName + '_Line1'
	DECLARE @line2 varchar(50) = @locationName + '_Line2'
	DECLARE @line3 varchar(50) = @locationName + '_Line3'
	DECLARE @city varchar(50) = @locationName + '_City'
	DECLARE @province varchar(50) = @locationName + '_Province'
	DECLARE @country varchar(50) = @locationName + '_Country'
	DECLARE @details varchar(1000) = @locationName + '_Details'
	DECLARE @geography geography = @userLocation

	-- New address
	INSERT INTO [dbo].[Address]
        (Line1, Line2, Line3, City, Province, Country, Details, Geography)
    VALUES
        (@line1, @line2, @line3, @city, @province, @country, @details, @geography)

    DECLARE @newAddressId INT = SCOPE_IDENTITY()
	 
	-- New Review address
	INSERT [dbo].[ReviewAddress]
		([FK_ReviewAddress_Review_Id], [FK_ReviewAddress_Address_Id])
	VALUES
		(
			@newReviewId,
			@newAddressId
		)

    COMMIT TRANSACTION
END TRY

BEGIN CATCH
    SELECT
	ERROR_NUMBER() AS ErrorNumber,
	ERROR_SEVERITY() AS ErrorSeverity,
	ERROR_STATE() AS ErrorState,
	ERROR_PROCEDURE() AS ErrorProcedure,
	ERROR_LINE() AS ErrorLine,
	ERROR_MESSAGE() AS ErrorMessage
    ROLLBACK TRANSACTION
END CATCH

RETURN 0
