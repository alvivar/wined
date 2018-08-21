CREATE TABLE [dbo].[ReviewAddress]
(
    [Id] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    [FK_ReviewAddress_Review_Id] INT NOT NULL,
    [FK_ReviewAddress_Address_Id] INT NOT NULL,
    CONSTRAINT [FK_ReviewAddress_Review] FOREIGN KEY ([FK_ReviewAddress_Review_Id]) REFERENCES [Review]([Id]),
    CONSTRAINT [FK_ReviewAddress_Address] FOREIGN KEY ([FK_ReviewAddress_Address_Id]) REFERENCES [Address]([Id])
)
