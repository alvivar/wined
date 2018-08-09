CREATE TABLE [dbo].[RecommendedFood]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [FK_RecommendedFood_WineType_Id] INT NOT NULL, 
    [FK_RecommendedFood_Food_Id] INT NOT NULL, 
    CONSTRAINT [FK_RecommendedFood_WineType] FOREIGN KEY ([FK_RecommendedFood_WineType_Id]) REFERENCES [WineType]([Id]),
    CONSTRAINT [FK_RecommendedFood_Food] FOREIGN KEY ([FK_RecommendedFood_Food_Id]) REFERENCES [Food]([Id])
)
