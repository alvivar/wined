CREATE TABLE [dbo].[WineyardGrape]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [FK_WineyardGrape_Wineyard_Id] INT NULL, 
    [FK_WineyardGrape_Grape_Id] INT NULL, 
    CONSTRAINT [FK_WineyardGrape_Wineyard] FOREIGN KEY ([FK_WineyardGrape_Wineyard_Id]) REFERENCES [Wineyard]([Id]), 
    CONSTRAINT [FK_WineyardGrape_Grape] FOREIGN KEY ([FK_WineyardGrape_Grape_Id]) REFERENCES [Grape]([Id])
)
