CREATE TABLE [dbo].[Following]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [UserId] INT NOT NULL, 	
    [FollowerId] INT NOT NULL, 
	[IsFollower] BIT NOT NULL,
    [FollowDate] DATETIME NOT NULL, 
    [UnfollowDate] DATETIME NOT NULL    
)
