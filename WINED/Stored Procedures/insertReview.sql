CREATE PROCEDURE [dbo].[insertReview]
	@userId int,
	@userLocation GEOGRAPHY,
	@wineId int,
	@wineName varchar(50),
	@description varchar(1000),
	@rating tinyint
	-- Valorización de atributos del vino
	-- Comidas de la experiencia del vino
AS

BEGIN TRANSACTION
BEGIN TRY

	-- do your SQL statements here

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
