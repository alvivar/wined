CREATE TABLE [dbo].[AuthenticationSource]
(
    [Id] INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    [Name] VARCHAR(50) NOT NULL,
    [Description] VARCHAR(500) NOT NULL
)
