CREATE TABLE [dbo].[WineIngredient]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [FK_WineIngredient_Wine_Id] INT NULL, 
    [FK_WineIngredient_Ingredient_Id] INT NULL, 
    CONSTRAINT [FK_WineIngredient_Wine] FOREIGN KEY ([FK_WineIngredient_Wine_Id]) REFERENCES [Wine]([Id]), 
    CONSTRAINT [FK_WineIngredient_Ingredient] FOREIGN KEY ([FK_WineIngredient_Ingredient_Id]) REFERENCES [Ingredient]([Id]) 
)
