CREATE TABLE [dbo].[Wine]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY(1,1), 
    [FK_Wine_Wineyard_Id] INT NOT NULL, 
	[FK_Wine_WineType_Id] INT NOT NULL, 
    [Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(1000) NOT NULL,
    [Year] INT NOT NULL,         
    CONSTRAINT [FK_Wine_Wineyard] FOREIGN KEY ([FK_Wine_Wineyard_Id]) REFERENCES [Wineyard]([Id]), 
    CONSTRAINT [FK_Wine_WineType] FOREIGN KEY ([FK_Wine_WineType_Id]) REFERENCES [WineType]([Id]) 
)
