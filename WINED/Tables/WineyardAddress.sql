﻿CREATE TABLE [dbo].[WineyardAddress]
(
    [Id] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    [FK_WineyardAddress_Wineyard_Id] INT NOT NULL,
    [FK_WineyardAddress_Address_Id] INT NOT NULL,
    CONSTRAINT [FK_WineyardAddress_Wineyard] FOREIGN KEY ([FK_WineyardAddress_Wineyard_Id]) REFERENCES [Wineyard]([Id]),
    CONSTRAINT [FK_WineyardAddress_Address] FOREIGN KEY ([FK_WineyardAddress_Address_Id]) REFERENCES [Address]([Id])
)
