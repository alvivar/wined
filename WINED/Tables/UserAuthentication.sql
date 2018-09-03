CREATE TABLE [dbo].[UserAuthentication]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	[FK_UserAuthentication_User_Id] INT NOT NULL,
	[FK_UserAuthentication_Authentication_Id] INT NOT NULL,
	CONSTRAINT [FK_UserAuthentication_User] FOREIGN KEY ([FK_UserAuthentication_User_Id]) REFERENCES [User]([Id]),
	CONSTRAINT [FK_UserAuthentication_Authentication] FOREIGN KEY ([FK_UserAuthentication_Authentication_Id]) REFERENCES [Authentication]([Id])
)
