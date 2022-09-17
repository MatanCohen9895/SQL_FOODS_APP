Use Foods
Go
DROP TABLE Ingredients
DROP TABLE Users
DROP TABLE Publisher
DROP TABLE Comments
DROP TABLE RecipeIngredient
DROP TABLE RecipeSubFoodCatagories
DROP TABLE FoodCategories
DROP TABLE City
DROP TABLE Recipes
DROP TABLE Questions

-- Ingredients
create table Ingredients (
    IngredientID smallint check(IngredientID  > 0) primary key,
    IngredientName varchar(20) not null unique
)

-- FoodCatagories
create table FoodCategories (
    FoodCategoryID smallint check(FoodCategoryID  > 0) primary key,
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
	email VARCHAR(20) NOT NULL,
	StatusLogin VARCHAR(20),
	UserID smallint check(UserID>0),
	PRIMARY KEY (UserID, loginTime),
	FOREIGN KEY (UserID) REFERENCES Users (UserID)
	);


-- Publisher
create table Publisher(
    PublisherID smallint REFERENCES Users(UserID),
    Primary key(PublisherID)
)


-- Recipes
create table Recipes (
    RecipeID smallint check(RecipeID>0),
	publisherID smallint references Publisher(PublisherID),
    Title varchar(20) check(len(Title) >= 0) not null,
    Description varchar(500) check(len(Description) >= 0) not null, 
    TotalTime float check(TotalTime >0) not null,
    UserID smallint references Users(UserID) not null,
    PublicationDate dateTime check(datediff(day,PublicationDate,getdate())>0),
    Primary key(RecipeID)
)

-- Comments
create table Comments (
    UserID smallint references Users(UserID),
    CommentDate dateTime check(datediff(day, CommentDate,getdate())>0),
    Rating tinyint check(Rating between 1 and 5),
	RecipeID smallint references Recipes(RecipeID),
	PRIMARY KEY (UserID, CommentDate)
)

-- RecipesIngredients
create TABLE RecipeIngredient(
RecipeID smallint references Recipes(RecipeID),
IngredientID smallint references Ingredients(IngredientID), 
Amount SMALLINT CHECK(Amount >0 ) , 
Calories SMALLINT CHECK (Calories BETWEEN 1 AND 1000), 
PRIMARY KEY(RecipeID, IngredientID)
)

-- RecipeSubFoodCategories
create table RecipeSubFoodCategories (
    RecipeSubFoodCategoryID SMALLINT PRIMARY KEY,
    RecipeID smallint references Recipes(RecipeID),
    FoodCategoryID smallint references FoodCategories(FoodCategoryID),
    
)



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




DROP PROCEDURE GetUserLoginHistory

 CREATE PROCEDURE GetUserLoginHistory @UserID smallint
 AS
 SELECT L.*
 FROM Log L
 WHERE  L.UserID=@UserID
 GO






