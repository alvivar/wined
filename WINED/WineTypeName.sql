CREATE TABLE [dbo].[WineTypeName]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [FK_WineTypeName_WineType_Id] INT NULL, 
    [FK_WineTypeName_WineName_Id] INT NULL, 
    CONSTRAINT [FK_WineTypeName_WineType] FOREIGN KEY ([FK_WineTypeName_WineType_Id]) REFERENCES [WineType]([Id]), 
    CONSTRAINT [FK_WineTypeName_WineName] FOREIGN KEY (FK_WineTypeName_WineName_Id) REFERENCES [WineName]([Id])
)
