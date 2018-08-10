CREATE TABLE [dbo].[UserRole]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY,
	[FK_UserRole_User_Id] INT NOT NULL,
	[FK_UserRole_Role_Id] INT NOT NULL,
	CONSTRAINT [FK_UserRole_User] FOREIGN KEY ([FK_UserRole_User_Id]) REFERENCES [User]([Id]),
	CONSTRAINT [FK_UserRole_Role] FOREIGN KEY ([FK_UserRole_Role_Id]) REFERENCES [Role]([Id])
)
