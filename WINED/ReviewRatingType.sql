CREATE TABLE [dbo].[ReviewRatingType]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [FK_ReviewRatingType_Review_Id] INT NOT NULL, 
    [FK_ReviewRatingType_RatingType_Id] INT NOT NULL, 
    [Rating] DECIMAL NOT NULL, 
    CONSTRAINT [FK_ReviewRatingType_Review] FOREIGN KEY ([FK_ReviewRatingType_Review_Id]) REFERENCES [Review]([Id]), 
    CONSTRAINT [FK_ReviewRatingType_RatingType] FOREIGN KEY ([FK_ReviewRatingType_RatingType_Id]) REFERENCES [RatingType]([Id])
)
