CREATE TABLE [dbo].[User]
(
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [Username] VARCHAR(50) NOT NULL,
    [Fullname] VARCHAR(50) NOT NULL,
    [Email] VARCHAR(50) NOT NULL,
    [Checksum] VARCHAR(50) NULL,
    [Created] DATETIME NOT NULL 
)
