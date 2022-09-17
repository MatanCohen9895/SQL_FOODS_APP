use Food
go



create or alter procedure GetStoredProc

@TypeOfRecipe VARCHAR(10),
@LevelOfRecipe VARCHAR(10)
as 
BEGIN
SET NOCOUNT ON
SET ANSI_WARNINGS OFF

IF((@TypeOfRecipe IS NULL OR @TypeOfRecipe = '') AND (@LevelOfRecipe IS NULL OR @LevelOfRecipe = ''))
	BEGIN
		select R.PublisherID, R.Description,R.Type, R.Level
		from Recipes as R
		where R.PublisherID IS NOT NULL
	END

ELSE IF(@TypeOfRecipe IS NULL OR @TypeOfRecipe = '')
	BEGIN
		select R.PublisherID, R.Description,R.Type, R.Level
		from Recipes as R
		where R.Level = @LevelOfRecipe AND R.PublisherID IS NOT NULL
	END
ELSE IF(@LevelOfRecipe IS NULL OR @LevelOfRecipe = '')
	BEGIN
		select R.PublisherID, R.Description,R.Type, R.Level
		from Recipes as R
		where R.Type = @TypeOfRecipe AND R.PublisherID IS NOT NULL
	END
ELSE
	BEGIN
		select R.PublisherID, R.Description,R.Type, R.Level
		from Recipes as R
		where R.Type = @TypeOfRecipe AND R.Level = @LevelOfRecipe AND R.PublisherID IS NOT NULL
	END
END
go

select distinct Type from Recipes


exec GetStoredProc '', ''

create or alter procedure BringDataOnUser
@ID smallint
as 
BEGIN
	SELECT * 
	FROM Publisher 
	WHERE Publisher.PublisherID = @ID
END

exec BringDataOnUser 123