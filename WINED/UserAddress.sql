CREATE TABLE [dbo].[UserAddress]
(
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [FK_UserAddress_User_Id] INT NOT NULL,
    [FK_UserAddress_Address_Id] INT NOT NULL,
    CONSTRAINT [FK_UserAddress_User] FOREIGN KEY ([FK_UserAddress_User_Id]) REFERENCES [User]([Id]),
    CONSTRAINT [FK_UserAddress_Address] FOREIGN KEY ([FK_UserAddress_Address_Id]) REFERENCES [Address]([Id])
)
