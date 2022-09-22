USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select count(id) from names;
-- total rows in names table is '25735'.

select count(movie_id) from director_mapping;
-- total rows in director_mapping table is '3867'.

select count(movie_id) from role_mapping;
-- total rows in role_mapping table is '15615'

select count(id) from movie;
-- total rows in movie table is '7997'

select count(movie_id) from genre;
-- total rows in genre table is '14662'

select count(movie_id) from ratings;
-- total rows in ratings table is '7997'




-- Q2. Which columns in the movie table have null values?
-- Type your code below:
select * from movie ;

select sum(case when id is null then 1 else 0 end) as id_null,
sum(case when title is null then 1 else 0 end) as title_null,
sum(case when year is null then 1 else 0 end) as year_null,
sum(case when date_published is null then 1 else 0 end) as date_published_null,
sum(case when duration is null then 1 else 0 end) as duration_null,
sum(case when country is null then 1 else 0 end) as country_null,
sum(case when worlwide_gross_income is null then 1 else 0 end) as worlwide_gross_income_null,
sum(case when languages is null then 1 else 0 end) as languages_null,
sum(case when production_company is null then 1 else 0 end) as production_company_null 
from movie;

/* The columns country, worlwide_gross_income, languages and production_company 
    are having null values
    */







-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT 
    YEAR(date_published) AS year, COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY year;
-- answer 

-- year  no_of_movies
-- 2017	    3052
-- 2018	    2944
-- 2019	    2001


SELECT 
    MONTH(date_published) AS month,
    COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY MONTH(date_published);

-- answer
/* 
 month   no_of_movies
  1	        804
  2	        640
  3	        824
  4	        680
  5	        625
  6	        580
  7			493
  8			678
  9			809
 10			801
 11			625
 12			438
*/






/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:


SELECT Count(DISTINCT id) AS total_movies, year
FROM movie
WHERE ( country LIKE '%INDIA%'
OR country LIKE '%USA%' )
AND year = 2019;

-- there are total 1059 movies produces from india and usa.


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select distinct genre from genre;

-- there are 13 generes in genre column.








/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
    genre, COUNT(m.id) AS total_count
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY genre
ORDER BY COUNT(m.id) DESC;

-- drama genre has the highest number of movies = 4285 movies. 






/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


CREATE VIEW count_genre AS
    SELECT 
        movie_id, COUNT(genre) AS total_genre_count
    FROM
        genre
    GROUP BY movie_id
    HAVING COUNT(genre) = 1
    ORDER BY COUNT(genre) DESC;

SELECT 
    COUNT(movie_id)
FROM
    count_genre;

-- There are total 3289 movies with single genre.






/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    genre, ROUND(AVG(duration),2) AS avg_duration
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY genre
ORDER BY AVG(duration) DESC;
 
 -- action genre has the highest avg duration = 112.88








/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select genre, count(movie_id) as movie_count,
 rank() over(order by count(movie_id) desc)  as genre_rank
 from genre group by genre order by count(movie_id) desc;
 
-- thriller genre is in 3rd rank in number in movies count.








/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

 select name,n.id,max(avg_rating),total_votes from ratings r 
  left outer join names n on r.movie_id = n.id;
  -- movie id *'tt0012494' has the max avg_rating = 10.
  
  select name,r.movie_id,max(total_votes) from ratings r 
  left outer join names n on r.movie_id = n.id;
-- -- movie id *'tt0012494' has the max total_votes = 725138.



-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings;





    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

select title,avg_rating, dense_rank() over (order by avg_rating desc) as movie_rank
 from movie m inner join ratings r on m.id= r.movie_id 
  order by avg_rating desc limit 10;
  
  -- title kirket and love in kilnerry has highest avg_rating = 10.







/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

select median_rating,count(movie_id) as movie_count from ratings
 group by median_rating order by count(movie_id) desc;

-- the median_rating 7 has the highest number of movies = 2257.
 



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company,count(m.id) as movie_count,dense_rank() over(order by count(m.id) desc) as prod_company_rank
 from movie m inner join ratings r on m.id=r.movie_id
 where avg_rating>8 and production_company is not null
 group by production_company;

/* the 'Dream Warrior Pictures' and 'National Theatre Live' has produced most 
 number of hit movies = 3 movies.
 */





-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    genre, COUNT(m.id) AS movie_count
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
        INNER JOIN
    ratings r ON g.movie_id = r.movie_id
WHERE
    YEAR(date_published) = 2017
        AND MONTH(date_published) = 3
        AND country LIKE '%usa%'
        AND total_votes > 1000
GROUP BY genre
ORDER BY COUNT(m.id) DESC;

-- drama genre has the most number of movie_counts = 24 




-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    title, avg_rating, genre
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
        INNER JOIN
    genre g ON r.movie_id = g.movie_id
WHERE
    title LIKE 'the%' AND avg_rating > 8
GROUP BY title
ORDER BY avg_rating DESC;





/* result.........

 the title 'The Brighton Miracle' with genre 
 drama has highest avg_rating = 9.5
 */


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
SELECT 
    title, median_rating, genre
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
        INNER JOIN
    genre g ON r.movie_id = g.movie_id
WHERE
    title LIKE 'the%' AND avg_rating > 8
GROUP BY title
ORDER BY median_rating DESC;

-- the median_rating is not giving much specific answer because their are 4 movies with median_rating 10.


-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
    COUNT(m.id) AS total_movie, median_rating
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    date_published >= '2018-04-01'
        AND date_published <= '2019-04-01'
        AND median_rating = 8
GROUP BY median_rating;



-- there are total 361 movies realesed between 2018-04-01 and 2019-04-01 with median_rating = 8. 
-- Once again, try to solve the problem given below.

-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
    SUM(total_votes) AS total_votes, country
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    country in ('germany','italy')
GROUP BY country
ORDER BY total_votes DESC;

-- germany has the highest number of votes ('106710') than italy ('77965').


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
select * from names;

 select count(id) from names where height is null;
  -- height has 17335 null values.
  
 select count(id) from names where name is null; 
-- name has 0  null values.

 select count(id) from names where date_of_birth is null;
-- date_of_birth has 13431 null values.

 select count(id) from names where known_for_movies is null;
-- known_for movies has 15226 null values.


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:



 
 WITH top_genre
AS
(
SELECT
g.genre,
COUNT(g.movie_id) as movie_count
FROM genre g
INNER JOIN ratings r
ON g.movie_id = r.movie_id
WHERE avg_rating>8
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 3
),
top_director
AS
(
SELECT
n.name as director_name,
COUNT(d.movie_id) as movie_count,
RANK() OVER(ORDER BY COUNT(d.movie_id) DESC) director_rank
FROM names n
INNER JOIN director_mapping d
ON n.id = d.name_id
INNER JOIN ratings r
ON r.movie_id = d.movie_id
INNER JOIN genre g
ON g.movie_id = d.movie_id,
top_genre
WHERE r.avg_rating > 8 AND g.genre IN (top_genre.genre)
GROUP BY n.name
ORDER BY movie_count DESC
)
SELECT director_name,
movie_count
FROM top_director
WHERE director_rank <= 3
LIMIT 3;

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+ovies plans to partner with other global production houses. 

| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name as actor_name , COUNT(r.movie_id) as movie_count
FROM names as n
INNER JOIN role_mapping as rm ON n.id = rm.name_id
INNER JOIN movie as m ON m.id = rm.movie_id
INNER JOIN ratings as r ON m.id = r.movie_id
WHERE r.median_rating >= 8 
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;

-- 'Mammootty' AND 'Mohanlal' are the top two directors with median rating >= 8.
 

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP MLet’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company,sum(total_votes) as vote_count,
rank() over(order by sum(total_votes) desc ) as prod_comp_rank
from ratings r inner join movie m on r.movie_id = m.id
group by production_company order by sum(total_votes) desc limit 3; 

-- Marvel Studios,Twentieth Century Fox,Warner Bros. are the top three production_comoany.







/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select name as actor_name,total_votes,count(r.movie_id) as movie_count,
round(sum(avg_rating * total_votes)/ sum(total_votes),2) as actor_avg_rating,
rank() over(order by round(sum(avg_rating * total_votes)/ sum(total_votes),2)desc) as actor_rank
 from ratings r inner join role_mapping ro on r.movie_id = ro.movie_id
 inner join names n on ro.name_id = n.id
 inner join movie m on r.movie_id = m.id 
 where country = 'india' and category = 'actor'
 group by name having count(r.movie_id)  >= 5 order by actor_rank;
 

 

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select name,total_votes,count(r.movie_id) as movie_count,
round(sum(avg_rating * total_votes) / sum(total_votes),2) as actress_avg_rating,
 rank() over(order by  round(sum(avg_rating * total_votes) / sum(total_votes),2) desc) 
 as actress_rank
 from names n inner join 
 role_mapping ro on n.id = ro.name_id
 inner join movie m on ro.movie_id = m.id
 inner join ratings r on m.id = r.movie_id
 where country= 'india' and languages like '%hindi%' and category ='actress'
 group by name having count(r.movie_id)>=3 order by actress_rank limit 5;

-- tapsee pannu has rank 1. 






/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

-- select  from genre where genre = 'thriller';

select title, avg_rating,
case 
when avg_rating > 8 then 'Superhit movies' 
when avg_rating between 7 and 8 then 'Hit movies' 
when avg_rating between 5 and 7 then 'One-time-watch movies' 
when avg_rating < 5 then 'Flop movies'
 end as category
 from genre g 
 inner join ratings r on g.movie_id = r.movie_id
 inner join movie m on r.movie_id = m.id
 where genre = 'thriller';






/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select genre,round(avg(duration),2) as avg_duration,
round(sum(avg(duration)) over(order by genre ROWS UNBOUNDED PRECEDING),2)
 as running_total_duration,
round(avg(duration) over (order by  genre ROWS 10 PRECEDING),2) as moving_avg_duration
from genre g inner join movie m 
on g.movie_id = m.id group by genre;







-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top3_genre
AS
(
SELECT
genre,
COUNT(movie_id) as movie_count
FROM genre
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 3
),
top5_movie
AS
(
SELECT
genre,
YEAR,
title as movie_name,
worlwide_gross_income,
RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
WHERE genre IN(SELECT genre FROM top3_genre)
)
SELECT *
FROM top5_movie
WHERE movie_rank<=5;







-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company, count(id) as movie_count,
rank() over (order by count(id)desc )as prod_comp_rank from movie m inner join 
ratings r on m.id = r.movie_id
where median_rating >= 8 and production_company is not null
AND POSITION(',' IN languages)>0
group by (production_company) order by count(id) desc limit 2;

 -- star cinema and twentieth century fox are the top two movies among multilingual movies.




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select name as actress_name,sum(total_votes) as total_votes,count(r.movie_id) as movie_count,avg(avg_rating),
dense_rank() over(order by count(r.movie_id) desc) as actress_rank
 from ratings r inner join
role_mapping ro on r.movie_id = ro.movie_id
inner join names n on ro.name_id = n.id 
inner join genre g on r.movie_id = g.movie_id
where category = 'actress' and avg_rating>8 and genre = 'drama'
group by name order by count(r.movie_id) desc limit 3 ;

-- Parvathy Thiruvothu, Susan Brown, Amanda Lawrence are the top three actrees whose avg_rating>8



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

 
 WITH date_published AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       director_mapping                                                                      AS d
           INNER JOIN names                                                                                 AS n
           ON         n.id = d.name_id
           INNER JOIN movie AS m
           ON         m.id = d.movie_id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id ),
           top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   date_published )
SELECT   name_id                       AS director_id,
         NAME                          AS director_name,
         Count(movie_id)               AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2)               AS avg_rating,
         Sum(total_votes)              AS total_votes,
         Min(avg_rating)               AS min_rating,
         Max(avg_rating)               AS max_rating,
         Sum(duration)                 AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;

-- Andrew jones is in top of the rank.