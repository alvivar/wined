CREATE TABLE [dbo].[Wine]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [FK_Wine_Wineyard_Id] INT NULL, 
	[FK_Wine_WineType_Id] INT NULL, 
    [Name] VARCHAR(50) NULL,
	[Description] VARCHAR(1000) NULL,
    [Year] INT NULL,         
    CONSTRAINT [FK_Wine_Wineyard] FOREIGN KEY ([FK_Wine_Wineyard_Id]) REFERENCES [Wineyard]([Id]), 
    CONSTRAINT [FK_Wine_WineType] FOREIGN KEY ([FK_Wine_WineType_Id]) REFERENCES [WineType]([Id]) 
)
