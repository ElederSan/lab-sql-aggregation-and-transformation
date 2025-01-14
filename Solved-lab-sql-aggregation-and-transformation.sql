USE sakila;
/* 1.You need to use SQL built-in functions to gain insights relating to the duration of movies:
 1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
 
 1.2. Express the average movie duration in hours and minutes. Don't use decimals. Hint: Look for floor and round functions.
 
*/

SELECT MAX(length) AS "max_duration", MIN(length) AS "min_duration" FROM sakila.film;

SELECT ROUND(AVG(length/60)) AS "avg_length_hours", FLOOR(AVG(length)) AS "avg_length_min" FROM sakila.film; -- used floor() for the sake of practising another method

/*2. You need to gain insights related to rental dates:

2.1 Calculate the number of days that the company has been operating.
Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in the rental_date column from the latest date.
2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.
2.3 Bonus: Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week.
Hint: use a conditional expression.
 
*/
-- 2.1 --
SELECT MAX(rental_date) AS "max_rental_date",MIN(rental_date) AS "min_rental_date",
DATEDIFF(MAX(rental_date), MIN(rental_date)) AS "operation_days" 
FROM sakila.rental;
-- 2.2 --
SELECT *,MONTH(rental_date) AS "rental_month", dayofweek(rental_date) AS "day_of_week" FROM sakila.rental LIMIT 20;
-- 2.3 --
SELECT *,MONTH(rental_date) AS "rental_month", dayofweek(rental_date) AS "day_of_week",
CASE
WHEN dayofweek(rental_date) BETWEEN 1 AND 5 THEN 'workday'
WHEN dayofweek(rental_date) = 6 OR 7 THEN "weekend"
END AS 'day_type'
FROM sakila.rental;

/*3.You need to ensure that customers can easily access information about the movie collection. To achieve this, retrieve the film titles and their rental duration. If any rental duration value is NULL, replace it with the string 'Not Available'. Sort the results of the film title in ascending order.

Please note that even if there are currently no null values in the rental duration column, the query should still be written to handle such cases in the future.
Hint: Look for the IFNULL() function.
 
*/
SELECT title, IFNULL(rental_duration,"Not Available") AS "rental_duration_no_null" FROM sakila.film ORDER BY title;

/* 4 Bonus: The marketing team for the movie rental company now needs to create a personalized email campaign for customers. 
To achieve this, you need to retrieve the concatenated first and last names of customers, along with the first 3 characters of their email address, so that you can address them by their first name and use their email address to send personalized recommendations. 
The results should be ordered by last name in ascending order to make it easier to use the data.
*/
-- with full name and email first 3 splitted into 2 columns sorted by last_name
SELECT customer_id,CONCAT(first_name," ",last_name) AS "full_name",left(email,3) AS "email_first3" FROM sakila.customer ORDER BY last_name;

-- with full name and email first 3 into 1 column, sorted by last_name
SELECT customer_id,CONCAT(first_name," ",last_name," ",left(email,3)) AS "email_first3" FROM sakila.customer ORDER BY last_name;
-- Challenge 2 -- 

/* 1. Next, you need to analyze the films in the collection to gain some more insights. Using the film table, determine:
	1.1 The total number of films that have been released.
	1.2 The number of films for each rating.
	1.3 The number of films for each rating, sorting the results in descending order of the number of films. 
    This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.
*/

-- 1.1 --
SELECT count(distinct(film_id)) AS "released_film_number"  FROM sakila.film;
-- OR --
SELECT count(distinct(title)) AS "released_film_number"  FROM sakila.film;

-- 1.2--

SELECT rating,count(distinct(film_id)) AS "rating_count"
FROM sakila.film
GROUP BY rating;

-- 1.3 --

SELECT rating,count(distinct(film_id)) AS "rating_count"
FROM sakila.film
GROUP BY rating
ORDER BY rating_count DESC;

/* 2. Using the film table, determine:
	2.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. 
    Round off the average lengths to two decimal places. This will help identify popular movie lengths for each category.
	2.2 Identify which ratings have a mean duration of over two hours in order to help select films for customers who prefer longer movies.
	Bonus: determine which last names are not repeated in the table actor.
*/

-- 2.1 --
SELECT rating,ROUND(AVG(length),2) AS "avg_length_min"
FROM sakila.film
GROUP BY rating
ORDER BY avg_length_min DESC;

-- 2.2--
SELECT rating,ROUND(AVG(length),2) AS "avg_length_min"
FROM sakila.film
GROUP BY rating
HAVING avg_length_min > 120
ORDER BY avg_length_min DESC;

-- OR --

SELECT rating,ROUND(AVG(length),2) AS "avg_length_min",ROUND(AVG(length)/60,2) AS "avg_length_hrs"
FROM sakila.film
GROUP BY rating
HAVING avg_length_hrs > 2
ORDER BY avg_length_hrs DESC;

-- Bonus --

SELECT * FROM sakila.actor;

SELECT last_name, count(distinct(actor_id)) AS "last_name_occurrences" FROM sakila.actor
GROUP BY last_name
HAVING last_name_occurrences = 1;
