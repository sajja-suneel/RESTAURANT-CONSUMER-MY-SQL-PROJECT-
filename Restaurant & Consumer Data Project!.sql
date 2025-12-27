DROP DATABASE IF EXISTS PROJECT;

CREATE  DATABASE PROJECT ;
USE PROJECT ;
SHOW DATABASES;

CREATE TABLE CONSUMERS (
CONSUMERS_ID VARCHAR (20) PRIMARY KEY,
CITY VARCHAR (50),
STATE VARCHAR (50),
COUNTRY VARCHAR (50),
LATITUDE  DECIMAL(10,2),
LONGITUDE  DECIMAL (10,2),
SMOKER  VARCHAR (10),
DRINK_LEVEL  VARCHAR (30),
TRANSPORTATION_METHOD VARCHAR (50),
MARITAL_STATUS VARCHAR (40), 
CHILDREN  VARCHAR(50),
AGE  INT,
OCCUPATION  VARCHAR(40), 
BUDGET VARCHAR (40)
);
SELECT * FROM CONSUMERS;

-- CREATE CONSUMER_PREFERENCES  TABLE 
CREATE TABLE CONSUMER_PREFERENCES (
CONSUMERS_ID VARCHAR(20),
PREFERRED_CUISINE VARCHAR(40),
FOREIGN KEY (CONSUMERS_ID) REFERENCES CONSUMERS(CONSUMERS_ID)
);

SELECT * FROM CONSUMER_PREFERENCES
LIMIT 10;


-- CREATE  TABLE  RESTAURANTS
CREATE TABLE RESTAURANTS (
RESTAURANT_ID INT PRIMARY KEY,
NAME  VARCHAR (50),
CITY VARCHAR(50),
STATE VARCHAR(50),
COUNTRY VARCHAR (50),
ZIP_CODE INT ,
LATITUDE DECIMAL (10,2),
LONGITUDE DECIMAL (10,2),
ALCOHOL_SERVICE VARCHAR(50),
SMOKING_ALLOWED VARCHAR(50),
PRICE  VARCHAR (50),
FRANCHISE VARCHAR (10),
AREA VARCHAR(20),
PARKING VARCHAR (20)
);

SELECT * FROM RESTAURANTS;
 
 -- CREATE TABLE RESTAURANT_CUISINES
 CREATE TABLE RESTAURANT_CUISINES(
RESTAURANT_ID INT ,
CUISINES  VARCHAR (50),
FOREIGN KEY (RESTAURANT_ID) REFERENCES RESTAURANTS(RESTAURANT_ID)
);

-- CREATE TABLE RATING 

CREATE TABLE RATING (
CONSUMERS_ID VARCHAR (20),
RESTAURANT_ID INT,
OVERALL_RATING INT,
FOOD_RATING INT, 
SERVICE_RATING INT,
FOREIGN KEY (CONSUMERS_ID) REFERENCES CONSUMERS(CONSUMERS_ID),
FOREIGN KEY (RESTAURANT_ID) REFERENCES RESTAURANTS (RESTAURANT_ID)
);


SELECT * FROM CONSUMERS;
SELECT * FROM CONSUMER_PREFERENCES; 
SELECT * FROM RESTAURANTS; 
SELECT * FROM RESTAURANT_CUISINES;
SELECT * FROM RATING;

-- Objective: 
-- Using the WHERE clause to filter data based on specific criteria.
-- 1) List all details of consumers who live in the city of 'List all details of consumers who live in the city of 'Cuernavaca'.

SELECT CONSUMERS_ID,CITY, STATE, COUNTRY,AGE
FROM  CONSUMERS
WHERE CITY ="Cuernavaca";

-- 2) Find the Consumer_ID, Age, and Occupation of all consumers who are 'Students' AND are 'Smokers'.
SELECT CONSUMERS_ID, 
	   AGE,
       OCCUPATION,
       SMOKER
FROM CONSUMERS
WHERE OCCUPATION ="STUDENT" AND SMOKER = "YES";

-- 3) List the Name, City, Alcohol_Service, and Price of all restaurants that serve 'Wine & Beer' and have a 'Medium' price level.

SELECT NAME,
	   CITY,
	   ALCOHOL_SERVICE,
	   PRICE
FROM RESTAURANTS
WHERE ALCOHOL_SERVICE ="WINE & BEER" AND
	  PRICE  = "MEDIUM";
-- 4) Find the names and cities of all restaurants that are part of a 'Franchise'.
 
 SELECT NAME,
        CITY,
        FRANCHISE
FROM RESTAURANTS
WHERE FRANCHISE ="YES";



-- 5)  Show the Consumer_ID, Restaurant_ID, and Overall_Rating for all ratings where the Overall_Rating was 'Highly Satisfactory' (which corresponds to a value of 2, according to the data dictionary).
SELECT CONSUMERS_ID,
       RESTAURANT_ID,
       OVERALL_RATING
FROM RATING
WHERE OVERALL_RATING =2;

-- Questions JOINs with Subqueries
-- 1) List the names and cities of all restaurants that have an Overall_Rating of 2 (Highly Satisfactory) from at least one consumer.
SELECT DISTINCT R.NAME,
       R.CITY,
       RT.OVERALL_RATING
FROM RESTAURANTS R 
JOIN RATING RT
ON R.RESTAURANT_ID= RT.RESTAURANT_ID
WHERE OVERALL_RATING =2; 



-- Find the Consumer_ID and Age of consumers who have rated restaurants located in 'San Luis Potosi'.
SELECT  DISTINCT C.CONSUMERS_ID,
       C.AGE, 
       R.STATE
FROM CONSUMERS  C
JOIN RATING RT 
ON C.CONSUMERS_ID = RT.CONSUMERS_ID
JOIN RESTAURANTS R
  ON RT.RESTAURANT_ID = R.RESTAURANT_ID
WHERE R.STATE = 'San Luis Potosi';

-- 3) List the names of restaurants that serve 'Mexican' cuisine and have been rated by consumer 'U1001'.
SELECT DISTINCT R.NAME 
FROM RATING RT
JOIN RESTAURANTS R 
ON RT.RESTAURANT_ID = R.RESTAURANT_ID
JOIN RESTAURANT_CUISINES RC 
ON R.RESTAURANT_ID = RC.RESTAURANT_ID
WHERE RT.CONSUMERS_ID  ="U1001"
AND RC.CUISINES ="Mexican";



-- 4) Find all details of consumers who prefer 'American' cuisine AND have a 'Medium' budget.
SELECT C.*
FROM CONSUMERS C 
JOIN CONSUMER_PREFERENCES CP
ON C.CONSUMERS_ID = CP.CONSUMERS_ID
WHERE BUDGET  = "MEDIUM"
AND
PREFERRED_CUISINE ="AMERICAN";
 -- 5) List restaurants (Name, City) that have received a Food_Rating lower than the average Food_Rating across all rated restaurants.

SELECT  NAME  AS RESTAURANT_NAME ,
        CITY  AS RESTAURANTS_CITY,
        RA.AVGRATING
FROM  RESTAURANTS R 
JOIN  ( 
SELECT RESTAURANT_ID,  AVG( FOOD_RATING) AS  AVGRATING
FROM RATING
GROUP BY  RESTAURANT_ID
) RA
ON R.RESTAURANT_ID = RA.RESTAURANT_ID
WHERE RA.AVGRATING <
(SELECT AVG(FOOD_RATING) FROM RATING);




-- 6)  Find consumers (Consumer_ID, Age, Occupation) who have rated at least one restaurant but have NOT rated any restaurant that serves 'Italian' cuisine.
SELECT  DISTINCT C.CONSUMERS_ID,
		C.AGE,
        C.OCCUPATION
FROM CONSUMERS C 
JOIN  RATING  RA
ON  C.CONSUMERS_ID = RA.CONSUMERS_ID
WHERE C.CONSUMERS_ID NOT IN (
SELECT RA2.CONSUMERS_ID
FROM RATING RA2
JOIN RESTAURANT_CUISINES RC
ON RA2.RESTAURANT_ID = RC.RESTAURANT_ID
WHERE  CUISINES = "Italian"
);



-- 7) List restaurants (Name) that have received ratings from consumers older than 30.
SELECT R.NAME
FROM  RESTAURANTS R 
JOIN RATING  RA 
ON R.RESTAURANT_ID = RA.RESTAURANT_ID
JOIN CONSUMERS  C
ON RA.CONSUMERS_ID = C.CONSUMERS_ID
WHERE C.AGE >30;

-- 8) Find the Consumer_ID and Occupation of consumers whose preferred cuisine is 'Mexican' and who have given an Overall_Rating of 0 to at least one restaurant 
-- (any restaurant).
SELECT  DISTINCT C.CONSUMERS_ID ,
				C.OCCUPATION,
				CP. PREFERRED_CUISINE
FROM  CONSUMERS C
JOIN CONSUMER_PREFERENCES CP 
ON C.CONSUMERS_ID= CP.CONSUMERS_ID
JOIN RATING  RA 
ON  CP.CONSUMERS_ID= RA.CONSUMERS_ID
WHERE CP.PREFERRED_CUISINE  = "MEXICAN" 
AND RA.OVERALL_RATING  = 0;
 
 -- 9) List the names and cities of restaurants that serve 'Pizzeria' cuisine and are located in a city where at least one 'Student' consumer lives.
SELECT R.NAME,
       R.CITY, 
	   RC.CUISINES
FROM RESTAURANTS R 
JOIN RESTAURANT_CUISINES RC
ON R.RESTAURANT_ID = RC.RESTAURANT_ID
WHERE RC.CUISINES = "Pizzeria"
AND R. CITY IN ( 
SELECT  DISTINCT CITY 
FROM CONSUMERS C
WHERE OCCUPATION = 'STUDENT'
);

-- 10) Find consumers (Consumer_ID, Age) who are 'Social Drinkers' and have rated a restaurant that has 'No' parking
SELECT DISTINCT C.CONSUMERS_ID,
        C.AGE 
FROM CONSUMERS C
JOIN RATING RA
ON C.CONSUMERS_ID = RA.CONSUMERS_ID
JOIN  RESTAURANTS  R 
ON RA.RESTAURANT_ID = R.RESTAURANT_ID
WHERE C.DRINK_LEVEL = "SOCIAL DRINKER"
AND R.PARKING = "NONE";

-- Questions Emphasizing WHERE Clause and Order of Execution
-- 1) List Consumer_IDs and the count of restaurants they've rated, but only for consumers who are 'Students'. Show only students who have rated more than 2 restaurants.

SELECT C.CONSUMERS_ID, COUNT(R.RESTAURANT_ID)AS COUNT_RESTAURANT
FROM CONSUMERS C
JOIN RATING  R 
ON C.CONSUMERS_ID = R.CONSUMERS_ID
WHERE C.OCCUPATION  = 'STUDENT'
GROUP BY C.CONSUMERS_ID
HAVING COUNT(R.RESTAURANT_ID) >2;

-- 2) We want to categorize consumers by an 'Engagement_Score' which is their Age divided by 10 (integer division). List the Consumer_ID, Age, and
--  this calculated Engagement_Score, but only for consumers whose Engagement_Score would be exactly 2 and who use 'Public' transportation.

SELECT CONSUMERS_ID, AGE ,(AGE DIV 10) AS ENGAGEMENT_SCORE
FROM CONSUMERS 
WHERE (AGE DIV 10) =2  
AND TRANSPORTATION_METHOD = "PUBLIC";

-- 3) For each restaurant, calculate its average Overall_Rating. Then, list the restaurant Name, City, and its calculated average Overall_Rating, but only for restaurants located
--  in 'Cuernavaca' AND whose calculated average Overall_Rating is greater than 1.0.
SELECT  R.NAME,
        R.CITY,
        AVG(RA.OVERALL_RATING) AS AVG_OVERALL_RATING
FROM RESTAURANTS R 
JOIN RATING RA 
ON R.RESTAURANT_ID  = RA.RESTAURANT_ID 
WHERE R.CITY  = "Cuernavaca" 
GROUP BY  RA.RESTAURANT_ID,R.NAME, R.CITY
HAVING  AVG(RA.OVERALL_RATING)>1.0;






-- 4)Find consumers (Consumer_ID, Age) who are 'Married' and whose Food_Rating for any restaurant is equal to their Service_Rating for that same restaurant, 
-- but only consider ratings where the Overall_Rating was 2

SELECT  C.CONSUMERS_ID,
        C.AGE,
        C.MARITAL_STATUS
FROM CONSUMERS C
JOIN RATING RA 
ON C.CONSUMERS_ID =RA.CONSUMERS_ID
WHERE MARITAL_STATUS  ="MARRIED"
AND  OVERALL_RATING= 2
AND FOOD_RATING = SERVICE_RATING ;

-- 5) List Consumer_ID, Age, and the Name of any restaurant they rated, but only for consumers who are 'Employed' and have given a Food_Rating of 0 to at least 
--  one restaurant located in 'Ciudad Victoria'.


SELECT C.CONSUMERS_ID,
	C.CITY,
    C.AGE,
    R.NAME
FROM  CONSUMERS C 
JOIN RATING  RA
ON C.CONSUMERS_ID = RA.CONSUMERS_ID
JOIN RESTAURANTS R
ON RA.RESTAURANT_ID = R.RESTAURANT_ID
WHERE C.OCCUPATION  = "EMPLOYED"
AND  RA.FOOD_RATING   = 0
AND  R.CITY  = "CIUDAD VICTORIA";

-- Advanced SQL Concepts: Derived Tables, CTEs, Window Functions, Views, Stored Procedures
-- 1)Using a CTE, find all consumers who live in 'San Luis Potosi'. Then, list their Consumer_ID, Age, and the Name of any Mexican restaurant they have rated with an 
-- Overall_Rating of 2.
WITH CTE AS (
    SELECT CONSUMERS_ID, 
           AGE
    FROM CONSUMERS 
    WHERE CITY = 'SAN LUIS POTOSÍ')
SELECT CTE.CONSUMERS_ID, 
    CTE.AGE, 
    R.NAME
FROM CTE 
JOIN RATING RTG 
ON CTE.CONSUMERS_ID = RTG.CONSUMERS_ID
JOIN RESTAURANTS R 
ON RTG.RESTAURANT_ID = R.RESTAURANT_ID
JOIN RESTAURANT_CUISINES RC 
ON R.RESTAURANT_ID = RC.RESTAURANT_ID
WHERE RC.CUISINES = 'MEXICAN' 
AND RTG.OVERALL_RATING = 2;       


-- 2)For each Occupation, find the average age of consumers. Only consider consumers who have made at least one rating. (Use a derived table to get consumers who have rated).

SELECT distinct(C.OCCUPATION) ,AVG(C.AGE)
FROM CONSUMERS C 
JOIN RATING RA 
ON C.CONSUMERS_ID=RA.CONSUMERS_ID
WHERE RA.OVERALL_RATING<1
GROUP BY C.OCCUPATION ;
-- 3)Using a CTE to get all ratings for restaurants in 'Cuernavaca', rank these ratings within each restaurant based 
-- on Overall_Rating (highest first). Display Restaurant_ID, Consumer_ID, Overall_Rating, and the RatingRank                                                                  

WITH CTE AS (
    SELECT R.RESTAURANT_ID,
           RTG.CONSUMERS_ID,
           RTG.OVERALL_RATING
    FROM RESTAURANTS R
    JOIN RATING RTG
      ON R.RESTAURANT_ID = RTG.RESTAURANT_ID
    WHERE R.CITY = 'Cuernavaca'
)
SELECT RESTAURANT_ID,
       CONSUMERS_ID,
       OVERALL_RATING,
       RANK() OVER (
           PARTITION BY RESTAURANT_ID
           ORDER BY OVERALL_RATING DESC
       ) AS RatingRank
FROM CTE;

-- 5) Using a CTE, identify students who have a 'Low' budget. Then, for each of these students, list their top 3 most preferred cuisines based on the order they appear in the Consumer_Preferences table
--  (assuming no explicit preference order, use Consumer_ID, Preferred_Cuisine to define order for ROW_NUMBER).


WITH StudentBudget AS (
    -- Step 1: Filter for students with a 'Low' budget using your column names
    SELECT 
        CONSUMERS_ID, 
        OCCUPATION, 
        BUDGET
    FROM CONSUMERS
    WHERE OCCUPATION = 'Student' 
      AND BUDGET = 'Low'
),
RankedPreferences AS (
    -- Step 2: Rank the preferred cuisines per student
    -- Using ROW_NUMBER() ensures we get exactly 3 per person
    SELECT 
        sb.CONSUMERS_ID,
        sb.OCCUPATION,
        sb.BUDGET,
        cp.PREFERRED_CUISINE,
        ROW_NUMBER() OVER(
            PARTITION BY sb.CONSUMERS_ID 
            ORDER BY cp.PREFERRED_CUISINE ASC
        ) as Preference_Rank
    FROM StudentBudget sb
    JOIN CONSUMER_PREFERENCES cp ON sb.CONSUMERS_ID = cp.CONSUMERS_ID
)
-- Step 3: Filter the final list for the top 3
SELECT 
    CONSUMERS_ID,
    OCCUPATION,
    BUDGET,
    PREFERRED_CUISINE
FROM RankedPreferences
WHERE Preference_Rank <= 3;

-- 6)Consider all ratings made by 'Consumer_ID' = 'U1008'. For each rating, show the Restaurant_ID, Overall_Rating, and the Overall_Rating of the next restaurant they rated 
-- (if any), ordered by Restaurant_ID (as a proxy for time if rating time isn't available). Use a derived table to filter for the consumer's ratings first.

SELECT 
    dt.RESTAURANT_ID, 
    dt.OVERALL_RATING,
    -- LEAD looks at the OVERALL_RATING of the next row
    LEAD(dt.OVERALL_RATING) OVER (ORDER BY dt.RESTAURANT_ID) AS Next_Overall_Rating
FROM (
    -- Derived Table: Filters specifically for 'U1008' ratings
    SELECT 
        RESTAURANT_ID, 
        OVERALL_RATING
    FROM RATING
    WHERE CONSUMERS_ID = 'U1008'
) AS dt
ORDER BY dt.RESTAURANT_ID;

-- 7)Create a VIEW named HighlyRatedMexicanRestaurants that shows the Restaurant_ID, Name, and City of all Mexican restaurants 
-- that have an average Overall_Rating greater than 1.5.
CREATE VIEW HIGHLYRATEDMEXICANRESTAURANTS AS 
SELECT 
    R.RESTAURANT_ID,
    R.NAME,
    R.CITY
FROM RESTAURANTS R
JOIN RESTAURANT_CUISINES RC 
ON R.RESTAURANT_ID = RC.RESTAURANT_ID
JOIN RATING RA 
ON RC.RESTAURANT_ID = RA.RESTAURANT_ID
WHERE RC.CUISINES = 'Mexican'
GROUP BY R.RESTAURANT_ID, R.NAME, R.CITY
HAVING AVG(RA.OVERALL_RATING) >1.5;
SELECT * FROM HIGHLYRATEDMEXICANRESTAURANTS;


-- First, ensure the HighlyRatedMexicanRestaurants view from Q7 exists. Then, using a CTE to find consumers who prefer 'Mexican' cuisine, list those consumers (Consumer_ID) 
-- who have not rated any restaurant listed in the HighlyRatedMexicanRestaurants view.

WITH PREFER_MEXICAN
AS(
SELECT CONSUMERS_ID,
PREFERRED_CUISINE
FROM CONSUMER_PREFERENCES
WHERE PREFERRED_CUISINE="MEXICAN")
SELECT P.CONSUMERS_ID
FROM PREFER_MEXICAN P
WHERE P.CONSUMERS_ID NOT IN (
SELECT DISTINCT RT.CONSUMERS_ID
FROM RATING RT 
JOIN HIGHLYRATEDMEXICANRESTAURANTS HG
ON RT.RESTAURANT_ID=HG.RESTAURANT_ID);


-- 9)  Create a stored procedure GetRestaurantRatingsAboveThreshold that accepts a Restaurant_ID and a minimum Overall_Rating as input. 
-- It should return the Consumer_ID, Overall_Rating, Food_Rating, and Service_Rating for that restaurant where the Overall_Rating meets or exceeds the threshold.
DELIMITER //
CREATE PROCEDURE NEWPROC(
IN N_RESTAURANT_ID INT,
IN N_MINIMUM_OVERALL_RATING FLOAT)
BEGIN
SELECT CONSUMERS_ID,
OVERALL_RATING,
FOOD_RATING,
SERVICE_RATING
FROM RATING R
WHERE R.RESTAURANT_ID=N_RESTAURANT_ID
AND R.OVERALL_RATING>=N_MINIMUM_OVERALL_RATING;
END //
DELIMITER ;
CALL NEWPROC(135085,1.0);

-- 10) Identify the top 2 highest-rated (by Overall_Rating) restaurants for each cuisine type. If there are ties in rating, include all tied restaurants.
--  Display Cuisine, Restaurant_Name, City, and Overall_Rating.

WITH CuisineRatings AS (                                              -- Step 1: Calculate the average rating for every restaurant
    SELECT rc.CUISINES,rs.NAME AS Restaurant_Name,rs.CITY,
        AVG(rtg.OVERALL_RATING) AS Avg_Overall_Rating
    FROM RESTAURANTS rs
    JOIN RESTAURANT_CUISINES rc ON rs.RESTAURANT_ID = rc.RESTAURANT_ID
    JOIN RATING rtg ON rs.RESTAURANT_ID = rtg.RESTAURANT_ID
    GROUP BY rc.CUISINES, rs.NAME, rs.CITY),
RankedCuisines AS (                                     
SELECT CUISINES,Restaurant_Name,CITY,Avg_Overall_Rating,                  -- Step 2: Rank restaurants within each cuisine group
        DENSE_RANK() OVER(
            PARTITION BY CUISINES 
            ORDER BY Avg_Overall_Rating DESC
        ) as Rating_Rank
    FROM CuisineRatings
)                                                            
SELECT CUISINES,Restaurant_Name, CITY, Avg_Overall_Rating                   -- Step 3: Select the top 2 ranks (including ties)
FROM RankedCuisines
WHERE Rating_Rank <= 2
ORDER BY CUISINES, Rating_Rank;

-- 11) First, create a VIEW named ConsumerAverageRatings that lists Consumer_ID and their average Overall_Rating. Then, using this view and a CTE, find the top 5 consumers by 
-- their average overall rating. For these top 5 consumers, list their Consumer_ID, their average rating, and the number of 'Mexican' restaurants they have rated.
CREATE VIEW ConsumerAverageRatings AS
SELECT CONSUMERS_ID, AVG(OVERALL_RATING) AS Avg_Rating
FROM RATING
GROUP BY CONSUMERS_ID;
WITH TopConsumers AS (
     SELECT CONSUMERS_ID, Avg_Rating       -- Get the top 5 consumers from the view
    FROM ConsumerAverageRatings
    ORDER BY Avg_Rating DESC
    LIMIT 5
)
SELECT tc.CONSUMERS_ID, tc.Avg_Rating,
    COUNT(rc.CUISINES) AS Mexican_Restaurants_Rated
FROM TopConsumers tc
LEFT JOIN RATING rtg 
ON tc.CONSUMERS_ID = rtg.CONSUMERS_ID
LEFT JOIN RESTAURANT_CUISINES rc 
ON rtg.RESTAURANT_ID = rc.RESTAURANT_ID 
AND rc.CUISINES = 'Mexican'
GROUP BY tc.CONSUMERS_ID, tc.Avg_Rating
ORDER BY tc.Avg_Rating DESC;


-- 12) Create a stored procedure named GetConsumerSegmentAndRestaurantPerformance that accepts a Consumer_ID as input.
-- The procedure should:
-- Determine the consumer's "Spending Segment" based on their Budget:
-- 'Low' -> 'Budget Conscious'
-- 'Medium' -> 'Moderate Spender'
-- 'High' -> 'Premium Spender'
-- NULL or other -> 'Unknown Budget'
-- For all restaurants rated by this consumer:
-- List the Restaurant_Name.
-- The Overall_Rating given by this consumer.
-- The average Overall_Rating this restaurant has received from all consumers (not just the input consumer).
-- A "Performance_Flag" indicating if the input consumer's rating for that restaurant is 'Above Average', 'At Average', or 'Below Average' compared to the restaurant's 
-- overall average rating.
-- Rank these restaurants for the input consumer based on the Overall_Rating they gave (highest rating = rank 1).

DELIMITER //

CREATE PROCEDURE GetConsumerSegmentAndRestaurantPerformance(IN input_consumer_id VARCHAR(20))
BEGIN
    -- 1. Create a CTE to identify the consumer's budget segment
    WITH ConsumerBudget AS (
        SELECT 
            CONSUMERS_ID,
            CASE BUDGET
                WHEN 'Low' THEN 'Budget Conscious'
                WHEN 'Medium' THEN 'Moderate Spender'
                WHEN 'High' THEN 'Premium Spender'
                ELSE 'Unknown Budget'
            END AS Spending_Segment
        FROM CONSUMERS
        WHERE CONSUMERS_ID = input_consumer_id
    ),
    -- 2. Create a CTE to pre-calculate average ratings for ALL restaurants
    GlobalRestaurantAvg AS (
        SELECT 
            RESTAURANT_ID, 
            AVG(OVERALL_RATING) AS Global_Avg
        FROM RATING
        GROUP BY RESTAURANT_ID
    )
    -- 3. Final selection combining segment, consumer rating, and performance flags
    SELECT 
        cb.Spending_Segment,
        res.NAME AS Restaurant_Name,
        rtg.OVERALL_RATING AS My_Rating,
        gra.Global_Avg AS Restaurant_Global_Avg,
        CASE 
            WHEN rtg.OVERALL_RATING > gra.Global_Avg THEN 'Above Average'
            WHEN rtg.OVERALL_RATING = gra.Global_Avg THEN 'At Average'
            ELSE 'Below Average'
        END AS Performance_Flag,
        RANK() OVER(ORDER BY rtg.OVERALL_RATING DESC) AS My_Rating_Rank
    FROM RATING rtg
    JOIN ConsumerBudget cb ON rtg.CONSUMERS_ID = cb.CONSUMERS_ID
    JOIN RESTAURANTS res ON rtg.RESTAURANT_ID = res.RESTAURANT_ID
    JOIN GlobalRestaurantAvg gra ON rtg.RESTAURANT_ID = gra.RESTAURANT_ID
    WHERE rtg.CONSUMERS_ID = input_consumer_id;

END //

DELIMITER ;
CALL GetConsumerSegmentAndRestaurantPerformance('U1008');











