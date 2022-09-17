SELECT R.RecipeID, R.PublisherID,R.SubFoodCategoryID, FC.FoodCategoryID, FC.FoodCategoryName,
CASE R.Level
WHEN 'Easy' THEN 'For beginner'
WHEN 'Medium' THEN 'Intermediate Level'
WHEN 'Hard' THEN 'Experimented only'
END AS level
FROM dbo.Recipes AS R INNER JOIN dbo.RecipeSubFoodCategories AS RSFC
ON R.SubFoodCategoryID = RSFC.RecipeSubFoodCategoryID INNER JOIN dbo.FoodCategories AS FC
ON FC.FoodCategoryID = RSFC.FoodCategoryID
WHERE R.PublisherID IS NOT NULL AND (MONTH(R.PublicationDate) = 3)

--2
SELECT I.IngredientID, I.IngredientName
FROM dbo.Ingredients AS I
EXCEPT
SELECT RI.IngredientID, I.IngredientName
FROM dbo.RecipeIngredient AS RI left OUTER JOIN dbo.Ingredients AS I ON I.IngredientID = RI.IngredientID
--3
select U.UserID, U.Gender, (select cityName from city where U.CityNum = city.CityNum) as city
from Users as U
where UserID not in (
select PublisherID
from Publisher)

--Query 1 : Publisher that published recipes in the last 30 months
create or alter view ActivePublisher as
select count(R.RecipeID) as NumberOfRecipes, P.FirstName + ' ' + P.LastName as fullName, P.PublisherID
from Publisher as P inner join Recipes as R
on P.PublisherID = R.PublisherID
where DATEDIFF(month,R.PublicationDate ,getdate() ) < 30
group by P.FirstName, P.LastName, P.PublisherID

-- Query 2: Bring the Publisher city for the publisher that published in the last 30 months
create or alter view CityPublisher as
select C.CityName, AP.fullName, AP.PublisherID
from ActivePublisher as AP inner join Users as U
on AP.PublisherID = U.UserID inner join City as C
on U.CityNum = C.CityNum
group by C.CityName, AP.fullName, AP.PublisherID

--Query 3 : Bring all recipes with their type and their level
create or alter view RecipeStatistics as
select count(R.recipeID) as NumberOfRecipes, R.Level, R.Type
from Recipes as R
group by R.Level, R.Type

--Query 4 : Bring all recipes with their grade
create or alter view RecipeGrades as
select count(R.recipeID) as NumberOfRecipes, C.Rating, R.Type
from Recipes as R inner join Comments as C
on R.RecipeID = C.RecipeID
group by C.Rating, R.Type


--Function that return single value
--Function that count for each publisher how many Recipes he published
create or alter function BestPublisher (@P_ID int)
returns real
as begin
declare @amount real
select @amount = COUNT(@P_ID)
from Publisher as P inner join Recipes as R
on P.PublisherID = R.PublisherID
where P.PublisherID = @P_ID
return @amount
end
go
--Calling the function from the select part
select P.PublisherID, P.FirstName, P.LastName,
Amount =dbo.BestPublisher(P.PublisherID)
from Publisher as P

-- Function that receive ID of one of the Publishers that exist in the system and return statistics for recipes according to the combination of the elements(Type and Level) ➔ for example, num of Recipes that are DESSERT and HARD.
create or alter function StatsUsers (@ID int)
returns table
as return
select P.FirstName , P.LastName, count(R.recipeID) as NumberOfRecipes, R.Level, R.Type
from Recipes as R inner join Publisher as P
on R.PublisherID = P.PublisherID
where R.PublisherID = @ID
group by R.Level, R.Type , P.FirstName, P.LastName
go
--Calling the function with specific ID
select *
from dbo.StatsUsers(123)
go