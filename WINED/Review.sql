CREATE TABLE [dbo].[Review]
(
	[Id] INT NOT NULL PRIMARY KEY, 
	[FK_Review_User_Id] INT NOT NULL, 
	[FK_Review_Wine_Id] INT NOT NULL, 
    [Description] VARCHAR(1000) NOT NULL, 
    [Rating] DECIMAL NOT NULL,     
    [Location] [sys].[geography] NOT NULL, 
    CONSTRAINT [FK_Review_User] FOREIGN KEY ([FK_Review_User_Id]) REFERENCES [User]([Id]), 
    CONSTRAINT [FK_Review_Wine] FOREIGN KEY ([FK_Review_Wine_Id]) REFERENCES [Wine]([Id])
)
