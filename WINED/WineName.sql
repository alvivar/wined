CREATE TABLE [dbo].[WineName]
(
	[Id] INT NOT NULL PRIMARY KEY,
	[FK_WineName_WineType_Id] INT NULL, 
    [Name] VARCHAR(50) NULL,     
    CONSTRAINT [FK_WineName_WineType] FOREIGN KEY ([FK_WineName_WineType_Id]) REFERENCES [WineType]([Id])
)
