CREATE TABLE [dbo].[Wineyard]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [Name] VARCHAR(50) NULL, 
	[Antiquity] INT NULL,
    [Location] [sys].[geography] NULL
)
