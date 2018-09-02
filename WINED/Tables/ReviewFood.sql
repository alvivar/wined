CREATE TABLE [dbo].[ReviewFood]
(
    [Id] INT NOT NULL PRIMARY KEY,
    [FK_ReviewFood_Review_Id] INT NOT NULL,
    [FK_ReviewFood_Food_Id] INT NOT NULL,
    CONSTRAINT [FK_ReviewFood_Review] FOREIGN KEY ([FK_ReviewFood_Review_Id]) REFERENCES [Review]([Id]),
    CONSTRAINT [FK_ReviewFood_Food] FOREIGN KEY ([FK_ReviewFood_Food_Id]) REFERENCES [Food]([Id])
)
