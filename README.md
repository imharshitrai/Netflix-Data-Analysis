# Netflix Movies and TV Shows Data Analysis using SQL

![image alt](https://github.com/Praneshar-bit/Netflix_Project-_sql-/blob/a2633ea0fe4a6e6bac823ded995225eb89c70048/Netflix_logo.jpg)

# Netflix_Project-_sql-

### Project Overview

This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

### Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

### Schema
```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

1. **Count the Number of Movies vs TV Shows**:
```sql
SELECT 
	type,
	COUNT(*) AS nos
FROM public.netflix
GROUP BY 1
ORDER BY 2;
```

2. **Find the Most Common Rating for Movies and TV Shows**:
```sql
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
```

3. **List All Movies Released in a Specific Year (e.g., 2020)**:
```sql
SELECT * 
FROM netflix
WHERE type='Movie'
	AND 
	release_year='2020';
```

4. **Find the Top 5 Countries with the Most Content on Netflix**:
```sql
SELECT
	TRIM(UNNEST(STRING_TO_ARRAY(country,','))) AS country,
	COUNT(show_id) AS no_of_content
FROM public.netflix
GROUP BY 1
ORDER BY 2 DESC;
```

5. **Identify the Longest Movie**:
```sql
SELECT  
	title,
	duration
FROM netflix
WHERE type='Movie'
	AND 
	duration IS NOT NULL
ORDER BY SPLIT_PART(duration, ' ',1)::INT DESC ;
```

6. **Find Content Added in the Last 7 Years**:
```sql
SELECT 
	*
FROM netflix
WHERE EXTRACT(YEAR FROM CURRENT_DATE)-TRIM(SPLIT_PART(date_added,',',2))::INT>=7;
```

7. **Find All Movies/TV Shows by Director 'Rajiv Chilaka'**:
```sql
SELECT * 
FROM netflix
WHERE director='Rajiv Chilaka';
```

8. **List All TV Shows with More Than 5 Seasons**:
```sql
SELECT 
	title,
	type,
	duration
FROM netflix
WHERE type='TV Show'
	AND
	SPLIT_PART(duration,' ',1):: INT >=5
ORDER BY SPLIT_PART(duration,' ',1):: INT DESC;
```

9. **Count the Number of Content Items in Each Genre**:
```sql
SELECT 
	TRIM(UNNEST (STRING_TO_ARRAY(listed_in, ','))) AS genre,
	COUNT(show_id) AS no_of_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC;

SELECT * FROM public.netflix;
```

10. **Find each year and the average numbers of content release in India on netflix.**:
```sql
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
```

1. **Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords**:
```sql
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
```

## Conclusion

- **Content Distribution**: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings**: Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights**: he top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization**: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

## Author - HARSHIT RAI

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch! 
