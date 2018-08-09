CREATE TABLE [dbo].[WineyardIngredient]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [FK_WineyardIngredient_Wineyard_Id] INT NULL, 
    [FK_WineyardIngredient_Ingredient_Id] INT NULL, 
    CONSTRAINT [FK_WineyardIngredient_Wineyard] FOREIGN KEY ([FK_WineyardIngredient_Wineyard_Id]) REFERENCES [Wineyard]([Id]), 
    CONSTRAINT [FK_WineyardIngredient_Ingredient] FOREIGN KEY ([FK_WineyardIngredient_Ingredient_Id]) REFERENCES [Ingredient]([Id]) 
)
