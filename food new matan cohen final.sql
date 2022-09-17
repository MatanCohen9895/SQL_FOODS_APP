Use Food
GO
DROP TABLE dbo.Recipes
DROP TABLE dbo.Ingredients
DROP TABLE dbo.Users
DROP TABLE dbo.Publisher
DROP TABLE dbo.Comments
DROP TABLE dbo.RecipeIngredient
DROP TABLE dbo.RecipeSubFoodCatagories
DROP TABLE dbo.FoodCategories
DROP TABLE City

-- Ingredients
create table Ingredients (
IngredientID smallint check(IngredientID > 0) primary key,
IngredientName varchar(20) not null UNIQUE,
Calories SMALLINT CHECK (Calories BETWEEN 1 AND 1000),
)
-- FoodCatagories
create table FoodCategories (
FoodCategoryID smallint check(FoodCategoryID > 0) primary key,
FoodCategoryName varchar(20) not null unique
)
--City
CREATE TABLE City (
CityNum SMALLINT CHECK(CityNum>0) PRIMARY KEY,
CityName VARCHAR(20)NOT NULL unique
)
-- User
create table Users(
    UserID smallint check(UserID>0),
	email VARCHAR(20) NOT NULL,
   -- RecipeID smallint references Recipes(RecipeID),
    Birthdate dateTime check(datediff(Year, Birthdate,getdate())>18) not null,
    CityNum SMALLINT NOT null,
    FirstName varchar(30) not null,
    LastName varchar(30) not NULL, 
	Gender char(1)check(Gender in('M','F')) NOT NULL,
	password VARCHAR(20),
	userType VARCHAR(20),
	PRIMARY KEY (UserID),
	FOREIGN KEY (CityNum) REFERENCES City(CityNum), 
	);

-- Publisher
create table Publisher(
PublisherID smallint REFERENCES Users(UserID),
FirstName varchar(30) not null,
LastName varchar(30) not NULL
Primary key(PublisherID)
)
-- Comments
create table Comments (
UserID smallint references Users(UserID),
CommentDate dateTime check(datediff(day, CommentDate,getdate())>0),
Rating tinyint check(Rating between 1 and 5),
PRIMARY KEY (UserID, CommentDate)
)
-- RecipeSubFoodCategories
create table RecipeSubFoodCategories (
RecipeSubFoodCategoryID SMALLINT PRIMARY KEY,
FoodCategoryID smallint references FoodCategories(FoodCategoryID)
)
-- Recipes
create table Recipes (
RecipeID smallint check(RecipeID>0),
PublisherID smallint references Publisher(PublisherID),
SubFoodCategoryID SMALLINT REFERENCES RecipeSubFoodCategories(RecipeSubFoodCategoryID),
CommentDate DATETIME ,
UserID SMALLINT,
Title varchar(20) check(len(Title) >= 0) not null,
Description varchar(500) check(len(Description) >= 0) not null,
TotalTime float check(TotalTime >0) not null,
[Type] VARCHAR(10) check(Type in('starter','dish', 'dessert')) NOT NULL,
[Level] VARCHAR(10) check(Level in('easy','medium', 'hard')) NOT NULL,
PublicationDate dateTime check(datediff(day,PublicationDate,getdate())>0),
constraint [Fk_B_01] foreign key (UserID,CommentDate) references Comments(UserID,CommentDate),
Primary key(RecipeID)
)
-- RecipesIngredients
create TABLE RecipeIngredient(
RecipeID smallint references Recipes(RecipeID),
IngredientID smallint references Ingredients(IngredientID),
PublisherID smallint references Publisher(PublisherID),
SubFoodCategoryID SMALLINT REFERENCES RecipeSubFoodCategories(RecipeSubFoodCategoryID),
CommentDate DATETIME,
UserID SMALLINT,
Amount SMALLINT CHECK(Amount >0 ) ,
constraint [Fk_B_02] foreign key (UserID,CommentDate) references Comments(UserID,CommentDate),
constraint [Fk_B_03] foreign key (RecipeID) references Recipes(RecipeID),
PRIMARY KEY(RecipeID,IngredientID)
)
--specialize in
CREATE TABLE SpecializeIn(
PublisherID smallint REFERENCES Publisher(PublisherID),
CategorieID SMALLINT REFERENCES FoodCategories(FoodCategoryID),
PRIMARY KEY (PublisherID, CategorieID)
)

-- Questions
	CREATE TABLE Questions (
	questionNum INTEGER NOT NULL,
	qusetion VARCHAR(50) NOT NULL,
	PRIMARY KEY (questionNum));

	-- Answers
	CREATE TABLE Answers (
	answerNum INTEGER NOT NULL,
	answer VARCHAR(50) NOT NULL,
	email VARCHAR(20) NOT NULL,
	questionNum INTEGER NOT NULL,
	UserID smallint check(UserID>0),
	PRIMARY KEY (answerNum),
	FOREIGN KEY (questionNum) REFERENCES Questions (questionNum),
	FOREIGN KEY (UserID) REFERENCES Users (UserID)
	);

	-- Log
	CREATE TABLE Log (
	isSuccessLogin BIT NOT NULL,
	loginTime DATETIME NOT NULL, 
	email VARCHAR(20),
	StatusLogin VARCHAR(20),
	UserID smallint check(UserID>0)NOT NULL,
	PRIMARY KEY (UserID, loginTime),
	FOREIGN KEY (UserID) REFERENCES Users (UserID)
	);





	
	INSERT INTO City (CityNum,CityName) VALUES ('1221','Haifa');
	INSERT INTO City (CityNum,CityName) VALUES ('2233','Tel Aviv');




INSERT INTO Users (UserID,email,birthDate,CityNum,firstName,lastName,Gender,password,userType) VALUES ('1111','ori@gmail.com','12-03-1996','1221','Ori','Cohen','M','1234','admin');
INSERT INTO Users (UserID,email,birthDate,CityNum,firstName,lastName,Gender,password,userType) VALUES ('2222','matan@gmail.com','11-05-1996','1221','matan','Cohen','M','4567','guestUser');
INSERT INTO Users (UserID,email,birthDate,CityNum,firstName,lastName,Gender,password,userType) VALUES ('3333','nir@gmail.com','11-05-1996','2233','nir','hen','M','1245','LoginUser');
	
INSERT INTO Questions (questionNum, qusetion) VALUES (1, 'What is your mother name?');
INSERT INTO Questions (questionNum, qusetion) VALUES (2, 'What is your father name?');

INSERT INTO Answers (UserID,answerNum, answer, email, questionNum) VALUES ('1111',1, 'Ruti', 'ori@gmail.com', 1);
INSERT INTO Answers (UserID,answerNum, answer, email, questionNum) VALUES ('2222',2, 'Hezi', 'matan@gmail.com', 2);


	INSERT INTO Log (loginTime, email, isSuccessLogin,UserID) VALUES (CONVERT(datetime, '1995-02-07 10:33:09'), 'ori@gmail.com', 0,'1111');
	INSERT INTO Log (loginTime, email, isSuccessLogin,UserID) VALUES (CONVERT(datetime, '1995-02-07 10:34:09'), 'ori@gmail.com', 1,'1111');
	INSERT INTO Log (loginTime, email, isSuccessLogin,UserID) VALUES (CONVERT(datetime, '2022-07-29 16:01:09'), 'ori@gmail.com', 0,'1111');
	INSERT INTO Log (loginTime, email, isSuccessLogin,UserID) VALUES (CONVERT(datetime, '2022-07-29 16:00:09'), 'ori@gmail.com', 0,'1111');
	INSERT INTO Log (loginTime, email, isSuccessLogin,UserID) VALUES (CONVERT(datetime, '2022-07-29 16:02:09'), 'ori@gmail.com', 0,'1111');
	INSERT INTO Log (loginTime, email, isSuccessLogin,UserID) VALUES (CONVERT(datetime, '2022-07-29 16:01:12'), 'ori@gmail.com', 1,'1111');

	INSERT INTO Log (loginTime, email, isSuccessLogin,StatusLogin,UserID) VALUES (CONVERT(datetime, '2022-08-21 19:49:15'), 'ori@gmail.com', 0,'Fail','1111');
	INSERT INTO Log (loginTime, email, isSuccessLogin,StatusLogin,UserID) VALUES (CONVERT(datetime, '2022-08-22 19:49:09'), 'nir@gmail.com', 0,'Block','3333');
	INSERT INTO Log (loginTime, email, isSuccessLogin,StatusLogin,UserID) VALUES (CONVERT(datetime, '2022-08-22 19:48:09'), 'nir@gmail.com', 0,'Block','3333');
	INSERT INTO Log (loginTime, email, isSuccessLogin,StatusLogin,UserID) VALUES (CONVERT(datetime, '2022-08-21 19:49:12'), 'ori@gmail.com', 1,'Success','1111');
	INSERT INTO Log (loginTime, email, isSuccessLogin,StatusLogin,UserID) VALUES (CONVERT(datetime, '2022-08-22 19:48:09'), 'matan@gmail.com', 0,'Block','2222');
	INSERT INTO Log (loginTime, email, isSuccessLogin,StatusLogin,UserID) VALUES (CONVERT(datetime, '2022-08-22 19:48:13'), 'nir@gmail.com', 0,'Block','3333');

	INSERT INTO Log (loginTime, email, isSuccessLogin,StatusLogin,UserID) VALUES (CONVERT(datetime, '2022-07-24 16:01:12'), 'matan@gmail.com', 0,'Success','2222');
	INSERT INTO Log (loginTime, email, isSuccessLogin,StatusLogin,UserID) VALUES (CONVERT(datetime, '2022-07-24 16:05:12'), 'nir@gmail.com', 1,'Success','3333');
	INSERT INTO Log (loginTime, email, isSuccessLogin,StatusLogin,UserID) VALUES (CONVERT(datetime, '2022-08-26 12:52:00'), 'matan@gmail.com', 0,'Block','2222');
	INSERT INTO Log (loginTime, email, isSuccessLogin,StatusLogin,UserID) VALUES (CONVERT(datetime, '2022-08-26 12:52:00'), 'nir@gmail.com', 0,'Block','3333');
	




 DROP PROCEDURE UpdateStatusLogin

	CREATE PROCEDURE UpdateStatusLogin
	@UserID smallint, @pass VARCHAR(20)
	AS
	DECLARE @isSuccessLogin AS BIT;
	DECLARE @isBlocked AS BIT;
	DECLARE @isLoggedIn AS BIT;
	DECLARE @numOfTries AS INT;
	DECLARE @tmpTbl AS TABLE (isLogged BIT);
	
	
	SELECT TOP 1 @numOfTries =
	(
		SELECT COUNT(*)
		FROM Log
		WHERE isSuccessLogin = 0 AND UserID = @UserID AND DATEDIFF(minute, loginTime, CURRENT_TIMESTAMP) <= 3
	)
	PRINT @numOfTries
	
	
	SELECT TOP 1 @isSuccessLogin =
	(
		SELECT CASE WHEN EXISTS( 
			SELECT *
			FROM Users as U
			WHERE U.UserID = @UserID AND U.password = @pass
		)
		THEN 1 --'True'
		ELSE 0 --'False'
		END AS isSuccessLogin
	)
	PRINT @isSuccessLogin

	

	
	SELECT TOP 1 @isBlocked =
	(
		SELECT COUNT(*)
		FROM LOG
		WHERE UserID = @UserID AND StatusLogin = 'Block' AND DATEDIFF(minute, loginTime, CURRENT_TIMESTAMP) < 20
	)

	
	IF (@isSuccessLogin = 1 AND @isBlocked < 1 ) 
		INSERT INTO Log(loginTime, UserID, StatusLogin, isSuccessLogin)
		VALUES(CURRENT_TIMESTAMP , @UserID, 'Success', @isSuccessLogin);

	-- Success
	ELSE IF (@isSuccessLogin = 1 AND @numOfTries < 3) 
		INSERT INTO Log(loginTime, UserID, StatusLogin, isSuccessLogin)
		VALUES(CURRENT_TIMESTAMP , @UserID, 'Success', @isSuccessLogin);

	-- Fail
	ELSE IF (@isSuccessLogin = 0 AND @numOfTries < 3)
		INSERT INTO Log(loginTime, UserID, StatusLogin, isSuccessLogin)
		VALUES(CURRENT_TIMESTAMP , @UserID, 'Fail', @isSuccessLogin);

	-- Block
	ELSE IF (@isSuccessLogin = 0 AND @numOfTries >= 3)
		INSERT INTO Log(loginTime, UserID, StatusLogin, isSuccessLogin)
		VALUES(CURRENT_TIMESTAMP , @UserID, 'Block', @isSuccessLogin);
	GO

	EXEC UpdateStatusLogin @UserID='1111',@pass='1234';

	DROP PROCEDURE GetIsSuccessLogin

 CREATE PROCEDURE GetIsSuccessLogin @UserID VARCHAR(20)
 AS
 DECLARE @isSuccessLoginVar AS VARCHAR(20);
 SET @isSuccessLoginVar = 'Block'
 SELECT @isSuccessLoginVar = L.StatusLogin
 FROM Log L 
 WHERE StatusLogin = 'Success' AND DATEDIFF(SECOND, loginTime, CURRENT_TIMESTAMP) < 30 AND L.UserID = @UserID

 IF (@isSuccessLoginVar != 'Success') 
	INSERT INTO Log (loginTime, UserID, isSuccessLogin,StatusLogin) VALUES (CONVERT(datetime, CURRENT_TIMESTAMP), @UserID, 1,'Success');

PRINT @isSuccessLoginVar
 GO

 EXEC GetIsSuccessLogin @UserID='1111';


DROP PROCEDURE AllBlockedUsers

 CREATE PROCEDURE AllBlockedUsers @UserID smallint
 AS
 SELECT distinct L.UserID 
 FROM Log L inner join Users U ON L.UserID=U.UserID
 WHERE StatusLogin = 'Block' AND DATEDIFF(minute, loginTime, CURRENT_TIMESTAMP) < 20 AND U.UserID != @UserID
 GO



DROP PROCEDURE GetDateTimeofUsers

 CREATE PROCEDURE GetDateTimeofUsers @UserID smallint
 AS
 SELECT L.UserID,MAX(L.loginTime) AS max_date
 FROM Log L
 WHERE  StatusLogin = 'Success'
 GROUP BY L.UserID
 GO

  EXEC GetDateTimeofUsers @UserID='1111';


DROP PROCEDURE GetUserLoginHistory

 CREATE PROCEDURE GetUserLoginHistory @UserID smallint
 AS
 SELECT L.*
 FROM Log L
 WHERE  L.UserID=@UserID
 GO
 EXEC GetUserLoginHistory @UserID='1111';





