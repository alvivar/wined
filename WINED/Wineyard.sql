CREATE TABLE [dbo].[Wineyard]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [Name] VARCHAR(50) NOT NULL, 
	[Antiquity] INT NOT NULL,
    [Location] [sys].[geography] NOT NULL
)
