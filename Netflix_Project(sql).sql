CREATE TABLE netflix(
	show_id	VARCHAR(10),
	type	VARCHAR(10),
	title	VARCHAR(150),
	director	VARCHAR(250),
	"cast"	VARCHAR(800),
	country	VARCHAR(150),
	date_added	VARCHAR(20),
	release_year	INT,
	rating	VARCHAR(10),
	duration	VARCHAR(20),
	listed_in	VARCHAR(100),
	description VARCHAR(300)
);

ALTER TABLE public.netflix
ADD PRIMARY KEY (show_id);


-- 1. Count the Number of Movies vs TV Shows
SELECT 
	type,
	COUNT(*) AS nos
FROM public.netflix
GROUP BY 1
ORDER BY 2;


-- 2. Find the Most Common Rating for Movies and TV Shows
WITH Rating_Order AS
	(SELECT
		type,
		rating,
		COUNT(*) AS raing_count
	FROM public.netflix
	GROUP BY 1,2
ORDER BY 3 DESC),
Rating_Rank AS
	(SELECT 
		type,
		rating,
		raing_count,
		RANK() OVER(PARTITION BY type ORDER BY  raing_count DESC) AS rank ------------ WINDOWS
	FROM Rating_Order
)
SELECT 
	type,
	rating,
	rank
FROM Rating_Rank
WHERE rank='1';



-- 3. List All Movies Released in a Specific Year (e.g., 2020)
SELECT * 
FROM netflix
WHERE type='Movie'
	AND 
	release_year='2020'



-- Find the Top 5 Countries with the Most Content on Netflix
SELECT
	TRIM(UNNEST(STRING_TO_ARRAY(country,','))) AS country,
	COUNT(show_id) AS no_of_content
FROM public.netflix
GROUP BY 1
ORDER BY 2 DESC;



--5. Identify the Longest Movie
SELECT  
	title,
	duration
FROM netflix
WHERE type='Movie'
	AND 
	duration IS NOT NULL
ORDER BY SPLIT_PART(duration, ' ',1)::INT DESC ;     --------------- GOOD -------------


-- 6. Find Content Added in the Last 7 Years
SELECT 
	*
FROM netflix
WHERE EXTRACT(YEAR FROM CURRENT_DATE)-TRIM(SPLIT_PART(date_added,',',2))::INT>=7;


-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT * 
FROM netflix
WHERE director='Rajiv Chilaka';


-- 8. List All TV Shows with More Than 5 Seasons
SELECT 
	title,
	type,
	duration
FROM netflix
WHERE type='TV Show'
	AND
	SPLIT_PART(duration,' ',1):: INT >=5
ORDER BY SPLIT_PART(duration,' ',1):: INT DESC; ----------GOOD--------------


-- 9. Count the Number of Content Items in Each Genre
SELECT 
	TRIM(UNNEST (STRING_TO_ARRAY(listed_in, ','))) AS genre,
	COUNT(show_id) AS no_of_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC;

SELECT * FROM public.netflix

-- 10.Find each year and the average numbers of content release in India on netflix.
SELECT	
	release_year,
	ROUND(
		COUNT(CASE WHEN country LIKE '%India%' THEN 1 END)::NUMERIC/COUNT(*)*100,2           ------------------------MIND BLOWN-----------------------
	) AS percentage
FROM public.netflix
	GROUP BY 1                      
	HAVING 
		COUNT(CASE WHEN country LIKE '%India%' THEN 1 END)::NUMERIC 
    / COUNT(*) * 100 > 0;


SELECT * FROM NETFLIX
-- 11. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT 
	catagory,
	COUNT(*)
FROM
	(SELECT 
	CASE
		WHEN description LIKE '%Kill%' OR description LIKE '%Violence%' THEN 'Bad'  ------------SUPERCALifragilisticexpialidocious--------
		ELSE 'Good'
	END AS catagory 
	FROM public.netflix) 
	AS catagorized_content
GROUP BY 1;
	
	