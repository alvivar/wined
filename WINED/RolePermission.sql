CREATE TABLE [dbo].[RolePermission]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY,
	[FK_RolePermission_Role_Id] INT NOT NULL,
	[FK_RolePermission_Permission_Id] INT NOT NULL,
	CONSTRAINT [FK_RolePermission_Role] FOREIGN KEY ([FK_RolePermission_Role_Id]) REFERENCES [Role]([Id]),
	CONSTRAINT [FK_RolePermission_Permission] FOREIGN KEY ([FK_RolePermission_Permission_Id]) REFERENCES [Permission]([Id])
)
