CREATE TABLE [dbo].[Review]
(
    [Id] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    [FK_Review_User_Id] INT NOT NULL,
    [FK_Review_Wine_Id] INT NOT NULL,
    [Description] VARCHAR(1000) NOT NULL,
    [Rating] TINYINT NOT NULL,
    [PurchasePrice] NUMERIC NOT NULL,
    [Computer] VARCHAR(50) NOT NULL,
    [Username] VARCHAR(50) NOT NULL,
    [PostTime] DATETIME NOT NULL,
    [Checksum] VARCHAR(50) NOT NULL,
    CONSTRAINT [FK_Review_User] FOREIGN KEY ([FK_Review_User_Id]) REFERENCES [User]([Id]),
    CONSTRAINT [FK_Review_Wine] FOREIGN KEY ([FK_Review_Wine_Id]) REFERENCES [Wine]([Id])
)
