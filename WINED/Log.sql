CREATE TABLE [dbo].[Log]
(
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [FK_Log_LogLevel_Id] INT NOT NULL,
    [FK_Log_LogType_Id] INT NOT NULL,
    [FK_Log_LogSource_Id] INT NOT NULL,
    [Description] VARCHAR(1000) NOT NULL,
    [Username] VARCHAR(50) NOT NULL,
    [Computer] VARCHAR(50) NOT NULL,
    [Ip] VARCHAR(50) NOT NULL,
    [Details] VARCHAR(1000) NULL,
    -- [ReferenceId1] INT NULL,
    -- [ReferenceId2] INT NULL,
    CONSTRAINT [FK_Log_LogLevel] FOREIGN KEY ([FK_Log_LogLevel_Id]) REFERENCES [LogLevel]([Id]),
    CONSTRAINT [FK_Log_LogType] FOREIGN KEY ([FK_Log_LogType_Id]) REFERENCES [LogType]([Id]),
    CONSTRAINT [FK_Log_LogSource] FOREIGN KEY ([FK_Log_LogSource_Id]) REFERENCES [LogSource]([Id])
)
