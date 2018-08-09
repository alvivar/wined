CREATE TABLE [dbo].[Review]
(
	[Id] INT NOT NULL PRIMARY KEY, 
	[FK_Review_User_Id] INT NOT NULL, 
    [Description] VARCHAR(1000) NULL, 
    [Rating] DECIMAL NULL, 
    CONSTRAINT [FK_Review_User] FOREIGN KEY ([FK_Review_User_Id]) REFERENCES [User]([Id])
)
