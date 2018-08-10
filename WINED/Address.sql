CREATE TABLE [dbo].[Address]
(
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [Line1] VARCHAR(50) NOT NULL,
    [Line2] VARCHAR(50) NOT NULL,
    [Line3] VARCHAR(50) NOT NULL,
    [City] VARCHAR(50) NOT NULL,
    [Province] VARCHAR(50) NOT NULL,
    [Country] VARCHAR(50) NOT NULL,
    [Details] VARCHAR(1000) NOT NULL,
    [Location] [sys].[geography] NOT NULL
)
