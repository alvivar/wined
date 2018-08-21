CREATE TABLE [dbo].[Following]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [FK_Following_User_Id] INT NOT NULL, 	
    [FK_Following_Follower_Id] INT NOT NULL, 
	[IsFollower] BIT NOT NULL,
    [FollowDate] DATETIME NOT NULL, 
    [UnfollowDate] DATETIME NOT NULL, 
    CONSTRAINT [FK_Following_User] FOREIGN KEY ([FK_Following_User_Id]) REFERENCES [User]([Id]), 
    CONSTRAINT [FK_Following_Follower] FOREIGN KEY ([FK_Following_Follower_Id]) REFERENCES [User]([Id])    
)
