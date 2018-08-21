CREATE TABLE [dbo].[Authentication]
(
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [FK_Authentication_AuthenticationSource_Id] INT NOT NULL,
    [ClientId] VARCHAR(50) NOT NULL,
    [ClientSecret] VARCHAR(50) NOT NULL,
    [RedirectUri] VARCHAR(50) NOT NULL,
    [Scope] VARCHAR(50) NOT NULL,
    [ExpiresIn] INT NOT NULL,
    [Checksum] VARCHAR(50) NOT NULL,
    [Created] DATETIME NOT NULL,
    CONSTRAINT [FK_Authentication_AuthenticationSource] FOREIGN KEY ([FK_Authentication_AuthenticationSource_Id]) REFERENCES [AuthenticationSource]([Id])
)
